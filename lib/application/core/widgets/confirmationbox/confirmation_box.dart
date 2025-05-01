import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_constants.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A reusable confirmation dialog widget that displays different states (success/error)
/// with customizable text content.
class ConfirmationBox extends StatelessWidget {
  /// Determines the type of confirmation ('success' or other values for error)
  final String? confirmationType;

  /// Main heading text displayed in the confirmation box
  final String? mainText;

  /// Optional secondary text displayed below the main text
  final String? subText;

  const ConfirmationBox({
    super.key,
    this.confirmationType,
    this.mainText,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    // Set icon and color based on confirmation type (success or error)
    final iconName = confirmationType == AppString.success.localize(context)!
        ? PhosphorIconsRegular.checkCircle
        : PhosphorIconsRegular.x;
    final mainTextColor =
        confirmationType == AppString.success.localize(context)!
            ? colors(context).colorPositive6 // Green for success
            : colors(context).colorNegative6; // Red for error

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 32,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(iconName, size: 64, color: mainTextColor),
            const SizedBox(height: 8),
            Text(
              mainText!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
                fontFamily: kFontFamily,
              ),
            ),
            const SizedBox(height: 24),

            // Optional secondary text section
            if (subText != null && subText!.isNotEmpty)
              Column(
                children: [
                  Text(
                    subText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors(context).colorBlack,
                      fontFamily: kFontFamily,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            CustomButton(
              text: AppString.close.localize(context)!,
              onPressed: () {},
              backgroundColor: colors(context).colorGrey1!,
            ),
          ],
        ),
      ),
    );
  }
}
