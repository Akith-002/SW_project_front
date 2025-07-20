import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_condition_report_usecase.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';
import 'package:land_asset_valuation/domain/usecases/get_master_data_usecase.dart';

class ConditionReportCubit extends BaseCubit<ConditionReportState> {
  final AppSharedData appSharedData;
  final SendConditionReportUseCase sendConditionReportUseCase;
  final GetMasterDataUseCase getMasterDataUseCase;

  ConditionReportCubit({
    required this.appSharedData,
    required this.sendConditionReportUseCase,
    required this.getMasterDataUseCase,
  }) : super(ConditionReportInitial());

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

    // Debug: Print result
    print('======= CUBIT: GOT RESULT FROM USE CASE =======');
    print('Success: ${result.isRight()}');
    if (result.isLeft()) {
      print('Error: ${result.fold((l) => l.message, (r) => "No error")}');
    }
    print('===========================================');

    result.fold(
      (failure) => emit(ConditionReportSubmitFailure(failure.message)),
      (success) => emit(ConditionReportSubmitSuccess()),
    );
  }
}
