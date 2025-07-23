import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:land_asset_valuation/data/services/rental_evidence_service.dart';

void main() {
  group('RentalEvidenceService Tests', () {
    late RentalEvidenceService rentalEvidenceService;

    setUp(() {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      rentalEvidenceService = RentalEvidenceService();
    });

    test('should clear rental evidences for a specific master file', () async {
      // Set up test data - simulate existing rental evidence entries
      final prefs = await SharedPreferences.getInstance();

      // Add some test rental evidence entries for different master files
      await prefs.setString(
          'lm_rental_evidence_MF001_marker1', '{"data": "test1"}');
      await prefs.setString(
          'lm_rental_evidence_MF001_marker2', '{"data": "test2"}');
      await prefs.setString(
          'lm_rental_evidence_MF002_marker1', '{"data": "test3"}');
      await prefs.setString('other_key', '{"data": "other"}');

      // Verify initial state
      expect(
          prefs
              .getKeys()
              .where((key) => key.startsWith('lm_rental_evidence_'))
              .length,
          3);

      // Clear rental evidences for MF001
      final result = await rentalEvidenceService
          .clearRentalEvidencesForMasterFile('MF001');

      // Verify result
      expect(result, true);

      // Verify that only MF001 entries were removed
      final remainingKeys = prefs.getKeys();
      expect(remainingKeys.contains('lm_rental_evidence_MF001_marker1'), false);
      expect(remainingKeys.contains('lm_rental_evidence_MF001_marker2'), false);
      expect(remainingKeys.contains('lm_rental_evidence_MF002_marker1'), true);
      expect(remainingKeys.contains('other_key'), true);
    });

    test('should get count of rental evidence entries for master file',
        () async {
      final prefs = await SharedPreferences.getInstance();

      // Add test data
      await prefs.setString(
          'lm_rental_evidence_MF001_marker1', '{"data": "test1"}');
      await prefs.setString(
          'lm_rental_evidence_MF001_marker2', '{"data": "test2"}');
      await prefs.setString(
          'lm_rental_evidence_MF002_marker1', '{"data": "test3"}');

      // Test count
      final count = await rentalEvidenceService
          .getRentalEvidenceCountForMasterFile('MF001');
      expect(count, 2);

      final count2 = await rentalEvidenceService
          .getRentalEvidenceCountForMasterFile('MF002');
      expect(count2, 1);

      final count3 = await rentalEvidenceService
          .getRentalEvidenceCountForMasterFile('MF999');
      expect(count3, 0);
    });

    test('should clear all rental evidences', () async {
      final prefs = await SharedPreferences.getInstance();

      // Add test data
      await prefs.setString(
          'lm_rental_evidence_MF001_marker1', '{"data": "test1"}');
      await prefs.setString(
          'lm_rental_evidence_MF002_marker1', '{"data": "test2"}');
      await prefs.setString('other_key', '{"data": "other"}');

      // Clear all rental evidences
      final result = await rentalEvidenceService.clearAllRentalEvidences();

      // Verify result
      expect(result, true);

      // Verify that only rental evidence entries were removed
      final remainingKeys = prefs.getKeys();
      expect(
          remainingKeys
              .where((key) => key.startsWith('lm_rental_evidence_'))
              .length,
          0);
      expect(remainingKeys.contains('other_key'), true);
    });
  });
}
