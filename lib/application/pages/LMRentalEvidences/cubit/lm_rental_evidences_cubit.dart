import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/application/pages/LMRentalEvidences/cubit/lm_rental_evidences_state.dart';
import 'package:land_asset_valuation/data/models/lm_rental_evidences_model.dart';
import 'package:land_asset_valuation/domain/usecases/send_lm_rental_evidences_usecase.dart';

class LmRentalEvidencesCubit
    extends BaseCubit<BaseState<LmRentalEvidencesState>> {
  final AppSharedData appSharedData;
  final SendLmRentalEvidencesUseCase sendLmRentalEvidencesUseCase;

  LmRentalEvidencesCubit({
    required this.appSharedData,
    required this.sendLmRentalEvidencesUseCase,
  }) : super(LmRentalEvidencesInitial());

  Future<void> sendLmRentalEvidence({
    required int landMiscellaneousMasterFileId,
    required String masterFileRefNo,
    required String assessmentNo,
    required String owner,
    required String occupier,
    required String description,
    required String floorRate,
    required String ratePer,
    required String ratePerMonth,
    required String locationLongitude,
    required String locationLatitude,
    required String headOfTerms,
    required String situation,
    required String remarks,
  }) async {
    emit(LmRentalEvidencesLoading());

    // Create the LM rental evidence model
    final reportModel = LmRentalEvidencesModel(
      landMiscellaneousMasterFileId: landMiscellaneousMasterFileId,
      masterFileRefNo: masterFileRefNo,
      assessmentNo: assessmentNo,
      owner: owner,
      occupier: occupier,
      description: description,
      floorRate: floorRate,
      ratePer: ratePer,
      ratePerMonth: ratePerMonth,
      locationLongitude: locationLongitude,
      locationLatitude: locationLatitude,
      headOfTerms: headOfTerms,
      situation: situation,
      remarks: remarks,
    );

    // Debug: Print in the cubit
    print('======= LM RENTAL EVIDENCES CUBIT: CREATING MODEL =======');
    print(
        'Land Miscellaneous Master File ID: ${reportModel.landMiscellaneousMasterFileId}');
    print('Assessment No: ${reportModel.assessmentNo}');
    print('Owner: ${reportModel.owner}');
    print('Data being prepared for API call...');
    print('===========================================');

    final result = await sendLmRentalEvidencesUseCase(reportModel);

    // Debug: Print result
    print(
        '======= LM RENTAL EVIDENCES CUBIT: GOT RESULT FROM USE CASE =======');
    print('Success: ${result.isRight()}');
    if (result.isLeft()) {
      print('Error: ${result.fold((l) => l.message, (r) => "No error")}');
    }
    print('===========================================');

    result.fold(
      (failure) => emit(LmRentalEvidencesSubmitFailure(failure.message)),
      (reportId) => emit(LmRentalEvidencesSubmitSuccess(reportId)),
    );
  }
}
