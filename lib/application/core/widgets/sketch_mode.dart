import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

/// Represents the available sketch tool modes in the application
enum SketchToolMode { marker, move, ruler }

/// A widget that provides toggle buttons for selecting different sketch tool modes
class SketchMode extends StatelessWidget {
  /// Callback triggered when the user selects a different sketch mode
  final ValueChanged<SketchToolMode>? onModeChanged;

  /// Currently selected mode (controlled from parent)
  final SketchToolMode selectedMode;

  const SketchMode({
    super.key,
    this.onModeChanged,
    required this.selectedMode,
  });

  /// Maps each sketch mode to its corresponding icon
  final Map<SketchToolMode, IconData> iconMap = const {
    SketchToolMode.marker: PhosphorIconsRegular.mapPinLine,
    SketchToolMode.move: PhosphorIconsRegular.arrowsOutCardinal,
    SketchToolMode.ruler: PhosphorIconsRegular.ruler,
  };

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final themeColors = colors(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: themeColors.colorWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: themeColors.colorBlack?.withOpacity(0.15) ?? Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      // Use minimum width to fit content
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: iconMap.entries.map((entry) {
          final mode = entry.key;
          final icon = entry.value;
          final isActive = selectedMode == mode;

          // Build button for this mode
          Widget button = GestureDetector(
            onTap: () => onModeChanged?.call(mode),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive
                    ? (themeColors.colorGrey3 ?? Colors.grey.shade300)
                    : (themeColors.colorWhite ?? Colors.white),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: themeColors.colorBlack?.withOpacity(0.1) ??
                        Colors.black12,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: Icon(
                icon,
                size: 22,
                color: themeColors.colorIconBlack ?? Colors.black87,
              ),
            ),
          );

          // Add spacing between buttons (except after the last one)
          if (mode != iconMap.keys.last) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [button, const SizedBox(width: 16)],
            );
          } else {
            return button;
          }
        }).toList(),
      ),
    );
  }
}
