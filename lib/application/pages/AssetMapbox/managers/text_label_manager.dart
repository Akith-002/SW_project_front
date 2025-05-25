import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

mixin TextLabelManager {
  // References to properties from parent MapboxState
  MapboxMap? get mapboxMap;

  // Get functions from other mixins
  Future<PointAnnotation?> addTextLabel(
    Point position,
    String text, {
    double textSize = 14.0,
    int textColor = 0xFF000000,
    int textHaloColor = 0xFFFFFFFF,
    double textHaloWidth = 1.0,
    List<double> textOffset = const [0.0, 0.5],
  });

  Point calculatePolygonCenter(PolygonAnnotation polygon);

  // Flag to track if we're in text placement mode
  bool isInTextPlacementMode = false;

// Flag to prevent multiple dialogs
  bool _isTextDialogActive = false;

  // Target annotation data to store what we clicked
  dynamic targetAnnotation;
  String? targetAnnotationType;

  // Start text placement mode
  void startTextPlacementMode() {
    isInTextPlacementMode = true;
    _isTextDialogActive = false;
    targetAnnotation = null;
    targetAnnotationType = null;
  }

  // Exit text placement mode
  void exitTextPlacementMode() {
    isInTextPlacementMode = false;
    _isTextDialogActive = false;
    targetAnnotation = null;
    targetAnnotationType = null;
  }

  // Handle click on different annotation types during text placement mode
  Future<bool> handleAnnotationClickForTextLabel(
      dynamic annotation, String annotationType) async {
    // Check both if we're in text placement mode AND if dialog is not already active
    if (!isInTextPlacementMode || _isTextDialogActive) return false;

    // Store the clicked annotation and its type
    targetAnnotation = annotation;
    targetAnnotationType = annotationType;

    // Set dialog active flag to prevent multiple dialogs
    _isTextDialogActive = true;

    // Return true to indicate we handled the click
    return true;
  }

  // Show text input dialog and create text label based on target annotation
  Future<void> showTextInputDialog(BuildContext context) async {
    if (targetAnnotation == null || !isInTextPlacementMode) {
      _isTextDialogActive = false;
      return;
    }

    try {
      // Determine the appropriate position based on the annotation type
      Point labelPosition;

      switch (targetAnnotationType) {
        case 'polygon':
          labelPosition =
              calculatePolygonCenter(targetAnnotation as PolygonAnnotation);
          break;
        case 'point':
          labelPosition = (targetAnnotation as PointAnnotation).geometry;
          break;
        case 'circle':
          labelPosition = (targetAnnotation as CircleAnnotation).geometry;
          break;
        case 'polyline':
          // For polylines, use the midpoint of the line
          final positions =
              (targetAnnotation as PolylineAnnotation).geometry.coordinates;
          if (positions.length > 1) {
            int midIndex = positions.length ~/ 2;
            labelPosition = Point(coordinates: positions[midIndex]);
          } else {
            labelPosition = Point(coordinates: positions[0]);
          }
          break;
        default:
          // Default case - should not happen with proper type checking
          _isTextDialogActive = false;
          return;
      }

      // Show dialog to get text input
      final TextEditingController textController = TextEditingController();
      final String? labelText = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: const Text('Add Label'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Enter label text',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, textController.text),
              child: const Text('Add'),
            ),
          ],
        ),
      );

      // Create the text label if text was entered
      if (labelText != null && labelText.isNotEmpty && mapboxMap != null) {
        final annotation = await addTextLabel(labelPosition, labelText);
        if (annotation != null) {
          final widget = (this as dynamic).widget;
          widget.onFeedbackMessage?.call('Text label added: $labelText');
        }
      }
    } catch (e) {
      print("Error in text input dialog: $e");
    } finally {
      // Always reset the dialog active flag and exit text placement mode
      _isTextDialogActive = false;
      exitTextPlacementMode();
      // Call the callback to notify the parent screen
      final widget = (this as dynamic).widget; // Access the widget instance
      widget.onTextPlacementFinished?.call(); // Call the new callback
    }
  }
}
