import 'package:shared_preferences/shared_preferences.dart';

/// Service class for managing rental evidence data in SharedPreferences
class RentalEvidenceService {
  /// Clear all rental evidence data for a specific master file
  /// This removes all entries with keys matching pattern: lm_rental_evidence_{masterFileNo}_*
  Future<bool> clearRentalEvidencesForMasterFile(String masterFileNo) async {
    try {
      print('🗑️ Clearing rental evidences for master file: $masterFileNo');

      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Filter keys that match the rental evidence pattern for this master file
      final keyPrefix = 'lm_rental_evidence_${masterFileNo}_';
      final keysToRemove =
          keys.where((key) => key.startsWith(keyPrefix)).toList();

      print(
          '   Found ${keysToRemove.length} rental evidence entries to remove');
      print('   Keys to remove: $keysToRemove');

      // Remove all matching keys
      for (final key in keysToRemove) {
        await prefs.remove(key);
        print('   ✅ Removed key: $key');
      }

      print('✅ Rental evidences cleared for master file: $masterFileNo');
      return true;
    } catch (e) {
      print('❌ Error clearing rental evidences for master file: $e');
      return false;
    }
  }

  /// Clear all rental evidence data (useful for debugging or complete reset)
  Future<bool> clearAllRentalEvidences() async {
    try {
      print('🗑️ Clearing all rental evidence data');

      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Filter keys that match any rental evidence pattern
      final keysToRemove =
          keys.where((key) => key.startsWith('lm_rental_evidence_')).toList();

      print(
          '   Found ${keysToRemove.length} rental evidence entries to remove');

      // Remove all matching keys
      for (final key in keysToRemove) {
        await prefs.remove(key);
      }

      print('✅ All rental evidences cleared');
      return true;
    } catch (e) {
      print('❌ Error clearing all rental evidences: $e');
      return false;
    }
  }

  /// Get all rental evidence keys for a specific master file (useful for debugging)
  Future<List<String>> getRentalEvidenceKeysForMasterFile(
      String masterFileNo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final keyPrefix = 'lm_rental_evidence_${masterFileNo}_';
      final matchingKeys =
          keys.where((key) => key.startsWith(keyPrefix)).toList();

      print(
          '📋 Found ${matchingKeys.length} rental evidence keys for master file $masterFileNo');
      print('   Keys: $matchingKeys');

      return matchingKeys;
    } catch (e) {
      print('❌ Error getting rental evidence keys: $e');
      return [];
    }
  }

  /// Get count of rental evidence entries for a specific master file
  Future<int> getRentalEvidenceCountForMasterFile(String masterFileNo) async {
    try {
      final keys = await getRentalEvidenceKeysForMasterFile(masterFileNo);
      return keys.length;
    } catch (e) {
      print('❌ Error getting rental evidence count: $e');
      return 0;
    }
  }
}
