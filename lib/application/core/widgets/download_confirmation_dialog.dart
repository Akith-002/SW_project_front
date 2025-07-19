import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class DownloadConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String requestNumber;

  const DownloadConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.requestNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 32,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.downloadSimple(PhosphorIconsStyle.regular),
              size: 64,
              color: colors(context).colorPrimary6,
            ),
            const SizedBox(height: 16),
            Text(
              'Download Request Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors(context).colorGrey8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Do you want to download information about request $requestNumber?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colors(context).colorGrey6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: colors(context).colorGrey5 ?? Colors.grey,
                      ),
                      backgroundColor: colors(context).colorGrey1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors(context).colorPrimary6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}