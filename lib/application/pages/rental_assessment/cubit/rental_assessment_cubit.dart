import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/pages/rental_assessment/cubit/rental_assessment_state.dart';
import 'package:land_asset_valuation/domain/usecases/get_rental_assessments_usecase.dart';

class RentalAssessmentCubit extends Cubit<RentalAssessmentState> {
  final GetRentalAssessmentsUseCase getRentalAssessmentsUseCase;

  RentalAssessmentCubit({
    required this.getRentalAssessmentsUseCase,
  }) : super(RentalAssessmentInitial());

  Future<void> getRentalAssessments() async {
    try {
      emit(RentalAssessmentLoading());
      final rentalAssessments = await getRentalAssessmentsUseCase();
      emit(RentalAssessmentLoaded(rentalAssessments));
    } catch (e) {
      emit(RentalAssessmentError(e.toString()));
    }
  }
}
