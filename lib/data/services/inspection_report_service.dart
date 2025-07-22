import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionReportService {
  static const String _inspectionReportsKey = 'saved_inspection_reports';

  /// Save inspection report data locally
  Future<bool> saveInspectionReportLocally({
    required String masterFileRef,
    required String buildingId,
    required String buildingName,
    required Map<String, dynamic> formData,
  }) async {
    try {
      print('🔍 Saving inspection report locally');
      print('   Master File Ref: $masterFileRef');
      print('   Building ID: $buildingId');
      print('   Building Name: $buildingName');

      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(_inspectionReportsKey) ?? '[]';
      final List<dynamic> reportsList = json.decode(reportsJson);

      // Create unique ID for this report
      final reportId =
          '${masterFileRef}_${buildingId}_${DateTime.now().millisecondsSinceEpoch}';

      // Create report data structure
      final reportData = {
        'id': reportId,
        'masterFileRef': masterFileRef,
        'buildingId': buildingId,
        'buildingName': buildingName,
        'formData': formData,
        'savedAt': DateTime.now().toIso8601String(),
        'syncStatus': 'pending', // pending, synced, failed
      };

      // Add the new report
      reportsList.add(reportData);

      // Save back to SharedPreferences
      await prefs.setString(_inspectionReportsKey, json.encode(reportsList));

      print('✅ Inspection report saved successfully');
      print('   Report ID: $reportId');
      print('   Total reports in storage: ${reportsList.length}');
      return true;
    } catch (e) {
      print('❌ Error saving inspection report: $e');
      return false;
    }
  }

  /// Get all saved inspection reports
  Future<List<Map<String, dynamic>>> getSavedReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(_inspectionReportsKey) ?? '[]';
      final List<dynamic> reportsList = json.decode(reportsJson);

      return reportsList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error getting saved reports: $e');
      return [];
    }
  }

  /// Get pending reports (not yet synced)
  Future<List<Map<String, dynamic>>> getPendingReports() async {
    try {
      final allReports = await getSavedReports();
      return allReports
          .where((report) => report['syncStatus'] == 'pending')
          .toList();
    } catch (e) {
      print('❌ Error getting pending reports: $e');
      return [];
    }
  }

  /// Update sync status of a report
  Future<bool> updateSyncStatus(String reportId, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(_inspectionReportsKey) ?? '[]';
      final List<dynamic> reportsList = json.decode(reportsJson);

      // Find and update the report
      for (int i = 0; i < reportsList.length; i++) {
        if (reportsList[i]['id'] == reportId) {
          reportsList[i]['syncStatus'] = status;
          if (status == 'synced') {
            reportsList[i]['syncedAt'] = DateTime.now().toIso8601String();
          }
          break;
        }
      }

      // Save back to SharedPreferences
      await prefs.setString(_inspectionReportsKey, json.encode(reportsList));
      return true;
    } catch (e) {
      print('❌ Error updating sync status: $e');
      return false;
    }
  }

  /// Delete a specific report
  Future<bool> deleteReport(String reportId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(_inspectionReportsKey) ?? '[]';
      final List<dynamic> reportsList = json.decode(reportsJson);

      // Remove the report with matching ID
      reportsList.removeWhere((report) => report['id'] == reportId);

      // Save back to SharedPreferences
      await prefs.setString(_inspectionReportsKey, json.encode(reportsList));
      return true;
    } catch (e) {
      print('❌ Error deleting report: $e');
      return false;
    }
  }

  /// Clear all synced reports to free up storage
  Future<bool> clearSyncedReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(_inspectionReportsKey) ?? '[]';
      final List<dynamic> reportsList = json.decode(reportsJson);

      // Keep only pending reports
      final pendingReports = reportsList
          .where((report) => report['syncStatus'] == 'pending')
          .toList();

      // Save back to SharedPreferences
      await prefs.setString(_inspectionReportsKey, json.encode(pendingReports));
      return true;
    } catch (e) {
      print('❌ Error clearing synced reports: $e');
      return false;
    }
  }
}
