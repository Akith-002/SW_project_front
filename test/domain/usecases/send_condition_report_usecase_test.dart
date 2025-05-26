import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:land_asset_valuation/domain/repositories/condition_report_repository.dart';
import 'package:land_asset_valuation/domain/usecases/send_condition_report_usecase.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';

import 'send_condition_report_usecase_test.mocks.dart';

@GenerateMocks([ConditionReportRepository])
void main() {
  late SendConditionReportUseCase useCase;
  late MockConditionReportRepository mockRepository;

  setUp(() {
    mockRepository = MockConditionReportRepository();
    useCase = SendConditionReportUseCase(mockRepository);
  });

  final tConditionReportModel = ConditionReportModel(
    id: 1,
    masterFileId: "masterFileId123",
    nameOfTheVillage: "villageName",
    nameOfTheLand: "landName",
    atPlanNumber: "atPlan123",
    atLotNumber: "atLot123",
    ppCadNumber: "ppCad123",
    ppCadLotNumber: "ppCadLot123",
    acquiredExtent: "100sqm",
    assessmentNumber: "assess123",
    roadName: "roadName",
    accessCategory: "mainRoad",
    accessCategoryDescription: "Access via main road",
    descriptionOfLand: "description",
    landUseDescription: "residential",
    landUseType: "residential",
    frontage: "10m",
    depthOfLand: "20m",
    levelWithAccess: "level",
    plantationDetails: "none",
    detailsOfBusiness: "none",
    acquisitionName: "acquisitionName",
    datePrepared: DateTime.now().toIso8601String(),
    dateOfSection3BA: DateTime.now().toIso8601String(),
    boundaryNorth: "northBoundary",
    boundaryEast: "eastBoundary",
    boundaryWest: "westBoundary",
    boundarySouth: "southBoundary",
    boundaryBottom: "bottomBoundary",
    buildingDescription: "buildingDescription",
    buildingInfo: "buildingInfo",
    otherConstructionsDescription: "otherConstructionsDescription",
    otherConstructionsInfo: "otherConstructionsInfo",
    acquiringOfficerSignature: "acquiringOfficerSignature.png",
    gramasewakaSignature: "gramasewakaSignature.png",
    chiefValuerRepresentativeSignature:
        "chiefValuerRepresentativeSignature.png",
  );

  test(
    'should return true from repository when sending condition report is successful',
    () async {
      // arrange
      when(mockRepository.sendConditionReport(tConditionReportModel))
          .thenAnswer((_) async => const Right(true));
      // act
      final result = await useCase(tConditionReportModel);
      // assert
      expect(result, const Right(true));
      verify(mockRepository.sendConditionReport(tConditionReportModel));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return ServerFailure from repository when sending condition report is unsuccessful',
    () async {
      // arrange
      final serverFailure = ServerFailure('Server Error');
      when(mockRepository.sendConditionReport(tConditionReportModel))
          .thenAnswer((_) async => Left(serverFailure));
      // act
      final result = await useCase(tConditionReportModel);
      // assert
      expect(result, Left(serverFailure));
      verify(mockRepository.sendConditionReport(tConditionReportModel));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
