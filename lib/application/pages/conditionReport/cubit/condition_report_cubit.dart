import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_condition_report_usecase.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';

class ConditionReportCubit extends BaseCubit<BaseState<ConditionReportState>> {
  final AppSharedData appSharedData;
  final SendConditionReportUseCase sendConditionReportUseCase;

  ConditionReportCubit({
    required this.appSharedData,
    required this.sendConditionReportUseCase,
  }) : super(ConditionReportInitial());

  Future<void> sendConditionReport(String masterFileId) async {
    emit(ConditionReportLoading());

    // Get the form data service
    final formService = ConditionReportFormService();
    final reportModel =
        formService.formData.toConditionReportModel(masterFileId);

    // Debug: Print in the cubit
    print('======= CUBIT: CREATING CONDITION REPORT MODEL =======');
    print('Master File ID: ${reportModel.masterFileId}');
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
      (success) => emit(ConditionReportSubmitSuccess()),
    );
  }
}
