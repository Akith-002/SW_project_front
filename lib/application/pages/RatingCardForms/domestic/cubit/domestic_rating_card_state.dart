part of 'domestic_rating_card_cubit.dart';

abstract class DomesticRatingCardState extends Equatable {
  const DomesticRatingCardState();

  @override
  List<Object?> get props => [];
}

class DomesticRatingCardInitial extends DomesticRatingCardState {}

class DomesticRatingCardLoading extends DomesticRatingCardState {}

class DomesticRatingCardSaving extends DomesticRatingCardState {}

class DomesticRatingCardAutofillLoaded extends DomesticRatingCardState {
  final DomesticRatingCardAutofillModel autofillData;

  const DomesticRatingCardAutofillLoaded(this.autofillData);

  @override
  List<Object> get props => [autofillData];
}

class DomesticRatingCardSaved extends DomesticRatingCardState {}

class DomesticRatingCardError extends DomesticRatingCardState {
  final String message;

  const DomesticRatingCardError(this.message);

  @override
  List<Object> get props => [message];
}
