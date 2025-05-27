import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class SuccessMessageCard extends StatelessWidget {
  final VoidCallback onClose;

  const SuccessMessageCard({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 212,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
              size: 48,
              color: colors(context).colorPositive1,
            ),
            const SizedBox(height: 12),
            Text(
              'Data Send successfully',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ).copyWith(color: colors(context).colorPositive1),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 87,
              height: 36,
              child: OutlinedButton(
                onPressed: onClose,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: colors(context).colorGrey5 ?? Colors.grey),
                  backgroundColor: colors(context).colorGrey1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
