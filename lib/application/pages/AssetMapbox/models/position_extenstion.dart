import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

extension PositionExtension on Position {
  bool equals(Position other) {
    return lng == other.lng && lat == other.lat;
  }
}
