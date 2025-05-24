import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapMarkerLoader {
  // Marker type constants - made public static for access from MapScreen
  static const String markerTypeRental = "Rental Evidences";
  static const String markerTypeSales = "Sales Evidences";
  static const String markerTypeValuations = "Past Valuations";
  static const String markerTypeBuildingRates = "Building Rates";

  // Private storage for loaded images
  Uint8List? _rentalMarkerImage;
  Uint8List? _salesMarkerImage;
  Uint8List? _valuationsMarkerImage;
  Uint8List? _buildingRatesMarkerImage;
  bool _imagesLoaded = false;

  // --- Image Loading ---

  // Helper function to load a single image asset
  Future<Uint8List> _loadHQMarkerImage(String assetPath) async {
    try {
      // IMPORTANT: Ensure your pubspec.yaml includes the assets directory:
      // flutter:
      //   assets:
      //     - images/pngs/ # Or the specific path to your images
      final byteData = await rootBundle.load(assetPath);
      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error loading image '$assetPath': $e");
      rethrow; // Propagate the error
    }
  }

  // Loads all marker images required
  Future<void> loadAllImages() async {
    debugPrint("MapMarkerLoader: Loading marker images...");
    if (_imagesLoaded) {
      debugPrint("MapMarkerLoader: Images already loaded.");
      return;
    }
    try {
      // Load only the MapPin_RE image for all marker types
      final rentalImage = await _loadHQMarkerImage("images/pngs/MapPin_RE.png");

      // Use the same image for all marker types
      _rentalMarkerImage = rentalImage;
      _salesMarkerImage = rentalImage;
      _valuationsMarkerImage = rentalImage;
      _buildingRatesMarkerImage = rentalImage;

      _imagesLoaded = true;
      debugPrint("MapMarkerLoader: Marker images loaded successfully.");
    } catch (e) {
      debugPrint("MapMarkerLoader: FATAL Error loading marker images: $e");
      _imagesLoaded = false; // Ensure state reflects failure
      rethrow; // Let the caller handle the UI feedback for the error
    }
  }

  // Retrieves the appropriate marker image based on the type string
  Uint8List getImage(String? markerOption) {
    // Default tiny transparent 1x1 pixel PNG
    final defaultImage = Uint8List.fromList([
      137,
      80,
      78,
      71,
      13,
      10,
      26,
      10,
      0,
      0,
      0,
      13,
      73,
      72,
      68,
      82,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      8,
      6,
      0,
      0,
      0,
      31,
      15,
      200,
      137,
      0,
      0,
      0,
      11,
      73,
      68,
      65,
      84,
      120,
      1,
      99,
      97,
      0,
      2,
      0,
      0,
      6,
      2,
      24,
      227,
      196,
      48,
      0,
      0,
      0,
      0,
      73,
      69,
      78,
      68,
      174,
      66,
      96,
      130
    ]);

    if (!_imagesLoaded) {
      debugPrint(
          "Warning: Accessing marker image before loading complete. Returning default.");
      return defaultImage;
    }

    switch (markerOption) {
      case markerTypeRental:
        return _rentalMarkerImage!;
      case markerTypeSales:
        return _salesMarkerImage!;
      case markerTypeValuations:
        return _valuationsMarkerImage!;
      case markerTypeBuildingRates:
        return _buildingRatesMarkerImage!;
      default:
        debugPrint(
            "Warning: Unknown marker type '$markerOption'. Using default image.");
        return defaultImage;
    }
  }

  // Getter to check if images are loaded
  bool get areImagesLoaded => _imagesLoaded;
}
