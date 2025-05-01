import 'package:flutter/cupertino.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_constants.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';

/// A widget that displays a status indicator with different styling based on success or pending state.
/// Uses theme-specific colors to provide visual feedback about an operation's status.
class StatusIndicator extends StatelessWidget {
  /// Determines whether to show success or pending status
  /// `true` for success state, `false` for pending state
  final bool? isSuccessful;

  const StatusIndicator({super.key, this.isSuccessful});

  @override
  Widget build(BuildContext context) {
    final isSuccessful = this.isSuccessful ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // Set background color based on status state
        color: isSuccessful
            ? colors(context).colorPositive3
            : colors(context).colorNotice3,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isSuccessful
            ? AppString.success.localize(context)!
            : AppString.pending.localize(context)!,
        style: TextStyle(
          color: isSuccessful
              ? colors(context).colorPositive7
              : colors(context).colorNotice7,
          fontSize: 14,
          fontFamily: kFontFamily,
        ),
      ),
    );
  }
}
