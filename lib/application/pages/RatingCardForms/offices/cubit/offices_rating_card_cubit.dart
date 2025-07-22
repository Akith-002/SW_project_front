import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_autofill_model.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_model.dart';
import 'package:land_asset_valuation/domain/usecases/get_offices_rating_card_autofill.dart';
import 'package:land_asset_valuation/domain/usecases/save_offices_rating_card.dart';

part 'offices_rating_card_state.dart';

class OfficesRatingCardCubit extends Cubit<OfficesRatingCardState> {
  final SaveOfficesRatingCard saveOfficesRatingCard;
  final GetOfficesRatingCardAutofill getOfficesRatingCardAutofill;

  OfficesRatingCardCubit({
    required this.saveOfficesRatingCard,
    required this.getOfficesRatingCardAutofill,
  }) : super(OfficesRatingCardInitial());

  Future<void> loadAutofillData(int assetId) async {
    emit(OfficesRatingCardLoading());

    final result = await getOfficesRatingCardAutofill(assetId);

    result.fold(
      (failure) => emit(OfficesRatingCardError(failure.message)),
      (autofillData) => emit(OfficesRatingCardAutofillLoaded(autofillData)),
    );
  }

  Future<void> saveRatingCard(OfficesRatingCardModel ratingCard) async {
    emit(OfficesRatingCardSaving());

    final result = await saveOfficesRatingCard(ratingCard);

    result.fold(
      (failure) => emit(OfficesRatingCardError(failure.message)),
      (_) => emit(OfficesRatingCardSaved()),
    );
  }

  void resetState() {
    emit(OfficesRatingCardInitial());
  }
}