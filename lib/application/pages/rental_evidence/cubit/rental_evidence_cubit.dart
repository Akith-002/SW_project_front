import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_rental_evidence_usecase.dart';
import 'package:land_asset_valuation/data/models/rental_evidence_model.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/cubit/rental_evidence_state.dart';

class RentalEvidenceCubit extends BaseCubit<BaseState<RentalEvidenceState>> {
  final AppSharedData appSharedData;
  final SendRentalEvidenceUseCase sendRentalEvidenceUseCase;

  RentalEvidenceCubit({
    required this.appSharedData,
    required this.sendRentalEvidenceUseCase,
  }) : super(RentalEvidenceInitial());

  Future<void> sendRentalEvidence({
    required String masterFileId,
    required String masterFileRefNo,
    required String assessmentNo,
    required String owner,
    required String occupier,
    required String description,
    required String floorRateSQFT,
    required String ratePerSqft,
    required String ratePerMonth,
    required String locationLongitude,
    required String locationLatitude,
    required String headOfTerms,
    required String situation,
    required String remarks,
  }) async {
    emit(RentalEvidenceLoading());

    // Create the rental evidence model
    final reportModel = RentalEvidenceModel(
      masterFileId: masterFileId,
      masterFileRefNo: masterFileRefNo,
      assessmentNo: assessmentNo,
      owner: owner,
      occupier: occupier,
      description: description,
      floorRateSQFT: floorRateSQFT,
      ratePerSqft: ratePerSqft,
      ratePerMonth: ratePerMonth,
      locationLongitude: locationLongitude,
      locationLatitude: locationLatitude,
      headOfTerms: headOfTerms,
      situation: situation,
      remarks: remarks,
    );

    // Debug: Print in the cubit
    print('======= CUBIT: CREATING RENTAL EVIDENCE MODEL =======');
    print('Master File ID: ${reportModel.masterFileId}');
    print('Assessment No: ${reportModel.assessmentNo}');
    print('Owner: ${reportModel.owner}');
    print('Data being prepared for API call...');
    print('===========================================');

    final result = await sendRentalEvidenceUseCase(reportModel);

    // Debug: Print result
    print('======= CUBIT: GOT RESULT FROM USE CASE =======');
    print('Success: ${result.isRight()}');
    if (result.isLeft()) {
      print('Error: ${result.fold((l) => l.message, (r) => "No error")}');
    }
    print('===========================================');

    result.fold(
      (failure) => emit(RentalEvidenceSubmitFailure(failure.message)),
      (success) => emit(RentalEvidenceSubmitSuccess()),
    );
  }
}
