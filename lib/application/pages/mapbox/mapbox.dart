import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/draw_polygon/drawPolygonDialog.dart';
import 'package:land_asset_valuation/application/core/widgets/sketch_mode.dart';
import 'package:land_asset_valuation/application/core/widgets/sketch_polygon_action_menu.dart';
import 'package:land_asset_valuation/application/pages/mapbox/managers/text_label_manager.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:typed_data';

import 'constants/mapbox_constants.dart';
import 'listeners/annotation_listeners.dart';
import 'managers/annotation_managers.dart';
import 'managers/drawing_manager.dart';
import 'managers/sketch_manager.dart';
import 'dart:math' as math;

class Mapbox extends StatefulWidget {
  final Function(bool)? onDrawModeChanged;
  final Function(List<Point>)? onLineDrawn;
  final Function(Point)? onMapTapped;
  final Function(PointAnnotation, String?)? onAnnotationClick;
  final Function(PolygonAnnotation)? onPolygonClick;
  final Function(double area, double distance)?
      onSketchMetricsUpdated; // <-- ADD THIS PROP

  final bool isSketchingMode;
  final String? selectedSketchTool;
  final SketchToolMode? selectedSketchSubMode;
  final Function()? onSketchFinished;
  final Function(String)? onFeedbackMessage;
  final Function(bool, PolygonAnnotation?)? onViewInsideModeChanged;
  final bool isViewInsideMode; // <-- ADD THIS PROP
  final Function()? onTextPlacementFinished;

  const Mapbox({
    super.key,
    this.onDrawModeChanged,
    this.onLineDrawn,
    this.onMapTapped,
    this.onAnnotationClick,
    this.onPolygonClick,
    this.isSketchingMode = false,
    this.isViewInsideMode = false, // <-- Add default value
    this.onSketchMetricsUpdated, // <-- ADD THIS ARG

    this.selectedSketchTool,
    this.selectedSketchSubMode,
    this.onSketchFinished,
    this.onFeedbackMessage,
    this.onViewInsideModeChanged,
    this.onTextPlacementFinished,
  });

  @override
  State<Mapbox> createState() => MapboxState();
}

class MapboxState extends State<Mapbox>
    with AnnotationManagers, DrawingManager, SketchManager, TextLabelManager {
  @override
  MapboxMap? mapboxMap;
  bool isDrawingMode = false;
  @override
  List<Point> drawnPoints = [];
  @override
  PolygonAnnotation? initialLotPolygon;
  PolylineAnnotation? initialLotOutline; // For the thick outline
  PolylineAnnotation? _currentSketchGuidePolyline;
  CircleAnnotation? _tempCircleFeedback;

  // For annotations
  final Map<String, String> _annotationTypes = {};

  // Store references to vertex dots for later removal
  final List<CircleAnnotation> _vertexDots = [];

  bool _isGridBackgroundActive = false;

  @override
  void initState() {
    super.initState();
    // Any initial setup for MapboxState can go here
  }

  @override
  void didUpdateWidget(covariant Mapbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    debugPrint(
        "Mapbox didUpdateWidget: isSketchingMode changed: ${oldWidget.isSketchingMode} -> ${widget.isSketchingMode}");
    debugPrint(
        "Mapbox didUpdateWidget: selectedSketchTool changed: ${oldWidget.selectedSketchTool} -> ${widget.selectedSketchTool}");
    debugPrint(
        "Mapbox didUpdateWidget: selectedSketchSubMode changed: ${oldWidget.selectedSketchSubMode} -> ${widget.selectedSketchSubMode}");
    // If tool changed to line, ensure lines are on top
    if (widget.isSketchingMode &&
        widget.selectedSketchTool == 'line' &&
        oldWidget.selectedSketchTool != 'line') {
      ensureLinesOnTop();
    }
    // If sketching starts, or the tool/sub-mode changes, clear temporary sketch data
    if (widget.isSketchingMode &&
        (!oldWidget.isSketchingMode ||
            widget.selectedSketchTool != oldWidget.selectedSketchTool ||
            widget.selectedSketchSubMode != oldWidget.selectedSketchSubMode)) {
      debugPrint(
          "Mapbox Widget: Sketch state change detected. Clearing pending guides/points.");
      clearCurrentSketchGuideAndPoints(); // Ensure clean state for new tool/mode
    }
    // If exiting sketch mode, clear temporary sketch data
    if (!widget.isSketchingMode && oldWidget.isSketchingMode) {
      debugPrint(
          "Mapbox Widget: Exited sketch mode. Clearing pending guides/points.");
      clearCurrentSketchGuideAndPoints();
    }
    if (widget.isViewInsideMode != oldWidget.isViewInsideMode) {
      debugPrint(
          "Mapbox didUpdateWidget: isViewInsideMode changed -> ${widget.isViewInsideMode}");
      // Potentially trigger actions based on this change if needed within MapboxState
    }
  }

  // First, let's update the initializeAnnotationManagers method to ensure proper layer ordering
  @override
  Future<void> initializeAnnotationManagers(MapboxMap mapboxMap) async {
    try {
      // Create polygon manager first (bottom layer)
      polygonAnnotationManager = await mapboxMap.annotations
          .createPolygonAnnotationManager(id: "polygon-annotation-layer");

      // Create polyline manager
      polylineAnnotationManager = await mapboxMap.annotations
          .createPolylineAnnotationManager(id: "polyline-annotation-layer");

      // Create circle manager
      circleAnnotationManager = await mapboxMap.annotations
          .createCircleAnnotationManager(id: "circle-annotation-layer");

      // Create point manager
      pointAnnotationManager = await mapboxMap.annotations
          .createPointAnnotationManager(id: "point-annotation-layer");

      String? pointLayerId = pointAnnotationManager?.id;
      String? circleLayerId = circleAnnotationManager?.id;
      String? polylineLayerId = polylineAnnotationManager?.id;
      String? polygonLayerId = polygonAnnotationManager?.id;

      print("Annotation managers initialized: "
          "Point: $pointLayerId, Circle: $circleLayerId, "
          "Polyline: $polylineLayerId, Polygon: $polygonLayerId");

      print("Annotation managers initialized with polylines on top layer.");
    } catch (e) {
      print("Error initializing annotation managers: $e");
      rethrow;
    }
  }

// Add this method to reorder layers to ensure lines are on top
  Future<void> ensureLinesOnTop() async {
    if (mapboxMap == null) return;

    try {
      // Get the style object to manipulate layers
      StyleManager styleManager = mapboxMap!.style;

      // Get layer ids - this is the correct method for many Mapbox implementations
      List<String> layerIds = await styleManager.getLayerIds();

      // Find the polyline annotation layer
      String? polylineLayerId;
      for (String id in layerIds) {
        if (id.contains('polyline')) {
          polylineLayerId = id;
          break;
        }
      }

      if (polylineLayerId != null) {
        // Move the polyline layer to the top
        await styleManager.moveLayer(
            polylineLayerId, null); // null means move to top
        print("Polyline layer moved to top: $polylineLayerId");
      } else {
        print("Could not find polyline annotation layer");
      }
    } catch (e) {
      print("Error ensuring lines on top: $e");
    }
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    debugPrint("Mapbox: _onMapCreated - Map controller assigned.");
    try {
      await initializeAnnotationManagers(mapboxMap);
      debugPrint("Mapbox: Annotation managers created successfully.");

      // Add click listeners to the managers
      pointAnnotationManager?.addOnPointAnnotationClickListener(
          CustomPointAnnotationClickListener(_handlePointAnnotationClick));
      polygonAnnotationManager?.addOnPolygonAnnotationClickListener(
          CustomPolygonAnnotationClickListener(_handlePolygonAnnotationClick));

      // Configure map gestures (optional, defaults are usually reasonable)
      await mapboxMap.gestures.updateSettings(GesturesSettings());
      debugPrint("Mapbox: Gestures updated/confirmed.");
    } catch (e) {
      debugPrint("Error during Mapbox setup (_onMapCreated): $e");
      widget.onFeedbackMessage
          ?.call("Error initializing map features."); // Notify parent UI
    }
  }

  // Adds a small pink dot at the given point
  Future<void> addVertexDot(Point point) async {
    if (circleAnnotationManager == null) return;

    try {
      final vertexDot =
          await circleAnnotationManager!.create(CircleAnnotationOptions(
        geometry: point,
        circleColor: POLYGON_VERTEX_DOT_COLOR,
        circleRadius: POLYGON_VERTEX_DOT_RADIUS,
      ));
      _vertexDots.add(vertexDot); // Store reference to remove later
      debugPrint("Vertex dot added at ${point.coordinates}");
    } catch (e) {
      debugPrint("Error adding vertex dot: $e");
    }
  }

  void _handlePointAnnotationClick(PointAnnotation annotation) {
    debugPrint("Mapbox: Point annotation clicked: ID ${annotation.id}");

    // If in text placement mode, handle it with the text label manager
    if (isInTextPlacementMode) {
      handleAnnotationClickForTextLabel(annotation, 'point').then((handled) {
        if (handled) {
          showTextInputDialog(context);
        }
      });
      return;
    }

    // Ignore clicks if actively drawing or sketching
    if (widget.isSketchingMode ||
        widget.isSketchingMode == false && isDrawingMode) {
      debugPrint(
          "Mapbox: Ignoring point click - active drawing/sketching mode.");
      if (widget.isSketchingMode &&
          widget.selectedSketchSubMode == SketchToolMode.move) {
        widget.onFeedbackMessage
            ?.call("Move mode: Select sketched items (TBD)");
      } else {
        widget.onFeedbackMessage
            ?.call("Exit current mode to interact with markers.");
      }
    } else {
      // Focus camera on the tapped annotation
      if (mapboxMap != null) {
        mapboxMap!.flyTo(
          CameraOptions(
              center: annotation.geometry, // The point's coordinates
              zoom: 20.0, // Adjust zoom level as needed
              padding: MbxEdgeInsets(top: 150, left: 0, bottom: 0, right: 255)),
          MapAnimationOptions(
              duration: 500), // Animation duration in milliseconds
        );
      }
      // Forward click to parent with annotation ID and its stored type
      String? annotationType = _annotationTypes[annotation.id];
      widget.onAnnotationClick?.call(annotation, annotationType);
    }
  }

  void _handlePolygonAnnotationClick(PolygonAnnotation annotation) {
    debugPrint("Mapbox: Polygon annotation clicked: ID ${annotation.id}");

    // If in text placement mode, handle it with the text label manager
    if (isInTextPlacementMode) {
      handleAnnotationClickForTextLabel(annotation, 'polygon').then((handled) {
        if (handled) {
          showTextInputDialog(context);
        }
      });
      return;
    }

    // If in View Inside mode, ignore polygon clicks for showing menus
    if (widget.isViewInsideMode) {
      // <-- CHECK PROP HERE
      print(
          "Mapbox: Ignoring polygon click - active View Inside mode (checked via prop).");
      // widget.onFeedbackMessage
      //     ?.call("In View Inside mode. Use back button to exit.");
      return;
    }

    bool isSketchPolygon =
        finalSketchPolygons.any((p) => p.id == annotation.id);

    // --- Handle click based on current mode ---

    // When in sketch mode and user clicks on a sketch polygon, show the sketch polygon action menu
    if (widget.isSketchingMode && isSketchPolygon) {
      print("Mapbox: Sketch polygon clicked in sketch mode: ${annotation.id}");

      if (mapboxMap != null) {
        Point center = calculatePolygonCenter(annotation);
        mapboxMap!.flyTo(
          CameraOptions(
              center: center,
              zoom: 20.5, // Adjust zoom level as needed
              padding: MbxEdgeInsets(
                  top: 100,
                  left: 0,
                  bottom: 0,
                  right: 55)), // adjust where the map is centered
          MapAnimationOptions(
              duration: 500), // Animation duration in milliseconds
        );
      }

      // Show the SketchPolygonActionMenu
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) => SketchPolygonActionMenu(
          onViewInside: () {
            enterViewInsideMode(annotation);
            widget.onFeedbackMessage?.call("View Inside mode activated.");
          },
          onDelete: () {
            // Delete the clicked sketch polygon
            deleteSketchPolygon(annotation);
            widget.onFeedbackMessage?.call("Sketch polygon deleted.");
          },
        ),
      );
      return;
    }

    // 1. Not Drawing or Sketching: Forward click for initial lot or potentially select sketch
    if (!widget.isSketchingMode && !isDrawingMode) {
      // Focus camera on the polygon center
      if (mapboxMap != null) {
        Point center = calculatePolygonCenter(annotation);
        mapboxMap!.flyTo(
          CameraOptions(
              center: center,
              zoom: 20.0, // Adjust zoom level as needed
              padding: MbxEdgeInsets(
                  top: 100,
                  left: 0,
                  bottom: 0,
                  right: 55)), // adjust where the map is centered
          MapAnimationOptions(
              duration: 500), // Animation duration in milliseconds
        );
      }

      // Original logic for handling initial lot polygon
      bool isInitialLot =
          initialLotPolygon != null && annotation.id == initialLotPolygon!.id;

      if (isInitialLot && widget.onPolygonClick != null) {
        debugPrint("Clicked initial lot polygon - forwarding to parent.");
        widget.onPolygonClick!(
            annotation); // Parent handles actions for initial lot
        showPolygonCoordinates(annotation);
      } else if (isSketchPolygon) {
        debugPrint("Clicked a final sketch polygon: ${annotation.id}");
        widget.onFeedbackMessage
            ?.call("Selected sketch polygon ${annotation.id}.");
        showPolygonCoordinates(annotation);
      } else {
        debugPrint("Ignoring click on an unknown/temporary polygon.");
      }
    }
    // 2. Sketching Mode: Handle for potential selection in "Move" sub-mode
    else if (widget.isSketchingMode) {
      debugPrint("Mapbox: Polygon click during sketch mode.");
      if (widget.selectedSketchSubMode == SketchToolMode.move) {
        if (isSketchPolygon) {
          widget.onFeedbackMessage?.call(
              "Move: Selected sketch polygon ${annotation.id} (Action TBD).");
          // TODO: Implement visual highlighting and state for selected element
        } else {
          widget.onFeedbackMessage
              ?.call("Move mode: Click directly on sketched items.");
        }
      } else {
        // Not in move mode
        widget.onFeedbackMessage
            ?.call("Switch to Move mode to select sketch items.");
      }
    }
    // 3. Initial Lot Drawing Mode: Ignore clicks on polygons
    else {
      // isDrawingMode must be true
      debugPrint(
          "Mapbox: Ignoring polygon click (active initial drawing mode).");
    }
  }

  // Display polygon coordinates when a polygon is clicked
  void showPolygonCoordinates(PolygonAnnotation polygon) {
    try {
      // Get polygon coordinates
      List<Position> positions = polygon.geometry.coordinates.first;

      // Format coordinates for display
      String coordText = positions
          .map((pos) =>
              "(${pos.lng.toStringAsFixed(6)}, ${pos.lat.toStringAsFixed(6)})")
          .join("\n");

      widget.onFeedbackMessage?.call("Polygon Coordinates:\n$coordText");
    } catch (e) {
      debugPrint("Error showing polygon coordinates: $e");
    }
  }

  // Calculate and show information about current polygon
  void showPolygonInfo() {
    List<Point> points = isDrawingMode ? drawnPoints : currentSketchPoints;

    if (points.length < 3) {
      widget.onFeedbackMessage
          ?.call("Need at least 3 points to form a polygon.");
      return;
    }

    // Format coordinates for display
    String coordText = points
        .map((p) =>
            "(${p.coordinates.lng.toStringAsFixed(6)}, ${p.coordinates.lat.toStringAsFixed(6)})")
        .join("\n");

    widget.onFeedbackMessage
        ?.call("Polygon with ${points.length} vertices:\n$coordText");
  }

  _onTap(MapContentGestureContext context) async {
    final tappedPoint = context.point;
    print("Mapbox _onTap: ENTERED. Coordinates: ${tappedPoint.coordinates}");
    print(
        "Mapbox _onTap: Current state - isSketchingMode=${widget.isSketchingMode}, isViewInsideMode=${widget.isViewInsideMode}, selectedTool=${widget.selectedSketchTool}");

    if (mapboxMap == null) {
      debugPrint("Mapbox: Tap ignored, map not ready.");
      return;
    } // Map must be initialized
    debugPrint("Mapbox: Map tapped at ${tappedPoint.coordinates}");

    // --- Handle Tap Based on Current Application Mode ---

    // 1. Sketching Mode Active?
    if (widget.isSketchingMode) {
      debugPrint(
          "Mapbox: Tap in Sketch Mode. Tool: ${widget.selectedSketchTool}, SubMode: ${widget.selectedSketchSubMode}");

      // Handle text tool separately
      if (widget.selectedSketchTool == 'text') {
        // When text tool is active, we ignore regular map taps
        // Text labels are added through annotation clicks
        widget.onFeedbackMessage
            ?.call("Tap on any annotation to add a text label.");
        return;
      }

      // Handle with sketch manager
      await handleSketchTap(tappedPoint, widget, mapboxMap!);

      // Add vertex dot for polygon/line sketches
      if (widget.selectedSketchSubMode == SketchToolMode.marker &&
          (widget.selectedSketchTool == 'polygon' ||
              widget.selectedSketchTool == 'line')) {
        await addVertexDot(tappedPoint);

        double distance = 0.0;
        if (currentSketchPoints.length >= 2) {
          try {
            Point lastPoint =
                currentSketchPoints[currentSketchPoints.length - 2];
            Point newPoint = currentSketchPoints.last;
            distance =
                await calculateDistanceBetweenPoints(lastPoint, newPoint);
            print(
                "Mapbox _onTap: Points count=${currentSketchPoints.length}, Calculated distance: $distance");
          } catch (e) {
            print("Mapbox _onTap: ERROR during distance calculation: $e");
            distance = -1.0;
          }
        }

        double area = 0.0;
        if (widget.selectedSketchTool == 'polygon' &&
            currentSketchPoints.length >= 3) {
          area = await calculateApproxPolygonArea(
              currentSketchPoints); // Use the approximate calculation
        }
        widget.onSketchMetricsUpdated?.call(area, distance);

        // Show coordinates of tapped point
        widget.onFeedbackMessage?.call(
            "Point added: (${tappedPoint.coordinates.lng.toStringAsFixed(6)}, ${tappedPoint.coordinates.lat.toStringAsFixed(6)})");
      }
      return; // Tap handled (or ignored) within Sketch Mode
    }

    // 2. Initial Lot Drawing Mode Active?
    else if (isDrawingMode) {
      debugPrint("Mapbox: Tap in Initial Drawing Mode.");
      if (isWaitingForCircleRadiusPoint) {
        resetInteractiveCircleState(); // Clear sketch temps if switching
      }
      drawnPoints.add(tappedPoint);

      // Add vertex dot at the tapped point
      await addVertexDot(tappedPoint);

      // Show coordinates of tapped point
      widget.onFeedbackMessage?.call(
          "Lot point added: (${tappedPoint.coordinates.lng.toStringAsFixed(6)}, ${tappedPoint.coordinates.lat.toStringAsFixed(6)})");

      await drawOrUpdateInitialLotPolygon(); // Update visual lot boundary including connecting lines
      return; // Tap handled
    }

    // 3. No Specific Mode Active - Forward to Parent
    else {
      debugPrint(
          "Mapbox: Tap in default mode. Forwarding to parent (for marker placement?).");
      if (isWaitingForCircleRadiusPoint) {
        resetInteractiveCircleState(); // Clear sketch temps
      }
      widget.onMapTapped?.call(tappedPoint); // Call parent's generic handler
      return; // Tap handled
    }
  }

  @override
  Future<void> drawOrUpdateInitialLotPolygon() async {
    if (polygonAnnotationManager == null || polylineAnnotationManager == null) {
      debugPrint("Mapbox: Error: Cannot draw initial lot, managers not ready.");
      widget.onFeedbackMessage?.call("Error: Cannot draw lot.");
      return;
    }

    try {
      List<Position> positions = drawnPoints.map((p) => p.coordinates).toList();

      // Simple delete/recreate for the single initial lot polygon
      if (initialLotPolygon != null) {
        // Delete previous version
        await polygonAnnotationManager!.delete(initialLotPolygon!);
        initialLotPolygon = null;
      }

      // Delete previous outline if it exists
      if (initialLotOutline != null) {
        await polylineAnnotationManager!.delete(initialLotOutline!);
        initialLotOutline = null;
      }

      // Always draw connecting lines between points, even if fewer than 3 points
      if (drawnPoints.length >= 2) {
        // Create a copy of positions for the polyline
        List<Position> linePositions = List.from(positions);

        // If we have 3 or more points, close the loop for the outline too
        if (drawnPoints.length >= 3) {
          linePositions.add(positions.first); // Close the loop for outline
        }

        // Draw connecting lines between points (polyline)
        PolylineAnnotationOptions lineOpts = PolylineAnnotationOptions(
          geometry: LineString(coordinates: linePositions),
          lineColor: INITIAL_LOT_OUTLINE_COLOR,
          lineWidth: INITIAL_LOT_OUTLINE_WIDTH,
          lineJoin: LineJoin.ROUND, // Make joins smoother
        );
        initialLotOutline = await polylineAnnotationManager!.create(lineOpts);
        debugPrint("Initial lot connecting lines created");
      }

      // Draw the polygon if there are 3 or more points
      if (drawnPoints.length >= 3) {
        List<Position> polyPos = List.from(positions)
          ..add(positions.first); // Close loop for polygon

        // Create the fill polygon
        PolygonAnnotationOptions opts = PolygonAnnotationOptions(
          geometry: Polygon(coordinates: [polyPos]),
          fillColor: Colors.white.value,
        );
        initialLotPolygon = await polygonAnnotationManager!.create(opts);
        debugPrint("Initial lot polygon created");
      }

      // Provide the updated point list to the parent
      widget.onLineDrawn?.call(drawnPoints);
    } catch (e) {
      debugPrint("Error drawing initial lot polygon: $e");
      widget.onFeedbackMessage?.call("Error updating lot boundary.");
    }
  }

  Future<double> calculateDistanceBetweenPoints(Point p1, Point p2) async {
    const double earthRadius = 6371000; // Earth radius in meters

    double lat1 = p1.coordinates.lat * math.pi / 180;
    double lon1 = p1.coordinates.lng * math.pi / 180;
    double lat2 = p2.coordinates.lat * math.pi / 180;
    double lon2 = p2.coordinates.lng * math.pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c; // Distance in meters
  }

  // --- Helper Function: Calculate Polygon Area (Shoelace on Lat/Lon - APPROXIMATE) ---
  // IMPORTANT: This provides a ROUGH estimate. For accurate geodetic area,
  // use a dedicated library (GeographicLib, Turf) or project coordinates first.
  Future<double> calculateApproxPolygonArea(List<Point> points) async {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    List<Position> coords = points.map((p) => p.coordinates).toList();

    // Ensure closed loop for calculation
    if (coords.first.lng != coords.last.lng ||
        coords.first.lat != coords.last.lat) {
      coords.add(coords.first);
    }

    for (int i = 0; i < coords.length - 1; i++) {
      // Using longitude as 'x' and latitude as 'y' for the formula
      area += (coords[i].lng * coords[i + 1].lat -
          coords[i + 1].lng * coords[i].lat);
    }
    area = area.abs() / 2.0;

    // This area is in "square degrees" - need to convert roughly to sq meters
    // This conversion is highly dependent on latitude. Let's use the center point's latitude.
    if (area > 0) {
      double centerLat =
          coords.map((p) => p.lat).reduce((a, b) => a + b) / coords.length;
      double metersPerDegreeLat =
          111132.954; // Approx meters per degree latitude
      double metersPerDegreeLon = 111319.488 *
          math.cos(centerLat *
              math.pi /
              180); // Approx meters per degree longitude at latitude

      return area * metersPerDegreeLat * metersPerDegreeLon;
    } else {
      return 0.0;
    }
  }

  // Method called by parent to START or STOP drawing the initial lot boundary
  void toggleDrawingMode(bool enabled) {
    debugPrint(
        "Mapbox: toggleDrawingMode (Initial Lot) called by parent: $enabled");
    isDrawingMode = enabled; // Update internal flag reflecting parent's request

    if (enabled) {
      // Starting initial lot drawing
      clearDrawing(); // Clear any previous lot and current sketch temps
      drawnPoints = []; // Reset points for the new lot
      debugPrint("Mapbox: Initial lot drawing mode STARTING.");
    } else {
      // Stopping initial lot drawing
      debugPrint("Mapbox: Initial lot drawing mode STOPPING.");
      // Show final coordinates when drawing is complete
      if (drawnPoints.length >= 3) {
        showPolygonInfo();
      }
    }
    // Notify parent that the mode has effectively changed (for UI updates)
    // This acts as confirmation or syncs state if parent wasn't the initiator
    widget.onDrawModeChanged?.call(enabled);
  }

  // Public methods for parent to call
  Future<void> finalizeCurrentSketch() async {
    // Show coordinates for the sketch before finalizing
    if (currentSketchPoints.length >= 3 &&
        widget.selectedSketchTool == 'polygon') {
      showPolygonInfo();
    }
    return handleFinalizeCurrentSketch(widget);

    // Ensure lines are on top
    await ensureLinesOnTop();
  }

  @override
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

      // Clean up the outline if it exists
      if (initialLotOutline != null && polylineAnnotationManager != null) {
        await polylineAnnotationManager!.delete(initialLotOutline!);
        initialLotOutline = null;
        debugPrint("Mapbox: Deleted initial lot outline from map.");
      }

      debugPrint("Mapbox: Cleared initial lot state.");
    } catch (e) {
      debugPrint("Error during clearDrawing's polygon deletion: $e");
    }
  }

  @override
  List<Point> currentSketchPoints = [];

  @override
  Future<void> clearCurrentSketchGuideAndPoints() async {
    if (currentSketchPoints.isEmpty &&
        _currentSketchGuidePolyline == null &&
        _tempCircleFeedback == null &&
        _vertexDots.isEmpty) {
      // Nothing to clear
      return;
    }

    debugPrint("Mapbox: Clearing current sketch guide and points.");
    currentSketchPoints = []; // Clear the points list
    resetInteractiveCircleState(); // Handles circle specifics (temp marker, flags)

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

  Future<void> addMarkerAtPoint(
      Point point, Uint8List markerImage, String markerType) async {
    debugPrint(
        "Mapbox: Adding marker at ${point.coordinates}, type: $markerType");

    if (pointAnnotationManager == null) {
      debugPrint("Mapbox: PointAnnotationManager not ready, can't add marker");
      widget.onFeedbackMessage
          ?.call("Error: Unable to add marker. Try again later.");
      return;
    }

    try {
      // Create point annotation options
      PointAnnotationOptions options = PointAnnotationOptions(
        geometry: point,
        image: markerImage,
        iconSize: 2,
      );

      // Create the point annotation
      PointAnnotation annotation =
          await pointAnnotationManager!.create(options);

      // Store the marker type for later reference
      _annotationTypes[annotation.id] = markerType;

      debugPrint(
          "Mapbox: Marker added successfully. ID: ${annotation.id}, Type: $markerType");
      widget.onFeedbackMessage?.call("$markerType marker added.");
    } catch (e) {
      debugPrint("Mapbox: Error adding marker: $e");
      widget.onFeedbackMessage?.call("Failed to add marker. Error: $e");
    }
  }

  Future<void> deleteAnnotation(PointAnnotation annotation) async {
    debugPrint("Mapbox: Deleting annotation with ID: ${annotation.id}");

    if (pointAnnotationManager == null) {
      debugPrint(
          "Mapbox: PointAnnotationManager not ready, can't delete annotation");
      widget.onFeedbackMessage
          ?.call("Error: Unable to delete marker. Try again later.");
      return;
    }

    try {
      // Delete the annotation
      await pointAnnotationManager!.delete(annotation);

      // Remove the annotation type from our storage
      _annotationTypes.remove(annotation.id);

      debugPrint("Mapbox: Marker deleted successfully. ID: ${annotation.id}");
      widget.onFeedbackMessage?.call("Marker deleted.");
    } catch (e) {
      debugPrint("Mapbox: Error deleting marker: $e");
      widget.onFeedbackMessage?.call("Failed to delete marker. Error: $e");
    }
  }

  Future<void> updateAnnotation(
      PointAnnotation annotation, String newType, Uint8List markerImage) async {
    debugPrint(
        "Mapbox: Updating annotation ${annotation.id} to type: $newType");

    if (pointAnnotationManager == null) {
      debugPrint(
          "Mapbox: PointAnnotationManager not ready, can't update annotation");
      widget.onFeedbackMessage
          ?.call("Error: Unable to update marker. Try again later.");
      return;
    }

    try {
      // Store the current position
      Point currentPosition = annotation.geometry;

      // Delete the existing annotation
      await pointAnnotationManager!.delete(annotation);
      _annotationTypes.remove(annotation.id);

      // Create a new annotation at the same position with the new image
      PointAnnotationOptions options = PointAnnotationOptions(
        geometry: currentPosition,
        image: markerImage,
        iconSize: 2,
      );

      // Create the new point annotation
      PointAnnotation newAnnotation =
          await pointAnnotationManager!.create(options);

      // Store the new marker type
      _annotationTypes[newAnnotation.id] = newType;

      debugPrint(
          "Mapbox: Marker updated successfully. Old ID: ${annotation.id}, New ID: ${newAnnotation.id}, New Type: $newType");
      widget.onFeedbackMessage?.call("$newType marker updated.");
    } catch (e) {
      debugPrint("Mapbox: Error updating marker: $e");
      widget.onFeedbackMessage?.call("Failed to update marker. Error: $e");
    }
  }

  Future<void> deletePolygon(PolygonAnnotation polygon) async {}

  // In MapboxState or similar class
  Future<void> drawPolygonFromMeasurements(
      Map<Side, Map<String, double>> measurements) async {
    debugPrint("Sketch Manager: Drawing polygon from measurements");

    if (mapboxMap == null) {
      debugPrint("Error: MapboxMap not initialized");
      return;
    }

    try {
      // Get the camera state to find the center of the map
      CameraState cameraState = await mapboxMap!.getCameraState();
      Point mapCenter = cameraState.center;

      debugPrint(
          "Map center: ${mapCenter.coordinates.lng}, ${mapCenter.coordinates.lat}");

      // Convert feet/inches to meters
      double topMeters = (measurements[Side.top]!['feet']! +
              (measurements[Side.top]!['inches']! / 12)) *
          0.3048;
      double rightMeters = (measurements[Side.right]!['feet']! +
              (measurements[Side.right]!['inches']! / 12)) *
          0.3048;
      double bottomMeters = (measurements[Side.bottom]!['feet']! +
              (measurements[Side.bottom]!['inches']! / 12)) *
          0.3048;
      double leftMeters = (measurements[Side.left]!['feet']! +
              (measurements[Side.left]!['inches']! / 12)) *
          0.3048;

      debugPrint(
          "Converted to meters - Top: $topMeters, Right: $rightMeters, Bottom: $bottomMeters, Left: $leftMeters");

      // Calculate the position for each corner of the polygon
      double topDegrees = metersToLatitudeDegrees(topMeters);
      double rightDegrees = metersToLongitudeDegrees(
          rightMeters, mapCenter.coordinates.lat.toDouble());
      double bottomDegrees = metersToLatitudeDegrees(bottomMeters);
      double leftDegrees = metersToLongitudeDegrees(
          leftMeters, mapCenter.coordinates.lat.toDouble());

      debugPrint(
          "Converted to degrees - Top: $topDegrees, Right: $rightDegrees, Bottom: $bottomDegrees, Left: $leftDegrees");

      // Create points for the polygon
      Point topLeft = Point(
          coordinates: Position(mapCenter.coordinates.lng - leftDegrees / 2,
              mapCenter.coordinates.lat + topDegrees / 2));

      Point topRight = Point(
          coordinates: Position(mapCenter.coordinates.lng + rightDegrees / 2,
              mapCenter.coordinates.lat + topDegrees / 2));

      Point bottomRight = Point(
          coordinates: Position(mapCenter.coordinates.lng + rightDegrees / 2,
              mapCenter.coordinates.lat - bottomDegrees / 2));

      Point bottomLeft = Point(
          coordinates: Position(mapCenter.coordinates.lng - leftDegrees / 2,
              mapCenter.coordinates.lat - bottomDegrees / 2));

      debugPrint("Polygon points calculated:");
      debugPrint(
          "TopLeft: ${topLeft.coordinates.lng}, ${topLeft.coordinates.lat}");
      debugPrint(
          "TopRight: ${topRight.coordinates.lng}, ${topRight.coordinates.lat}");
      debugPrint(
          "BottomRight: ${bottomRight.coordinates.lng}, ${bottomRight.coordinates.lat}");
      debugPrint(
          "BottomLeft: ${bottomLeft.coordinates.lng}, ${bottomLeft.coordinates.lat}");

      // Create the polygon
      List<Point> polygonPoints = [
        topLeft,
        topRight,
        bottomRight,
        bottomLeft,
        topLeft
      ];

      // Add to final sketches
      await addPolygonSketch(polygonPoints);

      debugPrint("Sketch Manager: Polygon created successfully");
    } catch (e) {
      debugPrint("Error creating polygon from measurements: $e");
    }
  }

// Helper methods to convert meters to degrees
  double metersToLatitudeDegrees(double meters) {
    // Approximate conversion (1 meter ≈ 0.000009 degrees of latitude)
    return meters * 0.000009;
  }

  double metersToLongitudeDegrees(double meters, double latitude) {
    // Longitude degrees vary with latitude
    // At the equator, 1 meter ≈ 0.000009 degrees of longitude
    // This decreases as you move toward the poles
    double factor = math.cos(latitude * math.pi / 180);
    return meters * 0.000009 / factor;
  }

  void enterViewInsideMode(PolygonAnnotation polygon) {
    print("Entering View Inside mode for polygon: ${polygon.id}");

    // Add the grid background
    _addGridBackground();

    // Notify parent component
    widget.onViewInsideModeChanged?.call(true, polygon);

    // You could also add code here to:
    // - Zoom into the polygon
    // - Highlight the selected polygon
    // - Restrict panning outside the polygon boundaries
    // - Add any other visual indicators for this mode
  }

  // Method to exit "View Inside" mode
  void exitViewInsideMode() {
    print("Exiting View Inside mode");

    // Remove the grid background
    _removeGridBackground();

    // Notify parent component
    widget.onViewInsideModeChanged?.call(false, null);
    print("Mapbox: exitViewInsideMode finished, notified parent.");
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), time: ${data.timeInterval}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));

    // 1. Load your grid PNG image from assets
    final ByteData bytes =
        await rootBundle.load('images/pngs/grid_pattern.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final MbxImage mbxImage = MbxImage(
      width: 512, // Replace with your image width
      height: 512, // Replace with your image height
      data: list,
    );
    await mapboxMap?.style.addStyleImage(
        "square-grid-pattern", // Image ID
        0.7, // Scale factor
        mbxImage, // Your image
        false, // SDF parameter (usually false for regular images)
        [], // stretchX - empty list if no stretching needed
        [], // stretchY - empty list if no stretching needed
        null // content - null if not needed
        );
  }

  // Update the _addGridBackground method to manage grid state
  void _addGridBackground() async {
    if (_isGridBackgroundActive) {
      print("Grid background already active");
      return; // Don't add multiple grid backgrounds
    }

    try {
      // get layer ids

      // Create a background layer using your grid pattern
      await mapboxMap?.style.addLayerAt(
          BackgroundLayer(
            id: "square-grid-background",
            backgroundPattern:
                "square-grid-pattern", // Reference the image by ID
            backgroundOpacity: 1, // Optional: adjust transparency
          ),
          LayerPosition(below: "polygon-annotation-layer"));

      _isGridBackgroundActive = true;
      print("Grid background added successfully");

      // Optional: Add a way to remove the grid after a delay or through a UI action
      // For example, add a "Exit View Inside" button or auto-remove after some time
    } catch (e) {
      print("Error adding grid background: $e");
      widget.onFeedbackMessage?.call("Could not display grid background: $e");
    }
  }

  void _removeGridBackground() async {
    if (!_isGridBackgroundActive) {
      print("No grid background to remove");
      return; // Don't try to remove if not active
    }

    try {
      // Remove the background layer by its ID
      await mapboxMap?.style.removeStyleLayer("square-grid-background");

      _isGridBackgroundActive = false;
      print("Grid background removed successfully");
    } catch (e) {
      print("Error removing grid background: $e");
      widget.onFeedbackMessage?.call("Could not remove grid background: $e");
    }
  }

  // Add this method to expose floor management functionality
  @override
  Future<void> changeActiveFloor(String floorName) async {
    debugPrint("Mapbox: Changing active floor to: $floorName");
    return super.changeActiveFloor(floorName);
  }

  @override
  Widget build(BuildContext context) {
    // Define initial map camera settings
    CameraOptions initialCamera = CameraOptions(
      center: Point(coordinates: Position(79.8612, 6.9271)), // Colombo, LK
      zoom: 12.0,
    );
    debugPrint("Mapbox: Building MapWidget...");
    return MapWidget(
      key: const ValueKey(
          "MapboxMapWidgetInstance"), // Helps Flutter identify the widget
      cameraOptions: initialCamera, // Set initial view
      styleUri: MapboxStyles.MAPBOX_STREETS, // Set base map style
      textureView: false, // Recommended for performance
      onMapCreated: _onMapCreated, // Callback when map controller is ready
      onTapListener: _onTap, // Callback for map taps
      // Other listeners like onScrollListener, onLongTap
      onStyleLoadedListener: _onStyleLoaded, // Add this line
    );
  }
}

extension on StyleManager {
  getLayerIds() {}

  moveLayer(String polylineLayerId, param1) {}
}
