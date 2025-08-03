import 'dart:async';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_inspection_report_usecase.dart';
import 'package:land_asset_valuation/domain/repositories/inspection_report_repository.dart';
import 'package:land_asset_valuation/application/core/services/inspection_report_form_service.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';
import 'package:land_asset_valuation/data/services/inspection_report_sync_service.dart';
import 'package:land_asset_valuation/domain/usecases/get_master_data_usecase.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';

class InspectionReportCubit
    extends BaseCubit<BaseState<InspectionReportState>> {
  final AppSharedData appSharedData;
  final SendInspectionReportUseCase sendInspectionReportUseCase;
  final InspectionReportRepository repository;
  final ConnectivityService connectivityService;
  final InspectionReportSyncService syncService;
  final InspectionReportFormService formService;

  StreamSubscription<SyncStatus>? _syncSubscription;
  final GetMasterDataUseCase getMasterDataUseCase;

  InspectionReportCubit({
    required this.appSharedData,
    required this.sendInspectionReportUseCase,
    required this.repository,
    required this.connectivityService,
    required this.syncService,
    required this.getMasterDataUseCase,
  })  : formService = InspectionReportFormService(),
        super(InspectionReportInitial()) {
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

  Future<void> populateFormData({
    required Map<String, dynamic> landInfo,
    required Map<String, Map<String, dynamic>> buildingForms,
    required Map<String, dynamic> otherConstructions,
    required String masterFileNo,
    String? lotId,
  }) async {
    // Set master file data
    formService.formData.masterFileId = masterFileNo;
    formService.formData.masterFileRefNo = landInfo['masterFileRef'] ?? '';

    // Set inspection date
    if (landInfo['inspectionDate'] != null &&
        landInfo['inspectionDate'].isNotEmpty) {
      try {
        formService.formData.inspectionDate =
            DateTime.parse(landInfo['inspectionDate']);
      } catch (e) {
        formService.formData.inspectionDate = DateTime.now();
      }
    } else {
      formService.formData.inspectionDate = DateTime.now();
    }

    // Set location data
    formService.formData.district = landInfo['district'] ?? '';
    formService.formData.province = landInfo['province'] ?? '';
    formService.formData.dsDivision = landInfo['dsDivision'] ?? '';

    // Set other constructions data with correct field names
    formService.formData.otherInformation =
        otherConstructions['otherInfo'] ?? '';
    formService.formData.otherConstructionDetails =
        otherConstructions['otherConstructionDetails'] ?? '';
    formService.formData.detailsOfAssestsInventoryItems =
        otherConstructions['assetDetails'] ?? '';
    formService.formData.detailsOfBusiness =
        otherConstructions['businessDetails'] ?? '';
    formService.formData.remark = otherConstructions['remarks'] ?? '';

    // Process building forms data
    formService.formData.buildings.clear();
    for (final entry in buildingForms.entries) {
      final buildingData = entry.value;
      final building = InspectionReportBuilding(
        buildingId: buildingData['buildingId'] ?? '',
        buildingName: buildingData['buildingName'] ?? '',
        buildingCategory: buildingData['buildingCategory'] ?? '',
        buildingClass: buildingData['buildingClass'] ?? '',
        detailOfBuilding: buildingData['buildingDetails'] ?? '',
        noOfFloorsAboveGround: buildingData['noOfFloorsGPlus'] ?? '0',
        noOfFloorsBelowGround: buildingData['noOfFloorsGMinus'] ?? '0',
        ageYears: buildingData['age'] ?? '0',
        expectedLifePeriodYears: buildingData['expectedLifePeriod'] ?? '0',
        parkingSpace: buildingData['parkingSpace'] ?? '',
        design: buildingData['design'] ?? '',
        conveniences: buildingData['conveniences'] ?? '',
        structure: buildingData['structure'] ?? '',
        buildingConditions: buildingData['buildingConditions'] ?? '',
        natureOfConstruction: buildingData['natureOfConstruction'] ?? '',
        condition: buildingData['buildingConditions'] ?? '',
        roofMaterial: buildingData['roofMaterial'] ?? '',
        roofFrame: buildingData['roofFrame'] ?? '',
        roofFinisher: buildingData['roofFinisher'] ?? '',
        ceiling: buildingData['ceiling'] ?? '',
        foundationStructure: buildingData['foundationStructure'] ?? '',
        wallStructure: buildingData['wallStructure'] ?? '',
        floorStructure: buildingData['floorStructure'] ?? '',
        door: buildingData['door'] ?? '',
        window: buildingData['window'] ?? '',
        windowProtection: buildingData['windowProtection'] ?? '',
        bathroomToiletDoorsFittings:
            buildingData['bathroomToiletDoorsFittings'] ?? '',
        handRail: buildingData['handRail'] ?? '',
        pantryCupboard: buildingData['pantryCupboard'] ?? '',
        otherDoors: buildingData['otherDoors'] ?? '',
        wallFinisher: buildingData['wallFinisher'] ?? '',
        floorFinisher: buildingData['floorFinisher'] ?? '',
        bathroomToilet: buildingData['bathroomToilet'] ?? '',
        services: buildingData['services'] ?? '',
      );
      formService.formData.buildings.add(building);
    }

    print('======= FORM DATA POPULATED =======');
    print('Master File ID: ${formService.formData.masterFileId}');
    print('Master File Ref: ${formService.formData.masterFileRefNo}');
    print('Buildings Count: ${formService.formData.buildings.length}');
    print('=====================================');
  }

  Future<void> sendInspectionReport(String masterFileId) async {
    emit(InspectionReportLoading());

    // Use the pre-populated form data
    final reportModel = formService.formData.toInspectionReportModel();

    print('======= CUBIT: CREATING INSPECTION REPORT MODEL =======');
    print('Master File ID: ${reportModel.masterFileId}');
    print('Master File Ref No: ${reportModel.masterFileRefNo}');
    print('Inspection Date: ${reportModel.inspectionDate.toIso8601String()}');
    print('Buildings Count: ${reportModel.buildings.length}');
    print('Data being prepared for API call...');
    print('===========================================');

    final result = await sendInspectionReportUseCase(reportModel);

    // Check if device was offline and report was saved locally
    final isConnected = await connectivityService.isConnected;

    result.fold(
      (failure) {
        // Handle specific authentication errors
        if (failure.message.toLowerCase().contains('unauthorized') ||
            failure.message.toLowerCase().contains('401')) {
          emit(InspectionReportSubmitFailure(
              'Authentication failed. Please login again and try.'));
        } else {
          emit(InspectionReportSubmitFailure(failure.message));
        }
      },
      (success) {
        if (!isConnected) {
          // Report was saved offline
          repository.getPendingReportsCount().then((count) {
            emit(InspectionReportSavedOffline(count));
          });
        } else {
          emit(InspectionReportSubmitSuccess());
        }
      },
    );
  }

  void _listenToSyncUpdates() {
    _syncSubscription = syncService.syncStatusStream.listen((status) {
      switch (status) {
        case SyncStatus.syncing:
          repository.getPendingReportsCount().then((count) {
            emit(InspectionReportSyncing(count));
          });
          break;
        case SyncStatus.completed:
          emit(InspectionReportSyncCompleted(0));
          break;
        case SyncStatus.failed:
          // Handle sync failure if needed
          break;
      }
    });
  }

  Future<void> retrySync() async {
    await syncService.startSyncIfPossible();
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }
}
