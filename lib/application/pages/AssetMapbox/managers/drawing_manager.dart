import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../constants/mapbox_constants.dart';

mixin DrawingManager {
  // References to properties from parent MapboxState
  MapboxMap? get mapboxMap;
  List<Point> get drawnPoints;
  set drawnPoints(List<Point> points);

  PolygonAnnotation? get initialLotPolygon;
  set initialLotPolygon(PolygonAnnotation? polygon);

  PolygonAnnotationManager? get polygonAnnotationManager;

  // Methods to clear sketch state that would be inherited from SketchManager
  Future<void> clearCurrentSketchGuideAndPoints();
  bool get isWaitingForCircleRadiusPoint;
  Future<void> resetInteractiveCircleState();

  // Method to draw/update the initial lot polygon
  Future<void> drawOrUpdateInitialLotPolygon() async {
    // Get the widget instance for callbacks
    final widget = (this as dynamic).widget;

    if (polygonAnnotationManager == null) {
      debugPrint(
          "Mapbox Error: Cannot draw initial lot, PolygonManager not ready.");
      widget.onFeedbackMessage?.call("Error: Cannot draw lot.");
      return;
    }

    try {
      List<Position> positions = drawnPoints.map((p) => p.coordinates).toList();

      // Simple delete/recreate is fine for the single initial lot polygon
      if (initialLotPolygon != null) {
        // Delete previous version
        await polygonAnnotationManager!.delete(initialLotPolygon!);
        initialLotPolygon = null;
      }

      // Draw the polygon if there are 3 or more points
      if (drawnPoints.length >= 3) {
        List<Position> polyPos = List.from(positions)
          ..add(positions.first); // Close loop
        PolygonAnnotationOptions opts = PolygonAnnotationOptions(
            geometry: Polygon(coordinates: [polyPos]),
            fillColor: INITIAL_LOT_FILL_COLOR,
            fillOutlineColor: INITIAL_LOT_OUTLINE_COLOR);
        initialLotPolygon =
            await polygonAnnotationManager!.create(opts); // Create new
        debugPrint(
            "Initial lot polygon updated/created: ${initialLotPolygon?.id}");
      }

      // Provide the updated point list to the parent (e.g., for area calculation UI)
      widget.onLineDrawn?.call(drawnPoints);
    } catch (e) {
      debugPrint("Error drawing initial lot polygon: $e");
      widget.onFeedbackMessage?.call("Error updating lot boundary.");
    }
  }

  // Clears Initial Lot polygon/points AND current temporary sketch data
  Future<void> clearDrawing() async {
    debugPrint(
        "Mapbox: clearDrawing (Initial Lot & Current Sketch State) called.");
    drawnPoints = []; // Clear points for initial lot
    await clearCurrentSketchGuideAndPoints(); // Clear any ongoing sketch visuals
    try {
      // Delete the initial lot polygon from the map if it exists
      if (initialLotPolygon != null && polygonAnnotationManager != null) {
        await polygonAnnotationManager!.delete(initialLotPolygon!);
        initialLotPolygon = null; // Clear reference
        debugPrint("Mapbox: Deleted initial lot polygon from map.");
      }
      debugPrint("Mapbox: Cleared initial lot state.");
    } catch (e) {
      debugPrint("Error during clearDrawing's polygon deletion: $e");
    }
  }
}
