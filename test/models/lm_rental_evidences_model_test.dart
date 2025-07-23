import 'package:flutter_test/flutter_test.dart';
import 'package:land_asset_valuation/data/models/lm_rental_evidences_model.dart';

void main() {
  group('LmRentalEvidencesModel Tests', () {
    test('should create model with correct data types', () {
      // Arrange
      final model = LmRentalEvidencesModel(
        landMiscellaneousMasterFileId: 72,
        masterFileRefNo: 'Metro 2/LA/52417',
        assessmentNo: 'test_assessment',
        owner: 'test_owner',
        occupier: 'test_occupier',
        description: 'test_description',
        floorRate: '100.50',
        ratePer: '200.75',
        ratePerMonth: '300.25',
        locationLongitude: '79.8612',
        locationLatitude: '6.9271',
        headOfTerms: 'test_terms',
        situation: 'test_situation',
        remarks: 'test_remarks',
      );

      // Assert
      expect(model.landMiscellaneousMasterFileId, 72);
      expect(model.masterFileRefNo, 'Metro 2/LA/52417');
      expect(model.assessmentNo, 'test_assessment');
      expect(model.floorRate, '100.50');
      expect(model.ratePer, '200.75');
      expect(model.ratePerMonth, '300.25');
    });

    test('should serialize to JSON with correct API format', () {
      // Arrange
      final model = LmRentalEvidencesModel(
        landMiscellaneousMasterFileId: 72,
        masterFileRefNo: 'Metro 2/LA/52417',
        assessmentNo: 'test_assessment',
        owner: 'test_owner',
        occupier: 'test_occupier',
        description: 'test_description',
        floorRate: '100.50',
        ratePer: '200.75',
        ratePerMonth: '300.25',
        locationLongitude: '79.8612',
        locationLatitude: '6.9271',
        headOfTerms: 'test_terms',
        situation: 'test_situation',
        remarks: 'test_remarks',
      );

      // Act
      final json = model.toJson();

      // Assert - Check all expected API fields are present
      expect(json['masterFileRefNo'], 'Metro 2/LA/52417');
      expect(json['landMiscellaneousMasterFileId'], 72);
      expect(json['assessmentNo'], 'test_assessment');
      expect(json['owner'], 'test_owner');
      expect(json['occupier'], 'test_occupier');
      expect(json['description'], 'test_description');
      expect(json['floorRate'], '100.50');
      expect(json['ratePer'], '200.75');
      expect(json['ratePerMonth'], '300.25');
      expect(json['locationLongitude'], '79.8612');
      expect(json['locationLatitude'], '6.9271');
      expect(json['headOfTerms'], 'test_terms');
      expect(json['situation'], 'test_situation');
      expect(json['remarks'], 'test_remarks');

      // Ensure no old field names are present
      expect(json.containsKey('masterFileId'), false);
      expect(json.containsKey('floorRateSQFT'), false);
      expect(json.containsKey('ratePerSqft'), false);
    });

    test('should deserialize from JSON response format', () {
      // Arrange - Sample response from your API specification
      final jsonResponse = {
        'id': 8,
        'reportId': 115,
        'masterFileRefNo': 'Metro 2/LA/52417',
        'landMiscellaneousMasterFileId': 72,
        'assessmentNo': 'test_assessment',
        'owner': 'test_owner',
        'occupier': 'test_occupier',
        'description': 'test_description',
        'floorRate': '100.50',
        'ratePer': '200.75',
        'ratePerMonth': '300.25',
        'locationLongitude': '79.8612',
        'locationLatitude': '6.9271',
        'headOfTerms': 'test_terms',
        'situation': 'test_situation',
        'remarks': 'test_remarks',
      };

      // Act
      final model = LmRentalEvidencesModel.fromJson(jsonResponse);

      // Assert
      expect(model.id, 8);
      expect(model.landMiscellaneousMasterFileId, 72);
      expect(model.masterFileRefNo, 'Metro 2/LA/52417');
      expect(model.assessmentNo, 'test_assessment');
      expect(model.floorRate, '100.50');
      expect(model.ratePer, '200.75');
      expect(model.ratePerMonth, '300.25');
    });

    test('should handle missing fields in fromJson', () {
      // Arrange - Minimal JSON
      final jsonResponse = {
        'landMiscellaneousMasterFileId': 72,
        'masterFileRefNo': 'Metro 2/LA/52417',
      };

      // Act
      final model = LmRentalEvidencesModel.fromJson(jsonResponse);

      // Assert
      expect(model.landMiscellaneousMasterFileId, 72);
      expect(model.masterFileRefNo, 'Metro 2/LA/52417');
      expect(model.assessmentNo, '');
      expect(model.owner, '');
      expect(model.floorRate, '');
      expect(model.ratePer, '');
    });
  });
}
