part of 'offices_rating_card_cubit.dart';

abstract class OfficesRatingCardState extends Equatable {
  const OfficesRatingCardState();

  @override
  List<Object?> get props => [];
}

class OfficesRatingCardInitial extends OfficesRatingCardState {}

class OfficesRatingCardLoading extends OfficesRatingCardState {}

class OfficesRatingCardSaving extends OfficesRatingCardState {}

class OfficesRatingCardAutofillLoaded extends OfficesRatingCardState {
  final OfficesRatingCardAutofillModel autofillData;

  const OfficesRatingCardAutofillLoaded(this.autofillData);

  @override
  List<Object> get props => [autofillData];
}

class OfficesRatingCardSaved extends OfficesRatingCardState {}

class OfficesRatingCardError extends OfficesRatingCardState {
  final String message;

  const OfficesRatingCardError(this.message);

  @override
  List<Object> get props => [message];
}