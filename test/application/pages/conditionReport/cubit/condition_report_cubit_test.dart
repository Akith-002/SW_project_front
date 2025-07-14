import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_cubit.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';
import 'package:land_asset_valuation/domain/usecases/send_condition_report_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'condition_report_cubit_test.mocks.dart';

@GenerateMocks([SendConditionReportUseCase, AppSharedData])
void main() {
  late ConditionReportCubit conditionReportCubit;
  late MockSendConditionReportUseCase mockSendConditionReportUseCase;
  late MockAppSharedData mockAppSharedData;

  setUp(() {
    mockSendConditionReportUseCase = MockSendConditionReportUseCase();
    mockAppSharedData = MockAppSharedData();
    conditionReportCubit = ConditionReportCubit(
      sendConditionReportUseCase: mockSendConditionReportUseCase,
      appSharedData: mockAppSharedData,
    );
  });

  tearDown(() {
    conditionReportCubit.close();
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

  const tMasterFileId = 'masterFileId123';

  test('initial state should be ConditionReportInitial', () {
    expect(conditionReportCubit.state.runtimeType, ConditionReportInitial);
  });

  blocTest<ConditionReportCubit, dynamic>(
    'emits [ConditionReportLoading, ConditionReportSubmitSuccess] when sendConditionReport is successful',
    build: () {
      // The ConditionReportFormService().formData.toConditionReportModel(masterFileId) call inside the cubit
      // will create a new instance of ConditionReportModel. We need to mock the use case to accept any ConditionReportModel
      // or ensure the model created in the test matches exactly the one created in the cubit.
      // For simplicity, we'll use `any` for the model argument in the mock setup.
      when(mockSendConditionReportUseCase.call(any))
          .thenAnswer((_) async => const Right(true));
      return conditionReportCubit;
    },
    act: (cubit) => cubit.sendConditionReport(tMasterFileId),
    expect: () => [
      isA<ConditionReportLoading>(),
      isA<ConditionReportSubmitSuccess>(),
    ],
    verify: (_) {
      verify(mockSendConditionReportUseCase.call(any)).called(1);
    },
  );

  blocTest<ConditionReportCubit, dynamic>(
    'emits [ConditionReportLoading, ConditionReportSubmitFailure] when sendConditionReport fails',
    build: () {
      when(mockSendConditionReportUseCase.call(any))
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return conditionReportCubit;
    },
    act: (cubit) => cubit.sendConditionReport(tMasterFileId),
    expect: () => [
      isA<ConditionReportLoading>(),
      isA<ConditionReportSubmitFailure>().having(
          (state) => state.errorMessage, 'errorMessage', 'Server Error'),
    ],
    verify: (_) {
      verify(mockSendConditionReportUseCase.call(any)).called(1);
    },
  );
}
