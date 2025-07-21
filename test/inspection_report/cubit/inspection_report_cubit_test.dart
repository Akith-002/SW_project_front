import 'package:flutter_test/flutter_test.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';
import 'package:land_asset_valuation/application/core/services/inspection_report_form_service.dart';

void main() {
  group('Inspection Report Model Tests', () {
    test('should create InspectionReportModel with required fields', () {
      // Arrange
      final now = DateTime.now();
      final building = InspectionReportBuilding(
        buildingId: 'B001',
        buildingName: 'Test Building',
        buildingCategory: 'Residential',
        buildingClass: 'Modern',
        detailOfBuilding: 'A modern residential building',
        noOfFloorsAboveGround: '2',
        noOfFloorsBelowGround: '0',
        ageYears: '5',
        expectedLifePeriodYears: '50',
        parkingSpace: 'Available',
        design: 'Modern',
        conveniences: 'Full amenities',
        structure: 'RCC',
        buildingConditions: 'Good',
        natureOfConstruction: 'Permanent',
        condition: 'Good',
        roofMaterial: 'Concrete',
        roofFrame: 'Steel',
        roofFinisher: 'Paint',
        ceiling: 'Gypsum',
        foundationStructure: 'RCC',
        wallStructure: 'Brick',
        floorStructure: 'Concrete',
        door: 'Wooden',
        window: 'Glass',
        windowProtection: 'Grills',
        bathroomToiletDoorsFittings: 'Standard',
        handRail: 'Steel',
        pantryCupboard: 'Wooden',
        otherDoors: 'None',
        wallFinisher: 'Paint',
        floorFinisher: 'Tiles',
        bathroomToilet: 'Ceramic',
        services: 'Electricity',
      );

      // Act
      final model = InspectionReportModel(
        masterFileId: 'MF001',
        masterFileRefNo: 'REF001',
        inspectionDate: now,
        dsDivision: 'Test Division',
        district: 'Test District',
        province: 'Test Province',
        gnDivision: 'Test GN',
        village: 'Test Village',
        buildings: [building],
        otherInformation: 'Additional info',
        otherConstructionDetails: 'Construction details',
        detailsOfAssestsInventoryItems: 'Inventory details',
        detailsOfBusiness: 'Business details',
        remark: 'Test remarks',
      );

      // Assert
      expect(model.masterFileId, equals('MF001'));
      expect(model.masterFileRefNo, equals('REF001'));
      expect(model.district, equals('Test District'));
      expect(model.province, equals('Test Province'));
      expect(model.buildings.length, equals(1));
      expect(model.buildings.first.buildingId, equals('B001'));
      expect(model.buildings.first.buildingName, equals('Test Building'));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final now = DateTime.parse('2025-01-15T10:30:00.000Z');
      final building = InspectionReportBuilding(
        buildingId: 'B001',
        buildingName: 'Test Building',
        buildingCategory: 'Residential',
        buildingClass: 'Modern',
        detailOfBuilding: 'Test details',
        noOfFloorsAboveGround: '2',
        noOfFloorsBelowGround: '0',
        ageYears: '5',
        expectedLifePeriodYears: '50',
        parkingSpace: 'Yes',
        design: 'Modern',
        conveniences: 'Full',
        structure: 'RCC',
        buildingConditions: 'Good',
        natureOfConstruction: 'Permanent',
        condition: 'Good',
        roofMaterial: 'Concrete',
        roofFrame: 'Steel',
        roofFinisher: 'Paint',
        ceiling: 'Gypsum',
        foundationStructure: 'RCC',
        wallStructure: 'Brick',
        floorStructure: 'Concrete',
        door: 'Wooden',
        window: 'Glass',
        windowProtection: 'Grills',
        bathroomToiletDoorsFittings: 'Standard',
        handRail: 'Steel',
        pantryCupboard: 'Wooden',
        otherDoors: 'None',
        wallFinisher: 'Paint',
        floorFinisher: 'Tiles',
        bathroomToilet: 'Ceramic',
        services: 'Electricity',
      );

      final model = InspectionReportModel(
        masterFileId: 'MF001',
        masterFileRefNo: 'REF001',
        inspectionDate: now,
        dsDivision: 'Test Division',
        district: 'Test District',
        province: 'Test Province',
        gnDivision: 'Test GN',
        village: 'Test Village',
        buildings: [building],
        otherInformation: 'Additional info',
        otherConstructionDetails: 'Construction details',
        detailsOfAssestsInventoryItems: 'Inventory details',
        detailsOfBusiness: 'Business details',
        remark: 'Test remarks',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['masterFileId'], equals('MF001'));
      expect(json['masterFileRefNo'], equals('REF001'));
      expect(json['district'], equals('Test District'));
      expect(json['buildings'], isA<List>());
      expect(json['buildings'].length, equals(1));
      expect(json['buildings'][0]['buildingId'], equals('B001'));
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'masterFileId': 'MF001',
        'masterFileRefNo': 'REF001',
        'inspectionDate': '2025-01-15T10:30:00.000Z',
        'dsDivision': 'Test Division',
        'district': 'Test District',
        'province': 'Test Province',
        'gnDivision': 'Test GN',
        'village': 'Test Village',
        'buildings': [
          {
            'buildingId': 'B001',
            'buildingName': 'Test Building',
            'buildingCategory': 'Residential',
            'buildingClass': 'Modern',
            'detailOfBuilding': 'Test details',
            'noOfFloorsAboveGround': '2',
            'noOfFloorsBelowGround': '0',
            'ageYears': '5',
            'expectedLifePeriodYears': '50',
            'parkingSpace': 'Yes',
            'design': 'Modern',
            'conveniences': 'Full',
            'structure': 'RCC',
            'buildingConditions': 'Good',
            'natureOfConstruction': 'Permanent',
            'condition': 'Good',
            'roofMaterial': 'Concrete',
            'roofFrame': 'Steel',
            'roofFinisher': 'Paint',
            'ceiling': 'Gypsum',
            'foundationStructure': 'RCC',
            'wallStructure': 'Brick',
            'floorStructure': 'Concrete',
            'door': 'Wooden',
            'window': 'Glass',
            'windowProtection': 'Grills',
            'bathroomToiletDoorsFittings': 'Standard',
            'handRail': 'Steel',
            'pantryCupboard': 'Wooden',
            'otherDoors': 'None',
            'wallFinisher': 'Paint',
            'floorFinisher': 'Tiles',
            'bathroomToilet': 'Ceramic',
            'services': 'Electricity',
          }
        ],
        'otherInformation': 'Additional info',
        'otherConstructionDetails': 'Construction details',
        'detailsOfAssestsInventoryItems': 'Inventory details',
        'detailsOfBusiness': 'Business details',
        'remark': 'Test remarks',
      };

      // Act
      final model = InspectionReportModel.fromJson(json);

      // Assert
      expect(model.masterFileId, equals('MF001'));
      expect(model.masterFileRefNo, equals('REF001'));
      expect(model.district, equals('Test District'));
      expect(model.buildings.length, equals(1));
      expect(model.buildings.first.buildingId, equals('B001'));
    });
  });

  group('InspectionReportFormService Tests', () {
    late InspectionReportFormService formService;

    setUp(() {
      formService = InspectionReportFormService();
    });

    test('should initialize with empty form data', () {
      // Assert
      expect(formService.formData.masterFileId, equals(''));
      expect(formService.formData.masterFileRefNo, equals(''));
      expect(formService.formData.buildings, isEmpty);
      expect(formService.formData.otherInformation, equals(''));
    });

    test('should populate form data correctly', () {
      // Arrange & Act
      formService.formData.masterFileId = 'MF001';
      formService.formData.masterFileRefNo = 'REF001';
      formService.formData.district = 'Colombo';
      formService.formData.province = 'Western';
      formService.formData.inspectionDate = DateTime.parse('2025-01-15');

      final building = InspectionReportBuilding(
        buildingId: 'B001',
        buildingName: 'Test Building',
        buildingCategory: 'Residential',
        buildingClass: 'Modern',
        detailOfBuilding: 'Test details',
        noOfFloorsAboveGround: '2',
        noOfFloorsBelowGround: '0',
        ageYears: '5',
        expectedLifePeriodYears: '50',
        parkingSpace: 'Yes',
        design: 'Modern',
        conveniences: 'Full',
        structure: 'RCC',
        buildingConditions: 'Good',
        natureOfConstruction: 'Permanent',
        condition: 'Good',
        roofMaterial: 'Concrete',
        roofFrame: 'Steel',
        roofFinisher: 'Paint',
        ceiling: 'Gypsum',
        foundationStructure: 'RCC',
        wallStructure: 'Brick',
        floorStructure: 'Concrete',
        door: 'Wooden',
        window: 'Glass',
        windowProtection: 'Grills',
        bathroomToiletDoorsFittings: 'Standard',
        handRail: 'Steel',
        pantryCupboard: 'Wooden',
        otherDoors: 'None',
        wallFinisher: 'Paint',
        floorFinisher: 'Tiles',
        bathroomToilet: 'Ceramic',
        services: 'Electricity',
      );

      formService.formData.buildings.add(building);

      // Assert
      expect(formService.formData.masterFileId, equals('MF001'));
      expect(formService.formData.masterFileRefNo, equals('REF001'));
      expect(formService.formData.district, equals('Colombo'));
      expect(formService.formData.province, equals('Western'));
      expect(formService.formData.buildings.length, equals(1));
      expect(formService.formData.buildings.first.buildingId, equals('B001'));
    });

    test('should convert form data to API model correctly', () {
      // Arrange
      formService.formData.masterFileId = 'MF001';
      formService.formData.masterFileRefNo = 'REF001';
      formService.formData.district = 'Colombo';
      formService.formData.province = 'Western';
      formService.formData.inspectionDate = DateTime.parse('2025-01-15');
      formService.formData.otherInformation = 'Test info';
      formService.formData.remark = 'Test remarks';

      // Act
      final apiModel = formService.formData.toInspectionReportModel();

      // Assert
      expect(apiModel.masterFileId, equals('MF001'));
      expect(apiModel.masterFileRefNo, equals('REF001'));
      expect(apiModel.district, equals('Colombo'));
      expect(apiModel.province, equals('Western'));
      expect(apiModel.otherInformation, equals('Test info'));
      expect(apiModel.remark, equals('Test remarks'));
    });

    test('should generate detailed notes for debugging', () {
      // Arrange
      formService.formData.masterFileId = 'MF001';
      formService.formData.masterFileRefNo = 'REF001';
      formService.formData.district = 'Colombo';

      // Act
      final notes = formService.formData.generateDetailedNotes();

      // Assert
      expect(notes, contains('MF001'));
      expect(notes, contains('REF001'));
      expect(notes, contains('Colombo'));
      expect(notes, contains('INSPECTION REPORT INFORMATION'));
    });
  });
}
