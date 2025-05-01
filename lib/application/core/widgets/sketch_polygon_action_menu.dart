// filepath: d:\vd\app\vd_mobile_revamp\lib\application\core\widgets\sketch_polygon_action_menu.dart
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class SketchPolygonActionMenu extends StatelessWidget {
  final VoidCallback? onViewInside;
  final VoidCallback? onDelete;

  const SketchPolygonActionMenu({
    super.key,
    this.onViewInside,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const double dialogHeight = 136.28; // Adjusted height for 2 items

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.center, // Center the dialog
        child: Transform.translate(
          offset: const Offset(0, -20), // Move slightly up
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipPath(
                clipper: DialogClipper(), // Re-use the clipper if desired
                child: Container(
                  width: 295,
                  height: dialogHeight,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
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
                        "View Inside",
                        onViewInside,
                      ),
                      const SizedBox(height: 12),
                      _buildListItem(
                        context,
                        "Delete",
                        onDelete,
                      ),
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
        // Close the dialog first
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        // Then execute the action
        onTap?.call();
      },
      child: Container(
        width: 255,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
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

// You can reuse the DialogClipper from s_data_action_menu.dart
// or copy it here if you prefer separation.
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
