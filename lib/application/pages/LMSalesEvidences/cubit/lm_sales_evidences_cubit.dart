import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LMSalesEvidences/cubit/lm_sales_evidences_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/data/models/lm_sales_evidences_model.dart';
import 'package:land_asset_valuation/domain/usecases/send_lm_sales_evidences_usecase.dart';

class LmSalesEvidencesCubit
    extends BaseCubit<BaseState<LmSalesEvidencesState>> {
  final AppSharedData appSharedData;
  final SendLmSalesEvidencesUseCase sendLmSalesEvidencesUseCase;

  LmSalesEvidencesCubit({
    required this.appSharedData,
    required this.sendLmSalesEvidencesUseCase,
  }) : super(LmSalesEvidencesInitial());

  /// Sends LM Sales Evidences data to the backend
  Future<void> sendLmSalesEvidences({
    required String assetNumber,
    required String masterFileRef,
    required String roadName,
    required String village,
    required String vendor,
    required String deedNumber,
    required String deedAttestedNumber,
    required String notaryName,
    required String lotNumber,
    required String planNumber,
    required String planDate,
    required String extent,
    required String consideration,
    required String remarks,
    required String rate,
    required String rateType,
    required String locationLongitude,
    required String locationLatitude,
    required String landRegistryReferences,
    required String situation,
    required String descriptionOfLand,
  }) async {
    emit(LmSalesEvidencesLoading());

    // Create the sales evidence model
    final salesEvidenceModel = LmSalesEvidencesModel(
      assetNumber: assetNumber,
      masterFileRef: masterFileRef,
      roadName: roadName,
      village: village,
      vendor: vendor,
      deedNumber: deedNumber,
      deedAttestedNumber: deedAttestedNumber,
      notaryName: notaryName,
      lotNumber: lotNumber,
      planNumber: planNumber,
      planDate: planDate,
      extent: extent,
      consideration: consideration,
      remarks: remarks,
      rate: rate,
      rateType: rateType,
      locationLongitude: locationLongitude,
      locationLatitude: locationLatitude,
      landRegistryReferences: landRegistryReferences,
      situation: situation,
      descriptionOfLand: descriptionOfLand,
    );

    // Debug: Print in the cubit
    print('======= LM SALES EVIDENCES CUBIT: CREATING MODEL =======');
    print('Asset Number: ${salesEvidenceModel.assetNumber}');
    print('Master File Ref: ${salesEvidenceModel.masterFileRef}');
    print('Vendor: ${salesEvidenceModel.vendor}');
    print('Consideration: ${salesEvidenceModel.consideration}');
    print('Rate: ${salesEvidenceModel.rate}');
    print('Data being prepared for API call...');
    print('===========================================');

    final result = await sendLmSalesEvidencesUseCase(salesEvidenceModel);

    // Debug: Print result
    print('======= LM SALES EVIDENCES CUBIT: GOT RESULT FROM USE CASE =======');
    print('Success: ${result.isRight()}');
    if (result.isLeft()) {
      print('Error: ${result.fold((l) => l.message, (r) => "No error")}');
    }
    print('===========================================');

    result.fold(
      (failure) => emit(LmSalesEvidencesSubmitFailure(failure.message)),
      (success) => emit(LmSalesEvidencesSubmitSuccess()),
    );
  }
}
