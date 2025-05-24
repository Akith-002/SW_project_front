import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

mixin AnnotationManagers {
  // Annotation managers
  PolylineAnnotationManager? polylineAnnotationManager;
  PolygonAnnotationManager? polygonAnnotationManager;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotationManager? circleAnnotationManager;

  // Method to initialize all annotation managers
  Future<void> initializeAnnotationManagers(MapboxMap mapboxMap) async {
    // Use unique IDs for managers to help prevent issues during hot reload/restart
    final idSuffix = DateTime.now().millisecondsSinceEpoch.toString();

    // Create managers for each annotation type needed
    polylineAnnotationManager = await mapboxMap.annotations
        .createPolylineAnnotationManager(id: "polyline_manager_$idSuffix");

    polygonAnnotationManager = await mapboxMap.annotations
        .createPolygonAnnotationManager(id: "polygon_manager_$idSuffix");

    pointAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager(id: "point_manager_$idSuffix");

    circleAnnotationManager = await mapboxMap.annotations
        .createCircleAnnotationManager(id: "circle_manager_$idSuffix");
  }

  // Helper method to calculate polygon center
  Point calculatePolygonCenter(PolygonAnnotation polygon) {
    // Extract all positions from the polygon
    List<Position> positions = polygon.geometry.coordinates[0];

    // Skip the last point if it's identical to the first (closed polygon)
    if (positions.isNotEmpty &&
        positions.last.lng == positions.first.lng &&
        positions.last.lat == positions.first.lat) {
      positions = positions.sublist(0, positions.length - 1);
    }

    // Calculate the centroid
    double lat = 0, lng = 0;
    for (var pos in positions) {
      lng += pos.lng;
      lat += pos.lat;
    }

    if (positions.isNotEmpty) {
      lat /= positions.length;
      lng /= positions.length;
    }

    return Point(coordinates: Position(lng, lat));
  }

  Future<PointAnnotation?> addTextLabel(
    Point position,
    String text, {
    double textSize = 14.0,
    int textColor = 0xFF000000, // Black
    int textHaloColor = 0xFFFFFFFF, // White
    double textHaloWidth = 1.0,
    List<double> textOffset = const [0.0, 0.5],
  }) async {
    if (pointAnnotationManager == null || text.isEmpty) {
      debugPrint(
          "Cannot add text label: manager not initialized or empty text");
      return null;
    }

    try {
      // Create the text annotation options
      final options = PointAnnotationOptions(
        geometry: position,
        textField: text,
        textSize: textSize,
        textColor: textColor,
        textHaloColor: textHaloColor,
        textHaloWidth: textHaloWidth,
        textOffset: textOffset,
        // Use an empty image but set it as text-only
        iconSize: 0.0,
      );

      // Create and return the annotation
      final annotation = await pointAnnotationManager!.create(options);
      debugPrint("Text label created: '$text' at ${position.coordinates}");
      return annotation;
    } catch (e) {
      debugPrint("Error adding text label: $e");
      return null;
    }
  }
}
