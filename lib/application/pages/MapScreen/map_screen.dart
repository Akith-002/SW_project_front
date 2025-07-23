import 'dart:developer'; // Import for log

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/draw_polygon/drawPolygonDialog.dart';
import 'package:land_asset_valuation/application/core/widgets/floor_manager.dart';
import 'package:land_asset_valuation/application/core/widgets/floatingIcon/floating_icon.dart';
import 'package:land_asset_valuation/application/core/widgets/s_data_action_menu/s_data_action_menu.dart';
import 'package:land_asset_valuation/application/core/widgets/save_building.dart';
import 'package:land_asset_valuation/application/core/widgets/save_menu.dart';
import 'package:land_asset_valuation/application/core/widgets/mapDrawMenu/map_draw_menu.dart';
import 'package:land_asset_valuation/application/core/widgets/surrounding_data_dialogbox.dart';
import 'package:land_asset_valuation/application/core/widgets/lot_action_menu.dart';
import 'package:land_asset_valuation/application/core/widgets/sketch_tools_menu.dart';
import 'package:land_asset_valuation/application/core/widgets/sketch_mode.dart';
import 'package:land_asset_valuation/application/core/widgets/save_lot.dart';
import 'package:land_asset_valuation/application/core/widgets/lot_area_widget.dart';
import 'package:land_asset_valuation/application/pages/mapbox/mapbox.dart';
import 'package:land_asset_valuation/data/models/building.dart';
import 'package:land_asset_valuation/data/models/marker_coordinate_model.dart';
import 'package:land_asset_valuation/data/services/building_service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:convert';
import 'package:land_asset_valuation/domain/usecases/save_la_lot_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_la_lots_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/save_building_rates_coordinate_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/save_past_valuations_coordinate_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/save_rental_evidence_coordinate_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/save_sales_evidence_coordinate_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_building_rates_coordinates_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_past_valuations_coordinates_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_rental_evidence_coordinates_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_sales_evidence_coordinates_usecase.dart';
import 'package:land_asset_valuation/injection.dart';

// Import for calculations if needed here (likely not)

import './map_marker_loader.dart';
import './map_mode_banner.dart';

/// Main map screen that provides land valuation functionality including:
/// - Interactive map view with lot selection
/// - Various marker placements for data points
/// - Lot drawing and sketching tools
/// - Navigation to associated data forms
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Key to interact with Mapbox widget's state
  final GlobalKey<MapboxState> mapboxKey = GlobalKey<MapboxState>();

  // Building service for persistence
  final BuildingService _buildingService = BuildingService();

  // Master file data properties
  String? _id;
  String? _masterFileNo;
  String? _masterFileRefNo;
  String? _planType;
  String? _planNo;
  String? _authorityRefNo;
  String? _status;
  String? _lots;

  // Mode state management
  bool isDrawingMode = false; // For drawing lot boundaries
  bool isMarkerPlacementMode = false; // For placing data markers
  bool isSketchingMode = false; // For sketching on lots
  String? selectedSketchTool; // Currently selected sketch tool
  SketchToolMode _selectedSketchSubMode = SketchToolMode.marker;
  PointAnnotation? _selectedMarkerForSketching;
  double _currentSketchArea = 0.0;
  double _lastSegmentDistance = 0.0;
  // Data association
  PolygonAnnotation? _selectedLotForSketching;
  // Field is used temporarily between async steps, ignore 'unused_field' warning - Commenting out for now as it seems unused
  // dynamic _buildingGeometryIdPendingSave;
  String? _savedLotId; // Store the user-selected lot ID from save dialog

  // Marker management
  late final MapMarkerLoader _markerLoader;
  bool _imagesLoaded = false; // Track loading state for UI

  // Add state variable for Save button visibility
  bool _showSaveButton = true;

  // Add a property to track if we're in view inside mode
  bool isViewInsideMode = false;
  PolygonAnnotation?
      _selectedPolygonForViewInside; // Keep for now, might be used later

  // Add a property to track the currently selected floor
  String _selectedFloor = 'Ground'; // Default to Ground floor

  @override
  void initState() {
    super.initState();
    debugPrint("MapScreen: initState called");

    _markerLoader = MapMarkerLoader();
    _loadMarkerImagesAsync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Extract master file data from query parameters
    _extractMasterFileData();
  }

  void _extractMasterFileData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;

    _id = queryParams['id'];
    _masterFileNo = queryParams['masterFileNo'];
    _masterFileRefNo = queryParams['masterFileRefNo'];
    _planType = queryParams['planType'];
    _planNo = queryParams['planNo'];
    _authorityRefNo = queryParams['authorityRefNo'];
    _status = queryParams['status'];
    _lots = queryParams['lots'];

    debugPrint(
        "MapScreen: Master File Data extracted - ID: $_id, Master File No: $_masterFileNo, Master File Ref No: $_masterFileRefNo, Plan Type: $_planType, Plan No: $_planNo, Authority Ref: $_authorityRefNo, Status: $_status, Lots: $_lots");

    // Load existing lots after extracting master file data
    _loadExistingLots();

    // Load existing markers after extracting master file data
    _loadExistingMarkers();
  }

  /// Loads existing lots for the current master file and displays them on the map
  void _loadExistingLots() async {
    if (_id == null) {
      debugPrint("MapScreen: No master file ID available to load lots");
      return;
    }

    final masterFileId = int.tryParse(_id!);
    if (masterFileId == null) {
      debugPrint("MapScreen: Invalid master file ID: $_id");
      return;
    }

    try {
      debugPrint(
          "MapScreen: Loading existing lots for master file ID: $masterFileId");

      final getLALotsUseCase = injection<GetLALotsUseCase>();
      final result = await getLALotsUseCase(masterFileId: masterFileId);

      result.fold(
        (failure) {
          debugPrint(
              "MapScreen: Failed to load existing lots: ${failure.message}");
          // Don't show error to user as this is not critical - might be no existing lots
        },
        (lots) {
          debugPrint(
              "MapScreen: Successfully loaded ${lots.length} existing lots");

          if (lots.isNotEmpty) {
            // Convert LALotModel to Map format expected by mapbox
            final lotsData = lots
                .map((lot) => {
                      'masterFileId': lot.masterFileId,
                      'coordinates': lot.coordinates,
                    })
                .toList();

            // Load the lots into the mapbox widget
            mapboxKey.currentState?.loadExistingLots(lotsData);

            debugPrint("MapScreen: Loaded ${lots.length} existing lot(s)");
          } else {
            debugPrint(
                "MapScreen: No existing lots found for this master file");
          }
        },
      );
    } catch (e) {
      debugPrint("MapScreen: Error loading existing lots: $e");
      // Don't show error to user as this is not critical
    }
  }

  /// Loads existing markers for the current master file and displays them on the map
  void _loadExistingMarkers() async {
    if (_id == null) {
      debugPrint("MapScreen: No master file ID available to load markers");
      return;
    }

    final masterFileId = int.tryParse(_id!);
    if (masterFileId == null) {
      debugPrint("MapScreen: Invalid master file ID: $_id");
      return;
    }

    try {
      debugPrint(
          "MapScreen: Loading existing markers for master file ID: $masterFileId");

      // Load all marker types concurrently
      final futures = [
        injection<GetBuildingRatesCoordinatesUseCase>()(
            masterfileId: masterFileId),
        injection<GetPastValuationsCoordinatesUseCase>()(
            masterfileId: masterFileId),
        injection<GetRentalEvidenceCoordinatesUseCase>()(
            masterfileId: masterFileId),
        injection<GetSalesEvidenceCoordinatesUseCase>()(
            masterfileId: masterFileId),
      ];

      final results = await Future.wait(futures);
      int totalMarkersLoaded = 0;

      // Process Building Rates markers
      results[0].fold(
        (failure) => debugPrint(
            "MapScreen: Failed to load Building Rates markers: ${failure.message}"),
        (markers) {
          debugPrint(
              "MapScreen: Loaded ${markers.length} Building Rates markers");
          for (final marker in markers) {
            _addExistingMarkerToMap(
                marker, MapMarkerLoader.markerTypeBuildingRates);
            totalMarkersLoaded++;
          }
        },
      );

      // Process Past Valuations markers
      results[1].fold(
        (failure) => debugPrint(
            "MapScreen: Failed to load Past Valuations markers: ${failure.message}"),
        (markers) {
          debugPrint(
              "MapScreen: Loaded ${markers.length} Past Valuations markers");
          for (final marker in markers) {
            _addExistingMarkerToMap(
                marker, MapMarkerLoader.markerTypeValuations);
            totalMarkersLoaded++;
          }
        },
      );

      // Process Rental Evidence markers
      results[2].fold(
        (failure) => debugPrint(
            "MapScreen: Failed to load Rental Evidence markers: ${failure.message}"),
        (markers) {
          debugPrint(
              "MapScreen: Loaded ${markers.length} Rental Evidence markers");
          for (final marker in markers) {
            _addExistingMarkerToMap(marker, MapMarkerLoader.markerTypeRental);
            totalMarkersLoaded++;
          }
        },
      );

      // Process Sales Evidence markers
      results[3].fold(
        (failure) => debugPrint(
            "MapScreen: Failed to load Sales Evidence markers: ${failure.message}"),
        (markers) {
          debugPrint(
              "MapScreen: Loaded ${markers.length} Sales Evidence markers");
          for (final marker in markers) {
            _addExistingMarkerToMap(marker, MapMarkerLoader.markerTypeSales);
            totalMarkersLoaded++;
          }
        },
      );

      if (totalMarkersLoaded > 0) {
        debugPrint("MapScreen: Loaded $totalMarkersLoaded existing marker(s)");
      } else {
        debugPrint("MapScreen: No existing markers found for this master file");
      }
    } catch (e) {
      debugPrint("MapScreen: Error loading existing markers: $e");
      // Don't show error to user as this is not critical
    }
  }

  /// Adds an existing marker to the map
  void _addExistingMarkerToMap(ExistingMarkerModel marker, String markerType) {
    try {
      // Parse coordinates from JSON string
      final coordinatesJson = jsonDecode(marker.coordinates);
      final lng = coordinatesJson['lng'] as double;
      final lat = coordinatesJson['lat'] as double;

      final point = Point(coordinates: Position(lng, lat));

      // Get marker image
      final img = _markerLoader.getImage(markerType);
      if (img.isNotEmpty) {
        mapboxKey.currentState?.addMarkerAtPoint(point, img, markerType);
        debugPrint(
            "MapScreen: Added existing $markerType marker at ($lat, $lng)");
      } else {
        debugPrint(
            "MapScreen: Failed to load icon for existing '$markerType' marker");
      }
    } catch (e) {
      debugPrint("MapScreen: Error adding existing marker to map: $e");
    }
  }

  /// Saves marker coordinates to the backend based on marker type
  void _saveMarkerCoordinate(Point point, String markerType) async {
    if (_id == null) {
      debugPrint(
          "MapScreen: No master file ID available to save marker coordinate");
      return;
    }

    final masterfileId = int.tryParse(_id!);
    if (masterfileId == null) {
      debugPrint("MapScreen: Invalid master file ID: $_id");
      return;
    }

    // Convert point to coordinate string format
    final coordinates = _convertPointToCoordinateString(point);

    try {
      debugPrint(
          "MapScreen: Saving $markerType coordinate - Coordinates: $coordinates, MasterFileId: $masterfileId");

      switch (markerType) {
        case MapMarkerLoader.markerTypeRental:
          final useCase = injection<SaveRentalEvidenceCoordinateUseCase>();
          final result = await useCase(
            masterfileId: masterfileId,
            coordinates: coordinates,
          );
          _handleMarkerCoordinateResult(result, markerType);
          break;

        case MapMarkerLoader.markerTypeSales:
          final useCase = injection<SaveSalesEvidenceCoordinateUseCase>();
          final result = await useCase(
            masterfileId: masterfileId,
            coordinates: coordinates,
          );
          _handleMarkerCoordinateResult(result, markerType);
          break;

        case MapMarkerLoader.markerTypeValuations:
          final useCase = injection<SavePastValuationsCoordinateUseCase>();
          final result = await useCase(
            masterfileId: masterfileId,
            coordinates: coordinates,
          );
          _handleMarkerCoordinateResult(result, markerType);
          break;

        case MapMarkerLoader.markerTypeBuildingRates:
          final useCase = injection<SaveBuildingRatesCoordinateUseCase>();
          final result = await useCase(
            masterfileId: masterfileId,
            coordinates: coordinates,
          );
          _handleMarkerCoordinateResult(result, markerType);
          break;

        default:
          debugPrint(
              "MapScreen: Unknown marker type for coordinate saving: $markerType");
          break;
      }
    } catch (e) {
      debugPrint("MapScreen: Error saving $markerType marker coordinate: $e");
      _showSnackbar("Failed to save $markerType marker coordinate",
          isError: true);
    }
  }

  /// Handles the result of saving marker coordinates
  void _handleMarkerCoordinateResult(dynamic result, String markerType) {
    result.fold(
      (failure) {
        debugPrint(
            "MapScreen: Failed to save $markerType coordinate: ${failure.message}");
        _showSnackbar("Failed to save $markerType coordinate", isError: true);
      },
      (response) {
        debugPrint("MapScreen: Successfully saved $markerType coordinate");
        // Don't show success message to avoid overwhelming the user
        // The "marker added" message is already shown
      },
    );
  }

  void _onSketchMetricsUpdated(double area, double distance) {
    if (!mounted) return;
    // Use debugPrint for detailed logging during development
    // debugPrint("MapScreen: _onSketchMetricsUpdated - Area: $area, Distance: $distance");
    // Only update state if values actually changed to avoid unnecessary rebuilds
    print(
        "MapScreen: Updating state for Area/Distance"); // Confirm setState is reached

    if (_currentSketchArea != area || _lastSegmentDistance != distance) {
      setState(() {
        _currentSketchArea = area;
        _lastSegmentDistance = distance;
      });
    }
  }

  /// Asynchronously loads all marker images at startup
  void _loadMarkerImagesAsync() async {
    debugPrint("MapScreen: Triggering marker image loading...");
    try {
      await _markerLoader.loadAllImages();
      debugPrint("MapScreen: Marker images loaded successfully via loader.");
      if (mounted) {
        setState(() => _imagesLoaded = true);
      }
    } catch (e) {
      debugPrint("MapScreen: FATAL Error loading marker images via loader: $e");
      if (mounted) {
        setState(() => _imagesLoaded = false);
        _showSnackbar('Error loading critical map icons. Cannot proceed.',
            isError: true, durationSeconds: 10);
      }
    }
  }

  /// Handles map tap events based on current active mode
  void _onMapTapped(Point point) async {
    if (!mounted) return;

    if (isMarkerPlacementMode) {
      // Exit placement mode immediately to prevent multiple dialogs
      setState(() => isMarkerPlacementMode = false);

      // Show dialog to select marker type
      final selectedOption = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PopupMenuWidget(
            onRentalEvidences: () =>
                Navigator.pop(context, MapMarkerLoader.markerTypeRental),
            onSalesEvidences: () =>
                Navigator.pop(context, MapMarkerLoader.markerTypeSales),
            onPastValuations: () =>
                Navigator.pop(context, MapMarkerLoader.markerTypeValuations),
            onBuildingRates: () =>
                Navigator.pop(context, MapMarkerLoader.markerTypeBuildingRates),
          );
        },
      );

      if (selectedOption != null) {
        // User selected a type, add the marker
        final img = _markerLoader.getImage(selectedOption);
        if (img.isNotEmpty) {
          mapboxKey.currentState?.addMarkerAtPoint(point, img, selectedOption);
          _showSnackbar("$selectedOption marker added.");

          // Save marker coordinates to backend
          _saveMarkerCoordinate(point, selectedOption);
        } else {
          _showSnackbar("Failed to load icon for '$selectedOption'.",
              isError: true);
        }
      } else {
        _showSnackbar("Marker placement cancelled.");
      }
      return;
    }

    if (isSketchingMode || isDrawingMode) {
      // Mapbox internal listener handles tap for drawing/sketching
      return;
    }

    debugPrint("MapScreen: Map tapped, no specific mode active.");
  }

  /// Handles when a marker on the map is clicked
  void _handlePointAnnotationClick(PointAnnotation annotation, String? type) {
    debugPrint("MapScreen: Marker Clicked - ID: ${annotation.id}, Type: $type");
    if (isDrawingMode || isSketchingMode) {
      debugPrint("Ignoring marker click - active drawing/sketching mode.");
      _showSnackbar("Exit current mode to interact with markers.");
      return;
    }

    // Get the source from the current route
    final String currentSource =
        GoRouterState.of(context).uri.queryParameters['source'] ?? '';
    _selectedMarkerForSketching = annotation; // Store the clicked marker

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => SDataActionMenu(
        source: currentSource, // Pass the source
        onViewUpdateDetails: () {
          Navigator.pop(dialogContext);
          _loadSurroundingDataForm(type);
        },
        onChangeType: () {
          Navigator.pop(dialogContext);
          Future.delayed(const Duration(milliseconds: 10), () {
            if (!mounted) return;
            _openUpdateDataDialogBox(context, annotation, type);
          });
        },
        onDelete: () {
          Navigator.pop(dialogContext);
          mapboxKey.currentState?.deleteAnnotation(annotation);
          _showSnackbar("Marker deleted.");
        },
        onSketchTool: () {
          // Navigator.pop(dialogContext); // Dialog pops itself now
          if (!mounted) return;
          _enterSketchingMode(context: context, fromMarker: true);
        },
      ),
    );
  }

  /// Handles when a polygon (lot) on the map is clicked
  void _handlePolygonClick(PolygonAnnotation polygon) {
    debugPrint("MapScreen: Polygon Clicked - ID: ${polygon.id}");
    if (isDrawingMode || isMarkerPlacementMode || isSketchingMode) {
      debugPrint("Ignoring polygon click - active mode.");
      _showSnackbar("Exit current mode to interact with the lot.");
      return;
    }

    _selectedLotForSketching = polygon;
    final String source =
        GoRouterState.of(context).uri.queryParameters['source'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => LotActionMenu(
        source: source,
        onSketchTool: () {
          Navigator.pop(dialogContext);
          if (!mounted || _selectedLotForSketching == null) return;
          mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
          setState(() {
            isSketchingMode = true;
            isDrawingMode = false;
            isMarkerPlacementMode = false;
            selectedSketchTool = null;
            _selectedSketchSubMode = SketchToolMode.marker;
            // _buildingGeometryIdPendingSave = null; // Removed
          });
          _showSnackbar(
              "Sketch Mode active. Draw building inside the selected lot.",
              durationSeconds: 3);
          debugPrint(
              "MapScreen: ENTERING Sketch Mode for Lot ID: ${_selectedLotForSketching!.id}. Tool set to polygon.");
        },
        onConditionReport: () {
          Navigator.pop(dialogContext);
          context.push(Pages.routeConditionReport.toPath());
        },
        onInspectionReport: () {
          Navigator.pop(dialogContext);
          // Pass master file data and saved lot ID as query parameters
          final queryParams = {
            if (_masterFileNo != null) 'masterFileNo': _masterFileNo!,
            if (_masterFileRefNo != null) 'masterFileRefNo': _masterFileRefNo!,
            if (_planType != null) 'planType': _planType!,
            if (_planNo != null) 'planNo': _planNo!,
            if (_authorityRefNo != null) 'authorityRefNo': _authorityRefNo!,
            if (_savedLotId != null) 'lotId': _savedLotId!,
          };

          final uri = Uri(
            path: Pages.routeInspectionReport.toPath(),
            queryParameters: queryParams,
          );

          context.push(uri.toString());
        },
      ),
    );
  }

  /// Enters the sketching mode, optionally linked to a marker or polygon
  void _enterSketchingMode(
      {required BuildContext context,
      bool fromMarker = false,
      PolygonAnnotation? polygonContext}) {
    if (!mounted) return;

    // Get the route source parameter
    final GoRouterState state = GoRouterState.of(context);
    final String source = state.uri.queryParameters['source'] ?? '';
    final bool isMRRentalEvidenceRoute = source == 'MRrentalEvidence';

    // Clear any guides from previous modes
    mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
    mapboxKey.currentState
        ?.toggleDrawingMode(false); // Ensure drawing mode is off

    setState(() {
      isSketchingMode = true;
      isDrawingMode = false;
      isMarkerPlacementMode = false;
      selectedSketchTool = null; // Default tool
      _selectedSketchSubMode = SketchToolMode.marker; // Default sub-mode
      _selectedLotForSketching = polygonContext; // Store polygon if provided
      _showSaveButton = true; // Show save button when entering sketch mode
      // _buildingGeometryIdPendingSave = null; // Removed
      // _selectedMarkerForSketching is already set if fromMarker is true
    });

    // Use different messages based on the source
    String message = "Sketch Mode active.";
    if (isMRRentalEvidenceRoute) {
      message = "MR Rental Evidence: Sketch Mode active. Draw a building.";
    } else if (fromMarker) {
      message = "Sketch Mode active. Draw around marker.";
    } else if (polygonContext != null) {
      message = "Sketch Mode active. Draw building inside the selected lot.";
    } else {
      message = "Sketch Mode active. Polygon tool selected.";
    }

    _showSnackbar(message, durationSeconds: 3);

    debugPrint(
        "MapScreen: ENTERING Sketch Mode. Tool: polygon. Context: ${fromMarker ? 'Marker' : (polygonContext != null ? 'Polygon' : 'None')}");
  }

  /// Navigates to the appropriate data form based on marker type
  void _loadSurroundingDataForm(String? type) {
    if (!mounted) return;
    debugPrint("MapScreen: Navigating to form for type: $type");
    String? targetPath;

    // Get the source context from route parameters
    final String source =
        GoRouterState.of(context).uri.queryParameters['source'] ?? '';

    // Prepare common query parameters to pass to all forms
    final commonQueryParams = <String, String>{};

    // Add master file data if available
    if (_id != null) commonQueryParams['masterFileId'] = _id!;
    if (_masterFileNo != null)
      commonQueryParams['masterFileNo'] = _masterFileNo!;
    if (_masterFileRefNo != null)
      commonQueryParams['masterFileRefNo'] = _masterFileRefNo!;
    if (_planType != null) commonQueryParams['planType'] = _planType!;
    if (_planNo != null) commonQueryParams['planNo'] = _planNo!;
    if (_authorityRefNo != null)
      commonQueryParams['authorityRefNo'] = _authorityRefNo!;
    if (_status != null) commonQueryParams['status'] = _status!;

    // Add coordinates from the selected marker if available
    if (_selectedMarkerForSketching != null) {
      final coords = _selectedMarkerForSketching!.geometry.coordinates;
      commonQueryParams['latitude'] = coords.lat.toString();
      commonQueryParams['longitude'] = coords.lng.toString();
      debugPrint(
          "MapScreen: Adding coordinates to navigation - Lat: ${coords.lat}, Lng: ${coords.lng}");
    }

    switch (type) {
      case MapMarkerLoader.markerTypeRental:
        final targetUri = Uri(
          path: Pages.routeRentalEvidence.toPath(),
          queryParameters:
              commonQueryParams.isNotEmpty ? commonQueryParams : null,
        );
        targetPath = targetUri.toString();
        debugPrint(
            "MapScreen: Navigating to Rental Evidence with masterFileId: $_id");
        break;
      case MapMarkerLoader.markerTypeSales:
        final targetUri = Uri(
          path: Pages.routeLaSalesEvidence.toPath(),
          queryParameters:
              commonQueryParams.isNotEmpty ? commonQueryParams : null,
        );
        targetPath = targetUri.toString();
        debugPrint(
            "MapScreen: Navigating to Sales Evidence with masterFileId: $_id");
        break;
      case MapMarkerLoader.markerTypeValuations:
        final targetUri = Uri(
          path: Pages.routePastValuation.toPath(),
          queryParameters:
              commonQueryParams.isNotEmpty ? commonQueryParams : null,
        );
        targetPath = targetUri.toString();
        debugPrint(
            "MapScreen: Navigating to Past Valuation with masterFileId: $_id");
        break;
      case MapMarkerLoader.markerTypeBuildingRates:
        // Context-aware navigation for Building Rates
        if (source == 'landMiscellaneous') {
          // For LM Building Rates, use only masterFileNo and coordinates
          final lmQueryParams = <String, String>{};
          if (_masterFileNo != null) {
            lmQueryParams['masterFileNo'] = _masterFileNo!;
          }

          // Add coordinates from the selected marker
          if (_selectedMarkerForSketching != null) {
            final coords = _selectedMarkerForSketching!.geometry.coordinates;
            lmQueryParams['latitude'] = coords.lat.toString();
            lmQueryParams['longitude'] = coords.lng.toString();
          }

          final targetUri = Uri(
            path: Pages.routeLmBuildingRates.toPath(),
            queryParameters: lmQueryParams.isNotEmpty ? lmQueryParams : null,
          );
          targetPath = targetUri.toString();
          debugPrint(
              "MapScreen: Navigating to LM Building Rates (source: $source, masterFileNo: $_masterFileNo)");
        } else {
          // For LA Building Rates, use common query parameters
          final targetUri = Uri(
            path: Pages.routeLaBuildingRates.toPath(),
            queryParameters:
                commonQueryParams.isNotEmpty ? commonQueryParams : null,
          );
          targetPath = targetUri.toString();
          debugPrint(
              "MapScreen: Navigating to LA Building Rates with masterFileId: $_id");
        }
        break;
      default:
        debugPrint("MapScreen: Cannot navigate: Unknown data type '$type'.");
        _showSnackbar("Cannot navigate: Unknown data type.", isError: true);
        break;
    }
    if (targetPath != null) {
      try {
        context.push(targetPath);
      } catch (e, stacktrace) {
        log("Navigation error",
            error: e, stackTrace: stacktrace); // Use log for errors
        _showSnackbar("Error navigating to form.", isError: true);
      }
    }
  }

  /// Opens dialog to change marker type
  void _openUpdateDataDialogBox(
      BuildContext context, PointAnnotation annotation, String? currentType) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => PopupMenuWidget(
        onRentalEvidences: () {
          Navigator.pop(dialogContext);
          _updateAnnotation(annotation, MapMarkerLoader.markerTypeRental);
        },
        onSalesEvidences: () {
          Navigator.pop(dialogContext);
          _updateAnnotation(annotation, MapMarkerLoader.markerTypeSales);
        },
        onPastValuations: () {
          Navigator.pop(dialogContext);
          _updateAnnotation(annotation, MapMarkerLoader.markerTypeValuations);
        },
        onBuildingRates: () {
          Navigator.pop(dialogContext);
          _updateAnnotation(
              annotation, MapMarkerLoader.markerTypeBuildingRates);
        },
      ),
    );
  }

  /// Updates a marker's type and appearance
  void _updateAnnotation(PointAnnotation annotation, String newType) async {
    debugPrint(
        "MapScreen: Request update for marker ${annotation.id} to $newType");
    if (!_imagesLoaded) {
      _showSnackbar("Cannot update: Marker images not ready.", isError: true);
      return;
    }

    final newImageData = _markerLoader.getImage(newType);

    if (newImageData.isEmpty) {
      debugPrint("MapScreen: Failed to get valid image data for type $newType");
      _showSnackbar("Cannot update: Failed to load icon for '$newType'.",
          isError: true);
      return;
    }
    mapboxKey.currentState?.updateAnnotation(annotation, newType, newImageData);
    _showSnackbar("Marker type updated to $newType.");
  }

  /// Handles sketch tool selection (line, rectangle, etc.)
  void _onSketchToolSelected(String toolId) {
    if (!mounted) return;
    debugPrint("MapScreen: Shape tool selected: $toolId");

    // For text tool, special handling
    if (toolId == 'text') {
      setState(() {
        selectedSketchTool = toolId;
        _selectedSketchSubMode = SketchToolMode.marker;
        isDrawingMode = false;
        isMarkerPlacementMode = false;
        // _buildingGeometryIdPendingSave = null;
      });

      mapboxKey.currentState?.startTextPlacementMode();
      _showSnackbar("Text tool active. Tap on any annotation to add a label.",
          durationSeconds: 3);
      return;
    }

    mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
    setState(() {
      selectedSketchTool = toolId;
      _selectedSketchSubMode = SketchToolMode.marker;
      isDrawingMode = false;
      isMarkerPlacementMode = false;
      // _buildingGeometryIdPendingSave = null;
    });
    _showSnackbar("Selected: $toolId. Draw mode active. Tap map.",
        durationSeconds: 3);
  }

  /// Handles changes to the sketching sub-mode (marker, edit, move, etc.)
  void _handleSketchSubModeChanged(SketchToolMode newMode) async {
    if (!mounted || _selectedSketchSubMode == newMode) {
      debugPrint(
          "MapScreen: Mode $newMode already active or component not mounted.");
      return;
    }
    debugPrint(
        "MapScreen: Handling potential Sketch Sub-Mode change to: $newMode");

    bool proceedWithModeChange = true;
    SketchToolMode finalMode = newMode;

    if (newMode == SketchToolMode.move) {
      final Map<String, dynamic>? result =
          await showDialog<Map<String, dynamic>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DrawPolygonDialog();
        },
      );

      debugPrint("Dialog result in MapScreen: $result");

      finalMode = SketchToolMode.marker;

      if (result != null && result['valid'] == true) {
        debugPrint("DrawPolygonDialog confirmed in MapScreen.");
        final measurementsMap = <Side, Map<String, double>>{
          Side.left: {
            'feet': result['leftFeet'] as double,
            'inches': result['leftInches'] as double,
          },
          Side.right: {
            'feet': result['rightFeet'] as double,
            'inches': result['rightInches'] as double,
          },
          Side.top: {
            'feet': result['topFeet'] as double,
            'inches': result['topInches'] as double,
          },
          Side.bottom: {
            'feet': result['bottomFeet'] as double,
            'inches': result['bottomInches'] as double,
          },
        };
        try {
          if (mapboxKey.currentState != null) {
            await mapboxKey.currentState!
                .drawPolygonFromMeasurements(measurementsMap);
            _showSnackbar("Polygon created successfully", durationSeconds: 2);
          } else {
            _showSnackbar("Error: Map state not available.", isError: true);
          }
        } catch (e) {
          debugPrint("Error creating polygon: $e");
          _showSnackbar("Error creating polygon: $e", isError: true);
        }
      } else {
        debugPrint(
            "DrawPolygonDialog was canceled or returned invalid result in MapScreen.");
        _showSnackbar("Polygon creation canceled", durationSeconds: 2);
      }
      proceedWithModeChange = false;
      if (mounted) {
        setState(() {
          _selectedSketchSubMode = finalMode;
        });
      }
    }

    if (proceedWithModeChange && mounted) {
      setState(() {
        _selectedSketchSubMode = finalMode;
      });
      _showSnackbar("Switched to ${finalMode.name} mode.");
      debugPrint(
          "MapScreen: Sketch Sub-Mode successfully changed to: $finalMode");
    } else if (!proceedWithModeChange) {
      debugPrint(
          "MapScreen: Sketch Sub-Mode change handled specially (e.g., measurement dialog), final mode: $finalMode");
    } else {
      debugPrint(
          "MapScreen: Sketch Sub-Mode change to $newMode aborted or component unmounted.");
    }
  }

  /// Called when a sketch is completed
  void _onSketchFinished() {
    if (!mounted) return;
    debugPrint(
        "MapScreen: 'onSketchFinished' callback received (internal completion).");
    // Optionally: _showSnackbar("${selectedSketchTool ?? 'Shape'} drawn. Click Save.", durationSeconds: 2);
  }

  /// Handles feedback messages from the map
  void _handleMapFeedback(String message) {
    if (!mounted) return;
    debugPrint("MapScreen: Feedback from Mapbox: $message");
    _showSnackbar(message, durationSeconds: 3);
  }

  /// Called when text placement (add/cancel) finishes in Mapbox widget
  void _onTextPlacementFinished() {
    if (!mounted) return;
    // If the text tool was active, deselect it
    if (selectedSketchTool == 'text') {
      setState(() {
        selectedSketchTool = null;
        // Optionally reset sub-mode if needed, though text tool doesn't use it much
        // _selectedSketchSubMode = SketchToolMode.marker;
      });
      debugPrint("MapScreen: Text placement finished, deselected text tool.");
    }
  }

  /// Exits sketching mode and clears any in-progress sketches
  void _exitSketchingMode() {
    if (!mounted) return;

    mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
    mapboxKey.currentState?.exitTextPlacementMode();

    setState(() {
      isSketchingMode = false;
      selectedSketchTool = null;
      _selectedSketchSubMode = SketchToolMode.marker;
      _selectedLotForSketching = null;
      // _buildingGeometryIdPendingSave = null; // Removed
      _selectedMarkerForSketching = null;
    });

    _showSnackbar("Exited sketching mode");
  }

  /// Shows a confirmation dialog when user tries to cancel lot saving
  Future<void> _showCancelConfirmationDialog(BuildContext parentContext) async {
    final bool? shouldRemove = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext confirmContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24,
              ),
              SizedBox(width: 8),
              Text('Warning'),
            ],
          ),
          content: Text(
            'The drawn lot will be removed if you don\'t assign a Lot ID. Do you want to continue?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(confirmContext).pop(false), // Don't remove
              child: Text(
                'Go Back',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(confirmContext).pop(true), // Remove lot
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Remove Lot'),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true) {
      // User confirmed to remove the lot
      Navigator.of(parentContext).pop(); // Close the SaveLot dialog

      // Remove the drawn lot from mapbox
      mapboxKey.currentState?.clearDrawing();

      // Exit drawing mode
      mapboxKey.currentState?.toggleDrawingMode(false);

      if (mounted) {
        setState(() {
          isDrawingMode = false;
        });
        _showSnackbar("Lot drawing cancelled and removed.");
      }
    }
    // If shouldRemove is false or null, do nothing (stay in SaveLot dialog)
  }

  /// Shows dialog to save a lot after drawing
  void _showSaveLotDialog() {
    // Parse the number of lots from the _lots string, default to 15 if parsing fails
    int numberOfLots = 15; // Default fallback
    if (_lots != null && _lots!.isNotEmpty) {
      numberOfLots = int.tryParse(_lots!) ?? 15;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 446),
            child: SaveLot(
              numberOfLots: numberOfLots,
              onCancel: () {
                _showCancelConfirmationDialog(dialogContext);
              },
              onSave: (String? selectedLotId) async {
                Navigator.of(dialogContext).pop();

                if (selectedLotId == null) {
                  _showSnackbar("Save cancelled or failed.", isError: true);
                  return;
                }

                // Store the selected lot ID for later use
                _savedLotId = selectedLotId;

                debugPrint('Selected Lot ID from Dialog: $selectedLotId');

                // Get the coordinates from the drawn polygon
                try {
                  final drawnPoints = mapboxKey.currentState?.drawnPoints;

                  if (drawnPoints == null || drawnPoints.isEmpty) {
                    _showSnackbar("No coordinates found to save.",
                        isError: true);
                    return;
                  }

                  // Convert coordinates to string format
                  final coordinatesString =
                      _convertCoordinatesToString(drawnPoints);

                  // Get master file ID from the URL parameters
                  final masterFileIdString = _id;
                  if (masterFileIdString == null) {
                    _showSnackbar("Master file ID not found.", isError: true);
                    return;
                  }

                  final masterFileId = int.tryParse(masterFileIdString);
                  if (masterFileId == null) {
                    _showSnackbar("Invalid master file ID.", isError: true);
                    return;
                  }

                  // Save lot to backend
                  final saveLALotUseCase = injection<SaveLALotUseCase>();
                  final result = await saveLALotUseCase(
                    masterFileId: masterFileId,
                    coordinates: coordinatesString,
                  );

                  result.fold(
                    (failure) {
                      _showSnackbar("Failed to save lot: ${failure.message}",
                          isError: true);
                    },
                    (response) {
                      _showSnackbar(
                          "Lot saved successfully! ${response.message ?? ''}");

                      // Finalize the drawing mode
                      mapboxKey.currentState?.toggleDrawingMode(false);

                      if (mounted) {
                        setState(() {
                          isDrawingMode = false;
                        });
                      }
                    },
                  );
                } catch (e) {
                  debugPrint('Error saving lot: $e');
                  _showSnackbar("Error saving lot: $e", isError: true);
                }
              },
            ),
          ),
        );
      },
    );
  }

  // Method to exit view inside mode
  void _exitViewInsideMode() {
    if (!mounted) return;

    mapboxKey.currentState?.exitViewInsideMode();

    setState(() {
      isViewInsideMode = false;
      _selectedPolygonForViewInside = null;

      _currentSketchArea = 0.0;
      _lastSegmentDistance = 0.0;

      isSketchingMode = false; // Assuming exit view inside also exits sketching
      selectedSketchTool = null;
      _selectedSketchSubMode = SketchToolMode.marker;
      _selectedLotForSketching = null; // Ensure context is cleared
      // _buildingGeometryIdPendingSave = null;
      _selectedMarkerForSketching = null;
    });

    mapboxKey.currentState
        ?.clearCurrentSketchGuideAndPoints(); // Clear any leftover guides

    _showSnackbar("Exited View Inside mode");
  }

  void _onViewInsideModeChanged(
      bool isInViewInsideMode, PolygonAnnotation? polygon) {
    if (!mounted) return;
    debugPrint(
        "MapScreen: _onViewInsideModeChanged called with: $isInViewInsideMode");

    if (isViewInsideMode == isInViewInsideMode) {
      debugPrint("MapScreen: State already matches, skipping setState");
      return;
    }

    setState(() {
      debugPrint(
          "MapScreen: setState START in _onViewInsideModeChanged for mode $isInViewInsideMode");
      isViewInsideMode = isInViewInsideMode;
      _selectedPolygonForViewInside = polygon; // Keep for now

      // Ensure other modes are correctly reset/set
      if (isInViewInsideMode) {
        isSketchingMode =
            true; // Automatically enter sketch mode when viewing inside
        isDrawingMode = false;
        isMarkerPlacementMode = false;

        _currentSketchArea = 0.0;
        _lastSegmentDistance = 0.0;
        selectedSketchTool = null; // Let's default to polygon tool
        _selectedSketchSubMode =
            SketchToolMode.marker; // Default to drawing points

        debugPrint(
            "MapScreen: Setting isSketchingMode=true, resetting other modes.");
        _selectedLotForSketching =
            polygon; // Use the polygon we are viewing inside
      } else {
        isSketchingMode = false; // Ensure sketching is off when exiting
        selectedSketchTool = null;
        _currentSketchArea = 0.0;
        _lastSegmentDistance = 0.0;
        _selectedLotForSketching = null;
        _selectedSketchSubMode = SketchToolMode.marker;
        _selectedMarkerForSketching = null;
        mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
        mapboxKey.currentState?.exitTextPlacementMode();
        debugPrint(
            "MapScreen: Exiting ViewInside mode, also exiting sketch mode.");
      }
      debugPrint("MapScreen: setState END in _onViewInsideModeChanged");
    });

    // Show feedback
    if (isInViewInsideMode) {
      _showSnackbar("View Inside mode: Polygon tool active. Tap to draw.",
          durationSeconds: 4);
    } else {
      _showSnackbar("Exited View Inside mode");
    }
  }

  /// Shows dialog to save building details
  void _showSaveBuildingDialog(dynamic buildingGeometryId) {
    debugPrint("🔥 _showSaveBuildingDialog called!");
    debugPrint("   Building Geometry ID: $buildingGeometryId");
    debugPrint(
        "   Selected Lot (polygon ID): ${_selectedLotForSketching?.id ?? 'None'}");
    debugPrint("   Saved Lot ID (dropdown): $_savedLotId");
    debugPrint("   Master File No: $_masterFileNo");

    // Get the current source from route parameters
    final GoRouterState state = GoRouterState.of(context);
    final String source = state.uri.queryParameters['source'] ?? '';
    debugPrint("   Route source: $source");
    // Remove unused variable
    // final bool isMRRentalEvidenceRoute = source == 'MRrentalEvidence';

    if (_selectedLotForSketching == null && source != 'MRrentalEvidence') {
      // Allow null lot for MR Rental
      debugPrint("❌ Error: No parent lot selected");
      _showSnackbar("Error: No parent lot selected.", isError: true);
      _exitSketchingMode();
      return;
    }

    // Parent lot ID might be null for MR Rental Evidence
    final String? parentLotId = _selectedLotForSketching?.id;
    debugPrint("   Parent Lot ID: $parentLotId");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 446),
            child: SaveBuilding(
              onCancel: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  // _buildingGeometryIdPendingSave = null;
                });
                _showSnackbar("Building save cancelled.");
              },
              onSave: (String buildingName, String constructionType) async {
                Navigator.of(dialogContext).pop();
                debugPrint("🏗️ === SAVE BUILDING DIALOG TRIGGERED ===");
                debugPrint(
                    "Parent Lot ID (polygon): ${_selectedLotForSketching?.id ?? 'None'}");
                debugPrint("Saved Lot ID (dropdown): $_savedLotId");
                debugPrint("Building Name: $buildingName");
                debugPrint("Construction Type: $constructionType");
                debugPrint("Master File No: $_masterFileNo");
                debugPrint("=====================================");

                // Get the finalized polygon coordinates from the last sketch
                final finalPolygons =
                    mapboxKey.currentState?.finalSketchPolygons;
                debugPrint(
                    "🔍 Final polygons count: ${finalPolygons?.length ?? 0}");

                if (finalPolygons != null && finalPolygons.isNotEmpty) {
                  final lastPolygon = finalPolygons.last;
                  final coordinates = lastPolygon.geometry.coordinates.first;
                  debugPrint("📍 Coordinates count: ${coordinates.length}");

                  // Create building object
                  final building = Building(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: buildingName,
                    constructionType: constructionType,
                    lotId: _savedLotId ??
                        'unknown', // Use the saved lot ID from dropdown, not the polygon ID
                    masterFileNo: _masterFileNo ?? 'unknown',
                    coordinates: coordinates,
                    createdAt: DateTime.now(),
                  );

                  debugPrint(
                      "🏢 Created building object: ${building.name} (ID: ${building.id})");
                  debugPrint(
                      "   Lot ID: ${building.lotId} (using _savedLotId instead of polygon ID)");
                  debugPrint("   Master File: ${building.masterFileNo}");

                  // Save building to storage
                  final success = await _buildingService.saveBuilding(building);

                  if (success) {
                    debugPrint("✅ Building saved successfully to storage");
                    if (mounted) {
                      _showSnackbar(
                          "Building '$buildingName' saved successfully!");
                      setState(() {
                        selectedSketchTool = null; // Deselect tool
                        _selectedSketchSubMode = SketchToolMode.marker;
                        _showSaveButton =
                            false; // Hide save button after successful save
                        mapboxKey.currentState
                            ?.clearCurrentSketchGuideAndPoints();
                      });
                    }
                  } else {
                    debugPrint("❌ Failed to save building to storage");
                    if (mounted) {
                      _showSnackbar("Failed to save building '$buildingName'",
                          isError: true);
                    }
                  }
                } else {
                  debugPrint("❌ No building polygon found to save");
                  if (mounted) {
                    _showSnackbar("No building polygon found to save",
                        isError: true);
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  /// Handles the main save button action
  void _handleSaveAction() async {
    if (!mounted) return;

    debugPrint("🚀 === SAVE BUTTON PRESSED ===");
    debugPrint(
        "DrawMode: $isDrawingMode, SketchMode: $isSketchingMode, Tool: $selectedSketchTool");
    debugPrint(
        "Current Sketch Points: ${mapboxKey.currentState?.currentSketchPoints.length ?? 0}");
    debugPrint("============================");

    if (isDrawingMode) {
      // Finalize the initial lot drawing and show save dialog
      // Check if enough points exist
      if ((mapboxKey.currentState?.drawnPoints.length ?? 0) >= 3) {
        mapboxKey.currentState?.toggleDrawingMode(false); // Stop drawing first
        _showSaveLotDialog(); // Show dialog to save the lot
      } else {
        _showSnackbar("Lot requires at least 3 points to save.", isError: true);
      }
    } else if (isSketchingMode) {
      try {
        // For building sketches - if using polygon tool and not in a specific mode that handles its own save
        if (selectedSketchTool == 'polygon') {
          debugPrint("🏗️ Processing polygon tool save...");
          // Get points from the mapbox state
          final sketchPoints = mapboxKey.currentState?.currentSketchPoints;

          // Check if we have enough points to form a polygon
          if (sketchPoints == null || sketchPoints.length < 3) {
            debugPrint("❌ Not enough points: ${sketchPoints?.length ?? 0}");
            _showSnackbar("Need at least 3 points to save a building.",
                isError: true);
            return;
          }

          // Finalize the current sketch to create the polygon annotation
          mapboxKey.currentState?.finalizeCurrentSketch();

          // Show the building save dialog with the polygon we just created
          // We don't need the return value from finalizeCurrentSketch since we're just showing the dialog
          _showSaveBuildingDialog(
              "polygon"); // Pass a simple identifier since we don't use the actual value
        }
        // Partitions, lines, etc.
        else if (selectedSketchTool == 'partition' ||
            selectedSketchTool == 'line' ||
            selectedSketchTool == 'circle') {
          // Simply finalize these types of sketches
          mapboxKey.currentState?.finalizeCurrentSketch();

          // Show success feedback
          _showSnackbar("${selectedSketchTool ?? 'Sketch'} saved.");

          // Clear the tool selection after saving
          setState(() {
            selectedSketchTool = null;
            _showSaveButton = false; // Hide save button
          });
        }
        // If no sketch tool is selected or using another tool
        else {
          if (selectedSketchTool == null) {
            _showSnackbar("Select a sketch tool first.", isError: true);
          } else {
            // Attempt to finalize whatever other sketch is active
            await mapboxKey.currentState?.finalizeCurrentSketch();
            _showSnackbar("Sketch saved.");

            // Clear the tool selection
            setState(() {
              selectedSketchTool = null;
              _showSaveButton = false; // Hide save button
            });
          }
        }
      } catch (e) {
        debugPrint("MapScreen: Error during sketch save: $e");
        _showSnackbar("Error saving sketch.", isError: true);
      }
    } else {
      _showSnackbar("Nothing to save. Draw a lot or sketch first.");
    }
  }

  /// Converts list of Points to JSON string format for API
  String _convertCoordinatesToString(List<Point> points) {
    final coordinates = points
        .map((point) => {
              'lng': point.coordinates.lng,
              'lat': point.coordinates.lat,
            })
        .toList();

    return jsonEncode(coordinates);
  }

  String _convertPointToCoordinateString(Point point) {
    final coordinate = {
      'lng': point.coordinates.lng,
      'lat': point.coordinates.lat,
    };
    return jsonEncode(coordinate);
  }

  // Add the build method at the class level
  @override
  Widget build(BuildContext context) {
    // Get the current source from route parameters
    final GoRouterState state = GoRouterState.of(context);
    final String source = state.uri.queryParameters['source'] ??
        (state.extra as Map<String, dynamic>?)?['source'] as String? ??
        '';

    debugPrint("MapScreen: Build called. Source: $source");

    // Determine if only the Add Marker button should be shown
    final bool showOnlyAddMarker = source == 'MRrentalEvidence';

    debugPrint(
        "MapScreen: Build UI. ImagesLoaded:$_imagesLoaded, DrawMode:$isDrawingMode, SketchMode:$isSketchingMode ($_selectedSketchSubMode, $selectedSketchTool), MarkPlaceMode:$isMarkerPlacementMode");
    debugPrint(
        "MapScreen Build: isViewInsideMode = $isViewInsideMode, selectedSketchTool = $selectedSketchTool, _selectedFloor = $_selectedFloor"); // Added _selectedFloor
    if (!_imagesLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading Map...")),
        body: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Loading map resources...")
          ],
        )),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Mapbox(
            key: mapboxKey,
            isSketchingMode: isSketchingMode,
            selectedSketchTool: selectedSketchTool,
            isViewInsideMode: isViewInsideMode, // <-- PASS THE PROP
            selectedSketchSubMode: _selectedSketchSubMode,
            onFeedbackMessage: _handleMapFeedback,
            onViewInsideModeChanged: _onViewInsideModeChanged,
            onTextPlacementFinished: _onTextPlacementFinished,
            onSketchMetricsUpdated:
                _onSketchMetricsUpdated, // <-- PASS CALLBACK

            onDrawModeChanged: (isDrawing) {
              if (mounted && isDrawingMode != isDrawing) {
                setState(() {
                  isDrawingMode = isDrawing;
                  if (isDrawing) {
                    isSketchingMode = false;
                    isMarkerPlacementMode = false;
                    selectedSketchTool = null;
                    _selectedSketchSubMode = SketchToolMode.marker;
                    _selectedLotForSketching = null;
                    // _buildingGeometryIdPendingSave = null; // Removed
                    mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
                    mapboxKey.currentState?.exitTextPlacementMode();
                  }
                });
              }
            },
            onMapTapped: _onMapTapped,
            onAnnotationClick: _handlePointAnnotationClick,
            onPolygonClick: _handlePolygonClick,
            onSketchFinished: _onSketchFinished,
          ),

          // Semi-transparent overlay for non-active floors' partitions
          // This overlay will only appear over the partitions from other floors
          // We no longer need a full-screen overlay since partitions have their own opacity

          if (!isSketchingMode && !isViewInsideMode)
            Positioned(
              bottom: 20,
              right: 20,
              child: MapDrawMenu(
                showOnlyAddMarker: showOnlyAddMarker,
                onAddMarker: () {
                  if (!mounted) return;
                  // Add curly braces
                  if (isDrawingMode || isSketchingMode) {
                    _exitSketchingMode();
                  }
                  mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
                  mapboxKey.currentState?.toggleDrawingMode(false);
                  setState(() {
                    isMarkerPlacementMode = true;
                    isDrawingMode = false;
                    isSketchingMode = false;
                    selectedSketchTool = null;
                    _selectedSketchSubMode = SketchToolMode.marker;
                    _selectedLotForSketching = null;
                    // _buildingGeometryIdPendingSave = null; // Removed
                  });
                  _showSnackbar("Tap map to place a marker");
                },
                onAddDrawer: () {
                  if (!mounted) return;
                  // Add curly braces
                  if (isSketchingMode) {
                    _exitSketchingMode();
                  }
                  mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
                  mapboxKey.currentState?.toggleDrawingMode(true);
                  _showSnackbar("Start drawing initial lot boundaries.");
                },
                onClearSelection: () {
                  if (!mounted) return;
                  mapboxKey.currentState?.toggleDrawingMode(false);
                  mapboxKey.currentState?.clearDrawing();
                  mapboxKey.currentState?.clearCurrentSketchGuideAndPoints();
                  _exitSketchingMode();
                  setState(() {
                    isDrawingMode = false;
                    isMarkerPlacementMode = false;
                  });
                  _showSnackbar("Selection and modes cleared");
                },
              ),
            ),
          Positioned(
            top: 40,
            right: 20,
            child: SafeArea(
              child: SaveMenu(
                onSave:
                    _handleSaveAction, // Ensure this points to the correct method
              ),
            ),
          ),
          // Floor Manager - only visible when in View Inside mode
          if (isViewInsideMode)
            Positioned(
              top: 100,
              right: 20,
              child: SafeArea(
                child: FloorManager(
                  onFloorSelected: _onFloorSelected,
                ),
              ),
            ),
          if (isSketchingMode) // Show only when View Inside mode is active
            Positioned(
              bottom: 20,
              left: 20,
              child: SafeArea(
                top: false, // No safe area needed at top for bottom widget
                right: false,
                child: LotAreaWidget(
                  area: _currentSketchArea,
                  lastDistance: _lastSegmentDistance,
                ),
              ),
            ),

          if (isSketchingMode)
            Positioned(
              top: 110,
              left: 20,
              child: SafeArea(
                child: SketchToolsMenu(
                  key: ValueKey('sketch-tools-$isViewInsideMode'),
                  initialTool: selectedSketchTool,
                  isViewInsideMode: isViewInsideMode,
                  onToolSelected: _onSketchToolSelected,
                ),
              ),
            ),

          if (isSketchingMode)
            Positioned(
              top: 40,
              left: 20,
              child: SafeArea(
                child: FloatingIcon(
                  onPressed: isViewInsideMode
                      ? _exitViewInsideMode // Use specific exit for view inside
                      : _exitSketchingMode, // General exit for sketching
                  size: 24,
                  colorName: Theme.of(context).colorScheme.primary,
                  icon: PhosphorIconsRegular.arrowLeft,
                ),
              ),
            ),
          if (isSketchingMode)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: SketchMode(
                      selectedMode: _selectedSketchSubMode,
                      onModeChanged: _handleSketchSubModeChanged,
                    ),
                  ),
                ),
              ),
            ),
          MapModeBanner(
            isDrawingMode: isDrawingMode,
            isMarkerPlacementMode: isMarkerPlacementMode,
            isSketchingMode: isSketchingMode,
            isViewInsideMode: isViewInsideMode,
            selectedSketchTool: selectedSketchTool,
            selectedSketchSubMode: _selectedSketchSubMode,
          ),
        ],
      ),
    );
  }

  /// Displays a snackbar message to the user
  void _showSnackbar(String message,
      {bool isError = false, int durationSeconds = 3}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent[700] : Colors.black87,
        duration: Duration(seconds: durationSeconds),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  void _onFloorSelected(String floorName) async {
    if (!mounted) return;

    debugPrint("MapScreen: Floor selected: $floorName");

    // Update the state to reflect the newly selected floor
    setState(() {
      _selectedFloor = floorName;
    });

    try {
      // Tell MapboxState to handle internal logic (like fading annotations if needed in future)
      await mapboxKey.currentState?.changeActiveFloor(floorName);

      // Show feedback to the user
      _showSnackbar("Switched to floor: $floorName.");
    } catch (e) {
      debugPrint("Error changing active floor: $e");
      _showSnackbar("Error changing to floor: $floorName", isError: true);
    }
  }
}
