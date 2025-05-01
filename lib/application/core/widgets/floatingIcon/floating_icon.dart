import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A custom floating action button with a Phosphor icon.
///
/// This widget creates a circular floating action button with a customizable
/// Phosphor icon. It allows for configuration of the icon size, color,
/// and the action to perform when pressed.
class FloatingIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final PhosphorFlatIconData icon;
  final double?
      size; // Optional size of the icon (default size is used if null)
  final Color?
      colorName; // Optional color of the icon (default color is used if null)

  const FloatingIcon({
    super.key,
    required this.onPressed,
    required this.size,
    required this.colorName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: CircleBorder(),
      backgroundColor: colors(context).colorWhite,
      child: PhosphorIcon(
        icon,
        size: size,
        color: colorName,
      ),
    );
  }
}
