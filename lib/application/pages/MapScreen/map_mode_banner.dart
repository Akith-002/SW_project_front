// lib/application/pages/map/widgets/map_mode_banner.dart (adjust path as needed)
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/sketch_mode.dart'; // Adjust path

class MapModeBanner extends StatelessWidget {
  final bool isDrawingMode;
  final bool isMarkerPlacementMode;
  final bool isSketchingMode;
  final bool isViewInsideMode;
  final String? selectedSketchTool;
  final SketchToolMode selectedSketchSubMode;

  const MapModeBanner({
    super.key,
    required this.isDrawingMode,
    required this.isMarkerPlacementMode,
    required this.isSketchingMode,
    this.isViewInsideMode = false,
    this.selectedSketchTool,
    required this.selectedSketchSubMode,
  });

  @override
  Widget build(BuildContext context) {
    String bannerText = "";
    Color bannerColor = Colors.grey[700]!.withOpacity(0.8);
    bool showBanner = false;

    if (isDrawingMode) {
      bannerText =
          "Drawing Initial Lot: Tap map corners. Click Save when done.";
      bannerColor = Colors.blueAccent.withOpacity(0.85);
      showBanner = true;
    } else if (isMarkerPlacementMode) {
      bannerText = "Add Marker: Tap map location to choose type";
      bannerColor = Colors.green.withOpacity(0.85);
      showBanner = true;
    } else if (isSketchingMode) {
      String toolHint = selectedSketchTool ?? "No shape selected";
      // Capitalize first letter of enum name
      String modeHint = selectedSketchSubMode.name[0].toUpperCase() +
          selectedSketchSubMode.name.substring(1);
      String interactionHint = "";
      switch (selectedSketchSubMode) {
        case SketchToolMode.marker:
          interactionHint = "| Draw: Tap map";
          if (selectedSketchTool == 'polygon') {
            interactionHint += " (tap start to close or Save)";
          } else if (selectedSketchTool == 'circle') {
            interactionHint = "| Draw: Tap center, then edge";
          } else if (selectedSketchTool == 'line') {
            interactionHint += " (click Save when done)";
          }
          break;
        case SketchToolMode.move:
          interactionHint = "| Move: Tap items (TBD)";
          break;
        case SketchToolMode.ruler:
          interactionHint = "| Ruler: Tap points (TBD)";
          break;
      }
      bannerText = "Sketch ($modeHint Mode) | Tool: $toolHint $interactionHint";
      bannerColor = Colors.orange[800]!.withOpacity(0.85);
      showBanner = true;
    } else if (isViewInsideMode) {
      bannerText = "View Inside: Tap map to select area";
      bannerColor = Colors.purple[700]!;
      showBanner = true;
    }

    if (!showBanner)
      return const SizedBox.shrink(); // Hide banner if no mode active

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: IgnorePointer(
          // Banner should not block map interactions
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            color: bannerColor,
            child: Text(
              bannerText,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
