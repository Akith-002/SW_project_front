import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

/// A customizable button widget with optional icon and loading state.
/// It automatically adjusts text and icon colors based on the background color.
class CustomButton extends StatelessWidget {
  // Text to display inside the button.
  final String text;
  // Callback function triggered when the button is pressed.
  final VoidCallback? onPressed;
  // Background color of the button.
  final Color backgroundColor;
  // Optional width of the button.
  final double? width;
  // Optional height of the button.
  final double? height;
  // Optional icon to display alongside the text.
  final IconData? icon;
  // Whether the button is in a loading state
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Set text/icon color based on background color.
    final textColor = backgroundColor == colors(context).colorGrey1
        ? colors(context).colorGrey2 ?? Colors.grey
        : colors(context).colorWhite ?? Colors.white;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        // Configure button appearance.
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // Add border only if the background color is a specific grey.
            side: backgroundColor == colors(context).colorGrey1
                ? BorderSide(
                    color:
                        colors(context).colorGrey5 ?? const Color(0xFFE5E7EA))
                : BorderSide.none,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display button text.
                  Text(
                    text,
                    style: AppStyling.buttonText.copyWith(color: textColor),
                  ),
                  // Optionally display an icon if provided.
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        icon,
                        size: 24,
                        // Match icon color to the text color.
                        color: textColor,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
