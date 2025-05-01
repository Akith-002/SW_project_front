import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class SDataActionMenu extends StatelessWidget {
  final void Function()? onViewUpdateDetails;
  final void Function()? onChangeType;
  final void Function()? onDelete;
  final void Function()? onSketchTool; // Add this callback
  final String source; // Add source parameter

  const SDataActionMenu({
    super.key,
    this.onViewUpdateDetails,
    this.onChangeType,
    this.onDelete,
    this.onSketchTool, // Add to constructor
    this.source = '', // Add to constructor with default
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the sketch tool option should be shown
    final bool showSketchToolOption = source == 'MRrentalEvidence';
    // Adjust height based on whether the sketch tool option is shown
    final double dialogHeight = showSketchToolOption ? 240.28 : 188.28;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.center, // Center the dialog
        child: Transform.translate(
          offset:
              Offset(0, -20), // Move it slightly up to align pointer to center
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipPath(
                clipper: DialogClipper(),
                child: Container(
                  width: 295,
                  height: dialogHeight, // Use dynamic height
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildListItem(
                        context,
                        "View / Update details",
                        onViewUpdateDetails,
                      ),
                      SizedBox(height: 12),
                      _buildListItem(
                        context,
                        "Change type",
                        onChangeType,
                      ),
                      SizedBox(height: 12),
                      _buildListItem(
                        context,
                        "Delete",
                        onDelete,
                      ),
                      // Conditionally add the Sketch Tool option
                      if (showSketchToolOption) ...[
                        SizedBox(height: 12),
                        _buildListItem(
                          context,
                          "Sketch tools",
                          onSketchTool, // Use the new callback
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String title,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
        // Pop only if the tap handler exists, otherwise let the handler pop
        if (onTap != null && Navigator.canPop(context)) {
          Navigator.pop(context); // Close the dialog
        }
      },
      child: Container(
        width: 255,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppStyling.normalTextSize20,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors(context).colorGrey10,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class DialogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double cornerRadius = 12;
    double pointerWidth = 16;
    double pointerHeight = 10;
    double pointerX = size.width / 2 - pointerWidth / 2;

    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height - pointerHeight),
        Radius.circular(cornerRadius)));

    path.moveTo(pointerX, size.height - pointerHeight);
    path.lineTo(pointerX + pointerWidth / 2, size.height);
    path.lineTo(pointerX + pointerWidth, size.height - pointerHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
