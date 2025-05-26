import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_autofill_model.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_model.dart';
import 'package:land_asset_valuation/domain/usecases/get_domestic_rating_card_autofill.dart';
import 'package:land_asset_valuation/domain/usecases/save_domestic_rating_card.dart';

part 'domestic_rating_card_state.dart';

class DomesticRatingCardCubit extends Cubit<DomesticRatingCardState> {
  final SaveDomesticRatingCard saveDomesticRatingCard;
  final GetDomesticRatingCardAutofill getDomesticRatingCardAutofill;

  DomesticRatingCardCubit({
    required this.saveDomesticRatingCard,
    required this.getDomesticRatingCardAutofill,
  }) : super(DomesticRatingCardInitial());

  Future<void> loadAutofillData(int assetId) async {
    emit(DomesticRatingCardLoading());

    final result = await getDomesticRatingCardAutofill(assetId);

    result.fold(
      (failure) => emit(DomesticRatingCardError(failure.message)),
      (autofillData) => emit(DomesticRatingCardAutofillLoaded(autofillData)),
    );
  }

  Future<void> saveRatingCard(DomesticRatingCardModel ratingCard) async {
    emit(DomesticRatingCardSaving());

    final result = await saveDomesticRatingCard(ratingCard);

    result.fold(
      (failure) => emit(DomesticRatingCardError(failure.message)),
      (_) => emit(DomesticRatingCardSaved()),
    );
  }

  void resetState() {
    emit(DomesticRatingCardInitial());
  }
}
