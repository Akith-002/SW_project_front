import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A reusable widget that displays undo and redo buttons in a styled container.
///
/// This widget provides a visually consistent way to add undo/redo functionality
/// across the application. The buttons are displayed side by side in a white
/// container with rounded corners and subtle shadow.
class UndoRedo extends StatelessWidget {
  final VoidCallback? onPressedUndo;
  final VoidCallback? onPressedRedo;

  const UndoRedo({super.key, this.onPressedUndo, this.onPressedRedo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colors(context).colorGrey3!,
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              // Undo button with left arc arrow icon
              IconButton(
                icon: PhosphorIcon(
                  PhosphorIconsRegular.arrowArcLeft,
                  size: 24,
                  color: colors(context).colorGrey4,
                ),
                onPressed: onPressedUndo,
              ),
              // Redo button with right arc arrow icon
              IconButton(
                icon: PhosphorIcon(
                  PhosphorIconsRegular.arrowArcRight,
                  size: 24,
                  color: colors(context).colorGrey4,
                ),
                onPressed: onPressedRedo,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
