import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/la_sales_evidence_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/la_sales_evidence_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_sales_evidence_repository.dart';

/// Implementation of LA Sales Evidence repository
/// Handles data operations and error mapping for sales evidence
class LaSalesEvidenceRepositoryImpl extends LaSalesEvidenceRepository {
  final LaSalesEvidenceRemoteDataSource remoteDataSource;

  LaSalesEvidenceRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> sendLaSalesEvidence(
      LaSalesEvidenceModel salesEvidenceData) async {
    try {
      // Attempt to send sales evidence data to the remote data source
      final result =
          await remoteDataSource.sendLaSalesEvidence(salesEvidenceData);

      // Return success with the result
      return Right(result);
    } catch (e) {
      // Map different types of exceptions to appropriate failure types
      if (e.toString().contains('connection') ||
          e.toString().contains('network') ||
          e.toString().contains('timeout')) {
        return const Left(ServerFailure(
            'Network connection failed. Please check your internet connection.'));
      } else if (e.toString().contains('timeout')) {
        return const Left(
            ServerFailure('Request timed out. Please try again.'));
      } else if (e.toString().contains('certificate')) {
        return const Left(ServerFailure(
            'Security certificate error. Please contact support.'));
      } else {
        return Left(ServerFailure(
            'Failed to send sales evidence data: ${e.toString()}'));
      }
    }
  }
}
