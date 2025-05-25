import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Custom Click Listener for Point Annotations (Markers)
class CustomPointAnnotationClickListener
    extends OnPointAnnotationClickListener {
  final Function(PointAnnotation) onClick;

  CustomPointAnnotationClickListener(this.onClick);

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    onClick(annotation);
    return true; // Consume the event
  }
}

// Custom Click Listener for Polygon Annotations
class CustomPolygonAnnotationClickListener
    extends OnPolygonAnnotationClickListener {
  final Function(PolygonAnnotation) onClick;

  CustomPolygonAnnotationClickListener(this.onClick);

  @override
  bool onPolygonAnnotationClick(PolygonAnnotation annotation) {
    onClick(annotation);
    return true; // Consume the event
  }
}
