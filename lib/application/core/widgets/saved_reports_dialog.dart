import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/data/services/inspection_report_service.dart';

class SavedReportsDialog extends StatefulWidget {
  const SavedReportsDialog({super.key});

  @override
  State<SavedReportsDialog> createState() => _SavedReportsDialogState();
}

class _SavedReportsDialogState extends State<SavedReportsDialog> {
  final InspectionReportService _service = InspectionReportService();
  List<Map<String, dynamic>> _savedReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedReports();
  }

  Future<void> _loadSavedReports() async {
    try {
      final reports = await _service.getSavedReports();
      setState(() {
        _savedReports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Error loading saved reports: $e'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    }
  }

  Future<void> _deleteReport(String reportId) async {
    final success = await _service.deleteReport(reportId);
    if (success) {
      setState(() {
        _savedReports.removeWhere((report) => report['id'] == reportId);
      });
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Report deleted successfully'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      }
    } else {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Failed to delete report'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Saved Inspection Reports',
                  style: AppStyling.semiBoldTextSize18.copyWith(
                    color: colors(context).textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_savedReports.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No saved reports found',
                        style: AppStyling.mediumTextSize16.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _savedReports.length,
                  itemBuilder: (context, index) {
                    final report = _savedReports[index];
                    final savedAt = DateTime.parse(report['savedAt']);
                    final syncStatus = report['syncStatus'] ?? 'pending';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: syncStatus == 'synced'
                              ? Colors.green
                              : Colors.orange,
                          child: Icon(
                            syncStatus == 'synced'
                                ? Icons.cloud_done
                                : Icons.cloud_queue,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          report['buildingName'] ?? 'Unknown Building',
                          style: AppStyling.mediumTextSize14,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Master File: ${report['masterFileRef'] ?? 'N/A'}',
                              style: AppStyling.normalTextSize12,
                            ),
                            Text(
                              'Saved: ${savedAt.day}/${savedAt.month}/${savedAt.year} ${savedAt.hour}:${savedAt.minute.toString().padLeft(2, '0')}',
                              style: AppStyling.normalTextSize12.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(
                                syncStatus.toUpperCase(),
                                style: AppStyling.normalTextSize12.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              backgroundColor: syncStatus == 'synced'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            IconButton(
                              onPressed: () => _deleteReport(report['id']),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Delete Report',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '${_savedReports.length} reports saved locally',
                  style: AppStyling.normalTextSize12.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
