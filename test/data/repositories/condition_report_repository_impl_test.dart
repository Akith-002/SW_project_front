import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/condition_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/datasource/local/condition_report_local_data_source.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';
import 'package:land_asset_valuation/data/services/condition_report_sync_service.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';
import 'package:land_asset_valuation/data/repositories/condition_report_repository_impl.dart';

import 'condition_report_repository_impl_test.mocks.dart';

// NOTE: If you see errors about missing MockConditionReportLocalDataSource, MockConnectivityService, or MockConditionReportSyncService,
// you need to re-run `flutter pub run build_runner build` to regenerate the mocks in condition_report_repository_impl_test.mocks.dart
@GenerateMocks([
  ConditionReportRemoteDataSource,
  ConditionReportLocalDataSource,
  ConnectivityService,
  ConditionReportSyncService,
])
void main() {
  late ConditionReportRepositoryImpl repository;
  late MockConditionReportRemoteDataSource mockRemoteDataSource;
  late MockConditionReportLocalDataSource mockLocalDataSource;
  late MockConnectivityService mockConnectivityService;
  late MockConditionReportSyncService mockSyncService;

  setUp(() {
    mockRemoteDataSource = MockConditionReportRemoteDataSource();
    mockLocalDataSource = MockConditionReportLocalDataSource();
    mockConnectivityService = MockConnectivityService();
    mockSyncService = MockConditionReportSyncService();
    repository = ConditionReportRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivityService: mockConnectivityService,
      syncService: mockSyncService,
    );
  });

  final tConditionReportModel = ConditionReportModel(
    id: 1, // Corrected: Changed to int
    masterFileId: 'masterFileId1',
    nameOfTheVillage: 'Test Village',
    nameOfTheLand: 'Test Land',
    atPlanNumber: 'ATPlan123',
    atLotNumber: 'ATLot456',
    ppCadNumber: 'PPCad789',
    ppCadLotNumber: 'PPCadLot101',
    acquiredExtent: '10 Acres',
    assessmentNumber: 'AssessNum001',
    roadName: 'Main Street',
    accessCategory: 'A',
    accessCategoryDescription: 'Good Access',
    descriptionOfLand: 'Flat land',
    landUseDescription: 'Agricultural',
    landUseType: 'Paddy',
    frontage: '100m',
    depthOfLand: '200m',
    levelWithAccess: 'Yes',
    plantationDetails: 'Coconut trees',
    detailsOfBusiness: 'N/A',
    acquisitionName: 'Gov Acquisition',
    datePrepared: DateTime.now().toIso8601String(),
    dateOfSection3BA: DateTime.now().toIso8601String(), // Added required field
    boundaryNorth: 'River',
    boundaryEast: 'Road',
    boundaryWest: 'Forest',
    boundarySouth: 'Another Land',
    boundaryBottom: 'N/A',
    buildingDescription: 'Old house',
    buildingInfo: 'Needs repair',
    otherConstructionsDescription: 'Well',
    otherConstructionsInfo: 'Functional',
    // notes: 'Some notes', // Removed: Not a parameter
    acquiringOfficerSignature: 'base64EncodedSignature', // Added required field
    gramasewakaSignature:
        'base64EncodedSignature', // Corrected name and added required field
    chiefValuerRepresentativeSignature:
        'base64EncodedSignature', // Corrected name and added required field
    // claimantSignature: 'base64EncodedSignature', // Removed: Not a parameter
    // officerInChargeSignature: 'base64EncodedSignature', // Removed: Not a parameter
    // valuationOfficerSignature: 'base64EncodedSignature', // Removed: Not a parameter
  );

  group('sendConditionReport', () {
    test(
      'should return true when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.sendConditionReport(any))
            .thenAnswer((_) async => true);
        // act
        final result =
            await repository.sendConditionReport(tConditionReportModel);
        // assert
        expect(result, const Right(true));
        verify(mockRemoteDataSource.sendConditionReport(tConditionReportModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return ServerFailure when the call to remote data source is unsuccessful (ServerException)',
      () async {
        // arrange
        when(mockRemoteDataSource.sendConditionReport(any))
            .thenThrow(ServerException());
        // act
        final result =
            await repository.sendConditionReport(tConditionReportModel);
        // assert
        expect(result, const Left(ServerFailure('Server error occurred')));
        verify(mockRemoteDataSource.sendConditionReport(tConditionReportModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NetworkFailure when the call to remote data source is unsuccessful (DioErrorException)',
      () async {
        // arrange
        when(mockRemoteDataSource.sendConditionReport(any))
            .thenThrow(DioErrorException());
        // act
        final result =
            await repository.sendConditionReport(tConditionReportModel);
        // assert
        expect(result, const Left(NetworkFailure('Network error occurred')));
        verify(mockRemoteDataSource.sendConditionReport(tConditionReportModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return ServerFailure for other exceptions',
      () async {
        // arrange
        when(mockRemoteDataSource.sendConditionReport(any))
            .thenThrow(Exception('Some other error'));
        // act
        final result =
            await repository.sendConditionReport(tConditionReportModel);
        // assert
        // The actual message might be 'Exception: Some other error'
        // Adjust if the implementation wraps it differently or provides a generic message.
        expect(result, isA<Left<Failure, bool>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected a Failure'),
        );
        verify(mockRemoteDataSource.sendConditionReport(tConditionReportModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
