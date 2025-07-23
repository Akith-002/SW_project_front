import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/pastValuation/cubit/past_valuation_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_past_valuation_usecase.dart';
import 'package:land_asset_valuation/data/models/past_valuation_model.dart';

class PastValuationCubit extends BaseCubit<BaseState<PastValuationState>> {
  final AppSharedData appSharedData;
  final SendPastValuationUseCase sendPastValuationUseCase;

  PastValuationCubit({
    required this.appSharedData,
    required this.sendPastValuationUseCase,
  }) : super(PastValuationInitial());

  Future<void> sendPastValuation({
    required String masterFileRef,
    required String fileNoGnDivision,
    required String situation,
    required String dateOfValuation,
    required String purposeOfValuation,
    required String planOfParticulars,
    required String extent,
    required String rate,
    required String rateType,
    required String remarks,
    required String locationLongitude,
    required String locationLatitude,
  }) async {
    emit(PastValuationLoading());

    // Create the past valuation model
    final reportModel = PastValuationModel(
      masterFileRef: masterFileRef,
      fileNoGnDivision: fileNoGnDivision,
      situation: situation,
      dateOfValuation: dateOfValuation,
      purposeOfValuation: purposeOfValuation,
      planOfParticulars: planOfParticulars,
      extent: extent,
      rate: rate,
      rateType: rateType,
      remarks: remarks,
      locationLongitude: locationLongitude,
      locationLatitude: locationLatitude,
    );

    // Debug: Print in the cubit
    print('======= CUBIT: CREATING PAST VALUATION MODEL =======');
    print('Master File Ref: ${reportModel.masterFileRef}');
    print('Situation: ${reportModel.situation}');
    print('Date of Valuation: ${reportModel.dateOfValuation}');
    print('Data being prepared for API call...');
    print('===========================================');

    final result = await sendPastValuationUseCase(reportModel);

    // Debug: Print result
    print('======= CUBIT: GOT RESULT FROM USE CASE =======');
    print('Success: ${result.isRight()}');
    if (result.isLeft()) {
      print('Error: ${result.fold((l) => l.message, (r) => "No error")}');
    }
    print('===========================================');

    result.fold(
      (failure) => emit(PastValuationSubmitFailure(failure.message)),
      (reportId) => emit(PastValuationSubmitSuccess(reportId)),
    );
  }
}
