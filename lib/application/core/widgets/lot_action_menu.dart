import 'package:flutter/material.dart';

class DialogClipper extends CustomClipper<Path> {
  final double pointerWidth;
  final double pointerHeight;
  final double cornerRadius;

  DialogClipper({
    this.pointerWidth = 16.0,
    this.pointerHeight = 10.0,
    this.cornerRadius = 12.0,
  });

  @override
  Path getClip(Size size) {
    // Create an empty path.
    Path path = Path();

    // Calculate the x-coordinate to center the pointer.
    double pointerX = (size.width - pointerWidth) / 2;

    // Add a rounded rectangle to the path.
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height - pointerHeight),
      topLeft: Radius.circular(cornerRadius),
      topRight: Radius.circular(cornerRadius),
      bottomLeft: Radius.circular(cornerRadius),
      bottomRight: Radius.circular(cornerRadius),
    ));

    // Draw the pointer (triangle) at the bottom center.
    path.moveTo(pointerX, size.height - pointerHeight);
    path.lineTo(pointerX + pointerWidth / 2, size.height);
    path.lineTo(pointerX + pointerWidth, size.height - pointerHeight);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// A dialog widget that presents a menu with two actions:
// "Sketch tool" and a report (either "Condition Report" or "Inspection Report")
// based on the provided source.
// - Land Acquisition shows "Condition Report"
// - Land Miscellaneous and other sources show "Inspection Report"
class LotActionMenu extends StatelessWidget {
  final VoidCallback onSketchTool;
  final VoidCallback onConditionReport;
  final VoidCallback onInspectionReport;

  // Optional source parameter to determine which report to display.
  final String source;

  const LotActionMenu({
    super.key,
    required this.onSketchTool,
    required this.onInspectionReport,
    required this.onConditionReport,
    this.source = '',
  });

  /// Safely pops the dialog if possible.
  void _safePop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the appropriate report text based on the source.
    final String reportText = source == 'landAcquisition'
        ? 'Condition Report'
        : 'Inspection Report'; // Land Miscellaneous and other sources get Inspection Report

    // The main dialog widget with custom clipping and styling.
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: SizedBox(
          width: 200,
          height: 90,
          child: ClipPath(
            // Apply the custom clipper to shape the dialog.
            clipper: DialogClipper(cornerRadius: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  // Add a subtle shadow for depth effect.
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // Layout the action options vertically.
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // First list tile for "Sketch tool" action.
                  ListTile(
                    title: const Text('Sketch tool',
                        style: TextStyle(fontSize: 14)),
                    onTap: () {
                      onSketchTool();
                      _safePop(context);
                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 0.0),
                    minVerticalPadding: 0,
                    dense: true,
                  ),
                  // Divider between options.
                  const Divider(height: 0, thickness: 1),
                  // Second list tile for report action.
                  ListTile(
                    title:
                        Text(reportText, style: const TextStyle(fontSize: 14)),
                    onTap: () {
                      // Invoke different callbacks based on the source.
                      if (source == 'landAcquisition') {
                        onConditionReport();
                      } else {
                        // Land Miscellaneous and other sources use Inspection Report
                        onInspectionReport();
                      }
                      _safePop(context);
                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 0.0),
                    minVerticalPadding: 0,
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
