import 'package:equatable/equatable.dart';
import 'package:land_asset_valuation/data/models/rental_assesment_model.dart';

abstract class RentalAssessmentState extends Equatable {
  const RentalAssessmentState();

  @override
  List<Object?> get props => [];
}

class RentalAssessmentInitial extends RentalAssessmentState {}

class RentalAssessmentLoading extends RentalAssessmentState {}

class RentalAssessmentLoaded extends RentalAssessmentState {
  final List<RentalAssessment> rentalAssessments;

  const RentalAssessmentLoaded(this.rentalAssessments);

  @override
  List<Object?> get props => [rentalAssessments];
}

class RentalAssessmentError extends RentalAssessmentState {
  final String message;

  const RentalAssessmentError(this.message);

  @override
  List<Object?> get props => [message];
}
