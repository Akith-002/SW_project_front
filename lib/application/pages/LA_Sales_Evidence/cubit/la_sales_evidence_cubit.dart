import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/data/models/la_sales_evidence_model.dart';
import 'package:land_asset_valuation/domain/usecases/send_la_sales_evidence_usecase.dart';
import 'package:logger/logger.dart';

class LaSalesEvidenceCubit extends BaseCubit<BaseState<LaSalesEvidenceState>> {
  final AppSharedData appSharedData;
  final SendLaSalesEvidenceUseCase sendLaSalesEvidenceUseCase;
  final Logger logger;

  LaSalesEvidenceCubit({
    required this.appSharedData,
    required this.sendLaSalesEvidenceUseCase,
    required this.logger,
  }) : super(LaSalesEvidenceInitial());

  /// Sends LA Sales Evidence data to the backend
  Future<void> sendLaSalesEvidence(
      LaSalesEvidenceModel salesEvidenceData) async {
    try {
      logger.d('🚀 Starting LA Sales Evidence submission process...');
      logger.d('📋 Sales Evidence Data: ${salesEvidenceData.toString()}');

      // Emit loading state
      emit(LaSalesEvidenceLoading());

      // Call the use case to send the data
      final result = await sendLaSalesEvidenceUseCase(salesEvidenceData);

      // Handle the result
      result.fold(
        (failure) {
          logger.e('❌ Failed to send LA Sales Evidence data');
          logger.e('💬 Failure message: ${failure.message}');
          emit(LaSalesEvidenceSubmitFailure(failure.message));
        },
        (success) {
          if (success) {
            logger.i('✅ LA Sales Evidence data sent successfully');
            emit(LaSalesEvidenceSubmitSuccess());
          } else {
            logger.w('⚠️ LA Sales Evidence submission returned false');
            emit(LaSalesEvidenceSubmitFailure(
                'Failed to send sales evidence data'));
          }
        },
      );
    } catch (e, stackTrace) {
      logger.e('💥 Unexpected error in LA Sales Evidence submission');
      logger.e('🐛 Error: $e');
      logger.e('📚 Stack trace: $stackTrace');
      emit(LaSalesEvidenceSubmitFailure('Unexpected error occurred: $e'));
    }
  }
}
