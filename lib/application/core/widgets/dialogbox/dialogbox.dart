import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_constants.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';

/// A customizable dialog widget that supports different types of alerts
/// with configurable appearance and actions.
///
/// The dialog includes an icon, main text, optional subtitle,
/// and two buttons (primary and secondary) with customizable actions.
class Dialogbox extends StatelessWidget {
  /// Determines the dialog's visual style and icon.
  /// Supported values: "approve", "delete", "edit"
  final String dialogType;
  final Color? color;
  final String mainText;
  final String? subText;
  final String?
      primaryButtonText; // Text for the primary action button (defaults to "Approved")
  final String?
      secondaryButtonText; // Text for the secondary action button (defaults to "Cancel")
  final VoidCallback? onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;

  const Dialogbox({
    super.key,
    required this.dialogType,
    this.color,
    required this.mainText,
    this.subText,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Map dialog types to their respective icon assets
    final iconMap = {
      "approve": "images/pngs/approve.png",
      "delete": "images/pngs/trash.png",
      "edit": "images/pngs/page-edit.png",
      "add": "images/pngs/add.png",
    };

    // Map dialog types to their respective text colors
    final mainTextColors = {
      "approve": colors(context).colorBlack,
      "delete": colors(context).colorNegative5,
      "edit": colors(context).colorBlack,
      "add": colors(context).colorBlack,
    };

    // Set default values or use provided ones
    final secondaryText =
        secondaryButtonText ?? AppString.cancel.localize(context)!;
    final primaryText =
        primaryButtonText ?? AppString.approved.localize(context)!;
    final buttonColor = color ?? colors(context).colorPrimary5;
    final mainTextColor =
        mainTextColors[dialogType] ?? colors(context).colorBlack;
    final iconImage = iconMap[dialogType] ?? "images/pngs/approve.png";

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: colors(context).colorWhite,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              mainText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
                fontFamily: kFontFamily,
              ),
            ),
            const SizedBox(height: 24),
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
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Secondary button
                CustomButton(
                  text: secondaryText,
                  onPressed: onSecondaryButtonPressed ?? () {},
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const SizedBox(width: 12),
                // Primary button
                CustomButton(
                  text: primaryText,
                  onPressed: onPrimaryButtonPressed ?? () {},
                  backgroundColor: buttonColor!,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
