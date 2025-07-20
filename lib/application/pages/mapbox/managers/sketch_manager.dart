import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:land_asset_valuation/application/core/widgets/sketch_mode.dart';
import '../constants/mapbox_constants.dart';

mixin SketchManager {
  // References to Mapbox map and annotation managers
  MapboxMap? get mapboxMap;
  PolylineAnnotationManager? get polylineAnnotationManager;
  PolygonAnnotationManager? get polygonAnnotationManager;
  CircleAnnotationManager? get circleAnnotationManager;
  PolygonAnnotation? _currentPartitionPreview;

  // State variables for sketching
  final List<Point> currentSketchPoints = [];
  PolylineAnnotation? _currentSketchGuidePolyline;

  // State for interactive circle drawing
  bool isWaitingForCircleRadiusPoint = false;
  Point? _circleCenterPoint;
  CircleAnnotation? _tempCircleFeedback;

  // Lists to store finalized sketches
  final List<PolygonAnnotation> finalSketchPolygons = [];
  final List<PolylineAnnotation> finalSketchLines = [];
  final List<CircleAnnotation> finalSketchCircles = [];

  // Store references to vertex dots for later removal
  final List<CircleAnnotation> _vertexDots = [];
  // Add this at the class level where _vertexDots is declared
  final Map<String, List<CircleAnnotation>> _polygonVertexDots = {};

  // Floor management
  String _currentFloor = 'Ground';
  // Map to store partitions by floor: floor name -> list of partition annotations
  final Map<String, List<PolygonAnnotation>> _floorPartitions = {'Ground': []};

  // Method to change the active floor
  Future<void> changeActiveFloor(String floorName) async {
    if (_currentFloor == floorName) return; // No change needed

    debugPrint("SketchManager: Changing active floor to $floorName");

    // Make sure all floor partitions exist in the mapping
    if (!_floorPartitions.containsKey(floorName)) {
      _floorPartitions[floorName] = [];
    }

    // First, fade ALL floor partitions to very low opacity
    for (final floor in _floorPartitions.keys) {
      // Pass true for isActive if this is the new current floor, false otherwise
      await _fadeFloorPartitions(floor, isActive: floor == floorName);
    }

    // Update current floor
    _currentFloor = floorName;

    // Notify that floor change is complete
    debugPrint(
        "SketchManager: Changed to floor: $floorName with ${_floorPartitions[floorName]?.length ?? 0} partitions");
  }

  // Fade partitions for a specific floor
  Future<void> _fadeFloorPartitions(String floorName,
      {bool isActive = false}) async {
    if (!_floorPartitions.containsKey(floorName)) return;

    final partitions = _floorPartitions[floorName] ?? [];
    debugPrint(
        "Adjusting ${partitions.length} partitions for floor $floorName (isActive: $isActive)");

    for (final partition in partitions) {
      try {
        // Update both fill opacity AND outline opacity based on floor activity
        // This ensures partition borders don't remain visible when switching floors
        await polygonAnnotationManager?.update(partition
          ..fillOpacity = isActive ? 1.0 : 0.05
          ..fillOutlineColor = isActive
              ? PARTITION_POLYGON_OUTLINE_COLOR
              : Color.fromARGB(13, 51, 153, 255)
                  .value); // Cast to int with .value
      } catch (e) {
        debugPrint("Error updating partition visibility: $e");
      }
    }
    debugPrint(
        "${isActive ? 'Showing' : 'Fading'} ${partitions.length} partitions for floor $floorName");
  }

  // Show partitions for a specific floor at full opacity
  Future<void> _showFloorPartitions(String floorName) async {
    return _fadeFloorPartitions(floorName, isActive: true);
  }

  // Deletes all partitions associated with a specific floor
  Future<void> deleteFloorPartitions(String floorName) async {
    if (!_floorPartitions.containsKey(floorName) ||
        polygonAnnotationManager == null) {
      debugPrint(
          "No partitions found for floor $floorName or manager not ready.");
      return;
    }

    final partitionsToDelete = _floorPartitions[floorName] ?? [];
    if (partitionsToDelete.isEmpty) {
      debugPrint("No partitions to delete for floor $floorName.");
      _floorPartitions.remove(floorName); // Remove the key if list is empty
      return;
    }

    try {
      // Correct way to delete multiple annotations: iterate and delete individually
      for (final partition in partitionsToDelete) {
        await polygonAnnotationManager!.delete(partition);
      }
      debugPrint(
          "Deleted ${partitionsToDelete.length} partitions for floor $floorName.");
    } catch (e) {
      debugPrint("Error deleting partitions for floor $floorName: $e");
      // Optionally, attempt to remove remaining ones individually or handle error
    } finally {
      // Remove the floor entry from the map regardless of deletion success
      _floorPartitions.remove(floorName);
      // Ensure the map doesn't track a deleted floor
      if (_currentFloor == floorName) {
        // If the deleted floor was active, we might need to switch
        // This case should be handled by FloorManager selecting a new floor first
        debugPrint(
            "Warning: Deleted the currently active floor's partitions. FloorManager should handle selection change.");
        // Consider setting _currentFloor to a default like 'Ground' if necessary,
        // but FloorManager should dictate the active floor.
      }
    }
  }

  // Method to handle tap events in sketch mode
  Future<void> handleSketchTap(
      Point tappedPoint, dynamic widget, MapboxMap mapboxMap) async {
    // Handle based on the selected INTERACTION sub-mode (Pin, Move, Ruler)
    switch (widget.selectedSketchSubMode) {
      case SketchToolMode.marker: // PIN MODE - Drawing Shapes
        if (widget.selectedSketchTool == null) {
          widget.onFeedbackMessage
              ?.call("Select a shape tool (Polygon, Line, etc.) first.");
          return;
        } // Need a shape tool
        // Handle Circle (2-tap)
        if (widget.selectedSketchTool == 'circle') {
          if (!isWaitingForCircleRadiusPoint) {
            await _startInteractiveCircle(tappedPoint);
          } else {
            await _finalizeInteractiveCircle(tappedPoint, widget);
          }
          return;
        }
        // Reset pending circle state if user taps for line/poly
        if (isWaitingForCircleRadiusPoint) await resetInteractiveCircleState();
        // Add point for Line/Polygon
        currentSketchPoints.add(tappedPoint);
        // Check Polygon Tap-to-Close
        if (widget.selectedSketchTool == 'polygon' ||
            widget.selectedSketchTool == 'partition') {
          // Add point for Polygon/Partition
          currentSketchPoints.add(tappedPoint);

          // Check Tap-to-Close for Polygon/Partition
          if (currentSketchPoints.length > 2) {
            try {
              Point firstPoint = currentSketchPoints.first;
              ScreenCoordinate firstPx =
                  await mapboxMap.pixelForCoordinate(firstPoint);
              ScreenCoordinate currentPx =
                  await mapboxMap.pixelForCoordinate(tappedPoint);
              double dist = math.sqrt(math.pow(firstPx.x - currentPx.x, 2) +
                  math.pow(firstPx.y - currentPx.y, 2));
              if (dist < TAP_CLOSURE_THRESHOLD_PIXELS) {
                await finalizeCurrentSketchPolygon(widget);
                return;
              }
            } catch (e) {
              debugPrint("Error checking tap distance: $e");
            }
          }
          // Update visual guide
          await _drawOrUpdateSketchGuide(widget);
          return;
        }
        // Update visual guide for line/polygon
        await _drawOrUpdateSketchGuide(widget);
        break; // End marker sub-mode case

      case SketchToolMode.move: // MOVE MODE - Placeholder
        widget.onFeedbackMessage?.call(
            "Move mode: Tap sketched items to select (Not Implemented).");
        break;
      case SketchToolMode.ruler: // RULER MODE - Placeholder
        widget.onFeedbackMessage
            ?.call("Ruler mode: Tap points to measure (Not Implemented).");
        break;
      default:
        widget.onFeedbackMessage
            ?.call("Select interaction mode (Pin, Move, Ruler).");
        break; // Should not happen with good state management
    }
  }

  // Updates the temporary visual guide (line/outline) during sketching
  Future<void> _drawOrUpdateSketchGuide(dynamic widget) async {
    // Need polyline manager. If no points, ensure guide is removed.
    if (polylineAnnotationManager == null) return;
    if (currentSketchPoints.isEmpty) {
      if (_currentSketchGuidePolyline != null) {
        try {
          await polylineAnnotationManager!.delete(_currentSketchGuidePolyline!);
          _currentSketchGuidePolyline = null;
        } catch (e) {}
      }
      return;
    }
    debugPrint(
        "Updating sketch guide: ${currentSketchPoints.length} points. Tool: ${widget.selectedSketchTool}");

    List<Position> positions =
        currentSketchPoints.map((p) => p.coordinates).toList();
    PolylineAnnotationOptions guideOptions;

    // Configure guide based on selected shape tool
    switch (widget.selectedSketchTool) {
      case 'polygon':
        // Show closed loop guide if 2+ points
        if (currentSketchPoints.length >= 2) positions.add(positions.first);
        guideOptions = PolylineAnnotationOptions(
          geometry: LineString(coordinates: positions),
          lineColor: SKETCH_POLYGON_OUTLINE_COLOR,
          lineWidth: SKETCH_POLYGON_OUTLINE_WIDTH, /*lineDasharray: [2.0, 1.5]*/
        );
        break;
      case 'line':
        guideOptions = PolylineAnnotationOptions(
          geometry: LineString(coordinates: positions),
          lineColor: SKETCH_LINE_COLOR,
          lineWidth: SKETCH_LINE_WIDTH, /*lineDasharray: [2.0, 1.5]*/
        );
        break;
      case 'partition':
        if (currentSketchPoints.length >= 2) positions.add(positions.first);
        guideOptions = PolylineAnnotationOptions(
          geometry: LineString(coordinates: positions),
          lineColor: PARTITION_POLYGON_OUTLINE_COLOR,
          lineWidth: SKETCH_POLYGON_OUTLINE_WIDTH,
        );
        break;
      default: // Includes 'circle' or unknown tools - don't draw guide
        debugPrint("No sketch guide for tool: ${widget.selectedSketchTool}");
        // Ensure existing guide is removed if tool switched to one without guide
        if (_currentSketchGuidePolyline != null) {
          try {
            await polylineAnnotationManager!
                .delete(_currentSketchGuidePolyline!);
            _currentSketchGuidePolyline = null;
          } catch (e) {}
        }
        return;
    }

    // Create or update the guide annotation on the map
    try {
      if (_currentSketchGuidePolyline != null) {
        // Update existing
        await polylineAnnotationManager!.update(_currentSketchGuidePolyline!
          ..geometry = guideOptions.geometry
          ..lineColor = guideOptions.lineColor
          ..lineWidth = guideOptions.lineWidth);
      } else {
        // Create new
        _currentSketchGuidePolyline =
            await polylineAnnotationManager!.create(guideOptions);
      }
      debugPrint(
          "Sketch guide polyline updated/created: ${_currentSketchGuidePolyline?.id}");
    } catch (e) {
      debugPrint("Error drawing/updating sketch guide polyline: $e");
      _currentSketchGuidePolyline =
          null; // Ensure reference is null if error occurs
    }
  }

  // Clears ONLY the temporary visuals (points, guides) for the sketch currently in progress
  Future<void> clearCurrentSketchGuideAndPoints() async {
    if (currentSketchPoints.isEmpty &&
        _currentSketchGuidePolyline == null &&
        _tempCircleFeedback == null) {
      // Nothing to clear for sketching
      return;
    }
    debugPrint("Mapbox: Clearing current sketch guide and points.");
    currentSketchPoints.clear(); // Clear the points list
    await resetInteractiveCircleState(); // Handles circle specifics (temp marker, flags)
    try {
      // Delete the visual guide line/outline from the map
      if (_currentSketchGuidePolyline != null &&
          polylineAnnotationManager != null) {
        await polylineAnnotationManager!.delete(_currentSketchGuidePolyline!);
        _currentSketchGuidePolyline = null; // Clear reference
        debugPrint("Mapbox: Cleared current sketch guide polyline.");
      }
    } catch (e) {
      debugPrint("Error deleting sketch polyline guide: $e");
    }
  }

  // Resets state specific to the interactive circle drawing
  Future<void> resetInteractiveCircleState() async {
    // Check if already reset to avoid unnecessary async operations
    if (!isWaitingForCircleRadiusPoint &&
        _circleCenterPoint == null &&
        _tempCircleFeedback == null) {
      return;
    }

    debugPrint("Mapbox: Resetting interactive circle state.");
    isWaitingForCircleRadiusPoint = false;
    _circleCenterPoint = null;
    // Delete the temporary grey marker shown at the center
    if (_tempCircleFeedback != null && circleAnnotationManager != null) {
      try {
        await circleAnnotationManager!.delete(_tempCircleFeedback!);
        debugPrint("Mapbox: Deleted temporary circle feedback annotation.");
      } catch (e) {
        debugPrint("Error deleting temp circle feedback: $e");
      }
      _tempCircleFeedback = null; // Clear reference
    }
  }

  // Starts the 2-tap circle drawing process
  Future<void> _startInteractiveCircle(Point centerPoint) async {
    final widget = (this as dynamic).widget;

    if (circleAnnotationManager == null) {
      widget.onFeedbackMessage?.call("Error: Circle manager not ready.");
      return;
    }
    await resetInteractiveCircleState(); // Ensure clean state before starting

    isWaitingForCircleRadiusPoint = true;
    _circleCenterPoint = centerPoint;
    // No need for currentSketchPoints or guide polyline for circle

    debugPrint(
        "Mapbox: Circle drawing STARTED. Center set at $centerPoint. Waiting for radius tap.");
    widget.onFeedbackMessage
        ?.call("Tap again on the map to set the circle radius.");

    // Show temporary grey marker at the center point
    try {
      _tempCircleFeedback = await circleAnnotationManager!.create(
          CircleAnnotationOptions(
              geometry: centerPoint,
              circleColor: TEMP_CIRCLE_CENTER_COLOR,
              circleRadius: 5.0,
              circleStrokeWidth: 1.0,
              circleStrokeColor: Colors.black.value));
      debugPrint("Mapbox: Temporary circle center marker shown.");
    } catch (e) {
      debugPrint("Error creating temp circle center feedback: $e");
    }
  }

  // Finalizes the circle on the second tap, calculating radius
  Future<void> _finalizeInteractiveCircle(
      Point radiusPoint, dynamic widget) async {
    if (!isWaitingForCircleRadiusPoint ||
        _circleCenterPoint == null ||
        mapboxMap == null ||
        circleAnnotationManager == null) {
      debugPrint("Mapbox ERROR: Trying to finalize circle in invalid state.");
      await resetInteractiveCircleState();
      return; // Reset if state is wrong
    }
    debugPrint(
        "Mapbox: Circle drawing FINISHING. Radius point tapped at $radiusPoint.");
    double calculatedRadius = 15.0; // Default fallback radius in screen points

    // Calculate radius based on screen distance between center and edge tap
    try {
      ScreenCoordinate centerScreen = await mapboxMap!
          .pixelForCoordinate(_circleCenterPoint!); // Pass Point directly
      ScreenCoordinate radiusScreen = await mapboxMap!
          .pixelForCoordinate(radiusPoint); // Pass Point directly
      double dx = centerScreen.x - radiusScreen.x;
      double dy = centerScreen.y - radiusScreen.y;
      calculatedRadius = math.sqrt(dx * dx + dy * dy);
      calculatedRadius =
          math.max(5.0, calculatedRadius); // Ensure minimum reasonable radius
      debugPrint(
          "Mapbox: Calculated circle radius (screen points): $calculatedRadius");
    } catch (e) {
      debugPrint(
          "Mapbox: Error calculating radius using pixelForCoordinate: $e. Using default ($calculatedRadius).");
    }

    // Create the final sketch circle annotation
    try {
      final finalCircle =
          await circleAnnotationManager!.create(CircleAnnotationOptions(
        geometry: _circleCenterPoint!,
        circleColor: SKETCH_CIRCLE_COLOR,
        circleRadius: calculatedRadius,
        circleStrokeColor: SKETCH_POLYGON_OUTLINE_COLOR,
        circleStrokeWidth: 1.5,
      ));
      finalSketchCircles.add(finalCircle); // Store reference
      debugPrint(
          'Mapbox: FINAL Sketch Circle DRAWN and stored. ID: ${finalCircle.id}');
      widget.onFeedbackMessage?.call("Circle drawn and saved.");
      await resetInteractiveCircleState(); // Clean up temp marker/state vars AFTER success
      widget.onSketchFinished?.call(); // Notify parent
    } catch (e) {
      debugPrint("Error creating final sketch circle: $e");
      widget.onFeedbackMessage?.call("Error saving circle.");
      await resetInteractiveCircleState(); // Ensure cleanup on error too
    }
  }

  // Clears all vertex dots from the map
  Future<void> clearVertexDots() async {
    if (circleAnnotationManager == null || _vertexDots.isEmpty) return;

    try {
      for (final dot in _vertexDots) {
        await circleAnnotationManager!.delete(dot);
      }
      _vertexDots.clear();
      print("All vertex dots cleared");
    } catch (e) {
      print("Error clearing vertex dots: $e");
    }
  }

  // Creates the FINAL, persistent sketch polygon. Called by tap-closure or Save button.
  Future<void> finalizeCurrentSketchPolygon(dynamic widget) async {
    if (polygonAnnotationManager == null || currentSketchPoints.length < 3) {
      widget.onFeedbackMessage?.call(currentSketchPoints.length < 3
          ? "Polygon requires at least 3 points."
          : "Error: Polygon manager not ready.");
      return;
    }
    debugPrint(
        "Finalizing sketch polygon with ${currentSketchPoints.length} points.");
    List<Position> polyPos = currentSketchPoints
        .map((p) => p.coordinates)
        .toList()
      ..add(currentSketchPoints.first.coordinates); // Close loop

    try {
      final sketchPoly =
          await polygonAnnotationManager!.create(PolygonAnnotationOptions(
        geometry: Polygon(coordinates: [polyPos]),
        fillColor: widget.selectedSketchTool == 'partition'
            ? PARTITION_POLYGON_FILL_COLOR // Immediate pink fill for partitions
            : SKETCH_POLYGON_FILL_COLOR, // Normal color for regular polygons
        fillOutlineColor: widget.selectedSketchTool == 'partition'
            ? PARTITION_POLYGON_OUTLINE_COLOR
            : SKETCH_POLYGON_OUTLINE_COLOR,
        fillOpacity: 1.0, // Ensure full opacity for new partitions
      ));

      // Add the polygon to appropriate collection
      finalSketchPolygons.add(sketchPoly); // Always store in general collection

      // For partitions, also store in the floor-specific collection
      if (widget.selectedSketchTool == 'partition') {
        if (!_floorPartitions.containsKey(_currentFloor)) {
          _floorPartitions[_currentFloor] = [];
        }
        _floorPartitions[_currentFloor]!.add(sketchPoly);
        debugPrint(
            "Partition added to floor: $_currentFloor (Total: ${_floorPartitions[_currentFloor]!.length})");
      }

      if (widget.selectedSketchTool == 'partition') {
        debugPrint("Partition successfully created");
        widget.onFeedbackMessage
            ?.call("Partition saved on floor: $_currentFloor");
      } else {
        widget.onFeedbackMessage?.call("Sketch polygon saved.");
      }
      await clearCurrentSketchGuideAndPoints();
      widget.onSketchFinished?.call();
    } catch (e) {
      debugPrint("Error finalizing sketch polygon: $e");
      widget.onFeedbackMessage?.call("Error saving polygon.");
    }
  }

  // Creates the FINAL, persistent sketch line. Called by Save button.
  Future<void> finalizeCurrentSketchLine(dynamic widget) async {
    if (polylineAnnotationManager == null || currentSketchPoints.length < 2) {
      widget.onFeedbackMessage?.call(currentSketchPoints.length < 2
          ? "Line requires at least 2 points."
          : "Error: Line manager not ready.");
      return;
    }
    debugPrint(
        "Finalizing sketch line with ${currentSketchPoints.length} points.");
    List<Position> positions =
        currentSketchPoints.map((p) => p.coordinates).toList();

    try {
      final sketchLine = await polylineAnnotationManager!.create(
          PolylineAnnotationOptions(
              geometry: LineString(coordinates: positions),
              lineColor: SKETCH_LINE_COLOR,
              lineWidth: SKETCH_LINE_WIDTH));
      finalSketchLines.add(sketchLine); // Store reference

      // Clear all vertex dots
      await clearVertexDots();

      // Instead of clearing vertex dots, store them with the line
      if (!_polygonVertexDots.containsKey(sketchLine.id)) {
        _polygonVertexDots[sketchLine.id] = [];
      }

      // Create permanent vertex dots for the saved line
      for (Point point in currentSketchPoints) {
        final vertexDot =
            await circleAnnotationManager!.create(CircleAnnotationOptions(
          geometry: point,
          circleColor: POLYGON_VERTEX_DOT_COLOR,
          circleRadius: POLYGON_VERTEX_DOT_RADIUS,
        ));
        _polygonVertexDots[sketchLine.id]!.add(vertexDot);
      }

      print("FINAL Sketch Line CREATED with vertex dots: ${sketchLine.id}");
      widget.onFeedbackMessage?.call("Sketch line saved with vertex markers.");

      debugPrint("FINAL Sketch Line CREATED and stored: ${sketchLine.id}");
      widget.onFeedbackMessage?.call("Sketch line saved.");
      await clearCurrentSketchGuideAndPoints(); // Clean up temps
      widget.onSketchFinished?.call(); // Notify parent
    } catch (e) {
      debugPrint("Error finalizing sketch line: $e");
      widget.onFeedbackMessage?.call("Error saving line.");
    }
  }

  // Public method for parent to call
  Future<void> handleFinalizeCurrentSketch(dynamic widget) async {
    debugPrint("Mapbox: finalizeCurrentSketch called by parent (Save button).");
    // Validation Checks
    if (!widget.isSketchingMode) {
      debugPrint("Not sketching.");
      return;
    }
    if (widget.selectedSketchSubMode != SketchToolMode.marker) {
      widget.onFeedbackMessage?.call("Switch to Pin mode to save shape.");
      return;
    }
    if (widget.selectedSketchTool == null) {
      widget.onFeedbackMessage?.call("Select a shape tool to save.");
      return;
    }
    if (isWaitingForCircleRadiusPoint) {
      widget.onFeedbackMessage
          ?.call("Tap map to set circle radius before saving.");
      return;
    }

    // Call appropriate finalization based on SHAPE tool
    switch (widget.selectedSketchTool) {
      case 'polygon':
      case 'partition':
        await finalizeCurrentSketchPolygon(widget);
        break;
      case 'line':
        await finalizeCurrentSketchLine(widget);
        break;
      case 'circle':
        widget.onFeedbackMessage?.call("Circle already saved on second tap.");
        break; // Circles finalize on tap
      default:
        debugPrint(
            "Unknown sketch tool ('${widget.selectedSketchTool}'), cannot finalize.");
        break;
    }
  }

  // Methods for deleting finalized sketches
  Future<void> deleteSketchPolygon(PolygonAnnotation annotation) async {
    if (polygonAnnotationManager == null) return;

    try {
      await polygonAnnotationManager!.delete(annotation);
      finalSketchPolygons.removeWhere((poly) => poly.id == annotation.id);
      debugPrint("Sketch polygon deleted: ${annotation.id}");
    } catch (e) {
      debugPrint("Error deleting sketch polygon: $e");
    }
  }

  Future<void> deleteSketchLine(PolylineAnnotation annotation) async {
    if (polylineAnnotationManager == null) return;

    try {
      await polylineAnnotationManager!.delete(annotation);
      finalSketchLines.removeWhere((line) => line.id == annotation.id);
      debugPrint("Sketch line deleted: ${annotation.id}");
    } catch (e) {
      debugPrint("Error deleting sketch line: $e");
    }
  }

  Future<void> deleteSketchCircle(CircleAnnotation annotation) async {
    if (circleAnnotationManager == null) return;

    try {
      await circleAnnotationManager!.delete(annotation);
      finalSketchCircles.removeWhere((circle) => circle.id == annotation.id);
      debugPrint("Sketch circle deleted: ${annotation.id}");
    } catch (e) {
      debugPrint("Error deleting sketch circle: $e");
    }
  }

// Method to add a polygon sketch with predefined points
  Future<void> addPolygonSketch(List<Point> points) async {
    if (polygonAnnotationManager == null || points.length < 3) {
      debugPrint(
          "Error: Cannot create polygon. Either manager not ready or insufficient points.");
      final widget = (this as dynamic).widget;
      widget.onFeedbackMessage?.call("Error: Unable to create polygon.");
      return;
    }

    debugPrint("Creating polygon sketch with ${points.length} points");

    try {
      // Convert Points to Positions
      List<Position> positions = points.map((p) => p.coordinates).toList();

      // Create the polygon annotation
      final sketchPoly = await polygonAnnotationManager!.create(
          PolygonAnnotationOptions(
              geometry: Polygon(coordinates: [positions]),
              fillColor: SKETCH_POLYGON_FILL_COLOR,
              fillOutlineColor: SKETCH_POLYGON_OUTLINE_COLOR));

      // Store reference to the saved sketch
      finalSketchPolygons.add(sketchPoly);

      debugPrint("Polygon sketch created successfully: ${sketchPoly.id}");

      final widget = (this as dynamic).widget;
      widget.onFeedbackMessage?.call("Polygon created successfully.");
      widget.onSketchFinished?.call(); // Notify parent UI of completion
    } catch (e) {
      debugPrint("Error creating polygon sketch: $e");
      final widget = (this as dynamic).widget;
      widget.onFeedbackMessage?.call("Error creating polygon: $e");
    }
  }
}
