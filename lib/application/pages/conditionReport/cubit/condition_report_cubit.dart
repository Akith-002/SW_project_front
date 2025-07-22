import 'dart:async';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_condition_report_usecase.dart';
import 'package:land_asset_valuation/domain/repositories/condition_report_repository.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';
import 'package:land_asset_valuation/data/services/condition_report_sync_service.dart';
import 'package:land_asset_valuation/domain/usecases/get_master_data_usecase.dart';

class ConditionReportCubit extends BaseCubit<ConditionReportState> {
  final AppSharedData appSharedData;
  final SendConditionReportUseCase sendConditionReportUseCase;
  final ConditionReportRepository repository;
  final ConnectivityService connectivityService;
  final ConditionReportSyncService syncService;

  StreamSubscription<SyncStatus>? _syncSubscription;
  final GetMasterDataUseCase getMasterDataUseCase;

  ConditionReportCubit({
    required this.appSharedData,
    required this.sendConditionReportUseCase,
    required this.repository,
    required this.connectivityService,
    required this.syncService,
    required this.getMasterDataUseCase,
  }) : super(ConditionReportInitial()) {
    _listenToSyncUpdates();
  }

  Future<void> fetchMasterData() async {
    emit(MasterDataLoading());
    try {
      final masterData = await getMasterDataUseCase();
      emit(MasterDataLoadSuccess(masterData));
    } catch (e) {
      emit(MasterDataLoadFailure(e.toString()));
    }
  }

  Future<void> sendConditionReport(String masterFileId) async {
    emit(ConditionReportLoading());

    // Get the form data service
    final formService = ConditionReportFormService();
    final reportModel =
        formService.formData.toConditionReportModel(masterFileId);

    // Debug: Print in the cubit
    print('======= CUBIT: CREATING CONDITION REPORT MODEL =======');
    print('Master File ID:  [32m${reportModel.masterFileId} [0m');
    print('Name of Village: ${reportModel.nameOfTheVillage}');
    print('Building Description: ${reportModel.buildingDescription}');
    print('Data being prepared for API call...');
    print('===========================================');

    final result = await sendConditionReportUseCase(reportModel);

    // Check if device was offline and report was saved locally
    final isConnected = await connectivityService.isConnected;

    result.fold(
      (failure) {
        // Handle specific authentication errors
        if (failure.message.toLowerCase().contains('unauthorized') ||
            failure.message.toLowerCase().contains('401')) {
          emit(ConditionReportSubmitFailure(
              'Authentication failed. Please login again and try.'));
        } else {
          emit(ConditionReportSubmitFailure(failure.message));
        }
      },
      (success) async {
        if (!isConnected) {
          // If offline, show that it was saved locally
          final pendingCount = await repository.getPendingReportsCount();
          emit(ConditionReportSavedOffline(pendingCount));
        } else {
          emit(ConditionReportSubmitSuccess());
        }
      },
    );
  }

  void _listenToSyncUpdates() {
    _syncSubscription = syncService.syncStatusStream.listen((status) async {
      switch (status) {
        case SyncStatus.syncing:
          final pendingCount = await repository.getPendingReportsCount();
          emit(ConditionReportSyncing(pendingCount));
          break;
        case SyncStatus.completed:
          final pendingCount = await repository.getPendingReportsCount();
          if (pendingCount == 0) {
            emit(ConditionReportSyncCompleted(0));
          }
          break;
        case SyncStatus.failed:
          // Handle sync failure if needed
          break;
        case SyncStatus.idle:
          // Handle idle state if needed
          break;
      }
    });
  }

  Future<void> retrySync() async {
    await syncService.syncPendingReports();
  }

  Future<int> getPendingReportsCount() async {
    return await repository.getPendingReportsCount();
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }
}
