import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/mapfiltermenu.dart/toggle_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

/// A widget that provides filter controls for a Mapbox map
/// Allows toggling different map layers on/off
class MapFilterMenu extends StatefulWidget {
  final mapbox.MapboxMap mapboxMap;

  const MapFilterMenu({super.key, required this.mapboxMap});

  @override
  State<MapFilterMenu> createState() => _MapFilterMenuState();
}

class _MapFilterMenuState extends State<MapFilterMenu> {
  // State variables to track visibility of menu and layers
  bool _showFilters = true;
  bool _zoningLayerVisible = true;
  final bool _newLayerVisible = true;

  @override
  void initState() {
    super.initState();
  }

  /// Toggles the visibility of the filter options
  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  /// Adds a new line layer to the map
  /// Creates a GeoJSON source and line layer with red styling
  void _addNewLayer() async {
    try {
      var source = mapbox.GeoJsonSource(id: "line", data: '''{
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [6.9271,79.8612],
            [6.9271,79.8612],
          ]
        }
      }''');
      debugPrint("Source added successfully");

      // Configure the line layer with styling properties
      var lineLayer = mapbox.LineLayer(
          id: "line-layer",
          sourceId: "line_source",
          lineColor: Colors.red.value,
          lineWidth: 3);

      lineLayer.lineColor = Colors.red.value;
      lineLayer.lineWidth = 3;

      // Attempt to get existing layer and replace it if found
      widget.mapboxMap.style.getLayer("line-layer").asStream().listen((event) {
        widget.mapboxMap.style.removeStyleLayer(event!.id);
        widget.mapboxMap.style.addLayerAt(lineLayer, mapbox.LayerPosition());
        widget.mapboxMap.style
            .setStyleLayerProperties(lineLayer.sourceId, "visible");
      });

      debugPrint("Layer added successfully");
    } catch (e) {
      debugPrint("Error adding layer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filter toggle button with rotation animation
            GestureDetector(
              onTap: _toggleFilters,
              child: Transform.rotate(
                angle: 90 * 3.141592653589793 / 180, // 90 degrees in radians
                child: PhosphorIcon(
                  PhosphorIconsRegular.sliders,
                  size: 24,
                  color: _showFilters
                      ? colors(context).colorPrimary6
                      : colors(context).colorBlack,
                ),
              ),
            ),
            // Animated container for filter options
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _showFilters
                  ? Row(
                      children: [
                        SizedBox(width: 16),
                        // Map toggle filters
                        ToggleItem(
                          label: AppString.at_map.localize(context) ??
                              'default label',
                          function: (isToggled) => {
                            debugPrint("pressed at map"),
                          },
                        ),
                        const SizedBox(width: 16),
                        ToggleItem(
                          label: AppString.pp_map.localize(context) ??
                              'default label',
                          function: (isToggled) => {
                            debugPrint("pressed pp map"),
                          },
                        ),
                        const SizedBox(width: 16),
                        // Zoning layer toggle with actual map layer visibility change
                        ToggleItem(
                          label: AppString.zoning_layer.localize(context) ??
                              'default label',
                          function: (isToggled) {
                            setState(() {
                              _zoningLayerVisible = !_zoningLayerVisible;
                            });
                            // Update the visibility of the road layer in Mapbox
                            widget.mapboxMap.style
                                .setStyleLayerProperty("road", "visibility",
                                    _zoningLayerVisible ? "visible" : "none")
                                .then((_) {
                              debugPrint(
                                  "Toggled zoning layer: $_zoningLayerVisible");
                            }).catchError((error) {
                              debugPrint(
                                  "Error setting layer visibility: $error");
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        ToggleItem(
                          label: AppString.data_layer.localize(context) ??
                              'default label',
                          function: (isToggled) => {
                            debugPrint("pressed data layer"),
                          },
                        ),
                        const SizedBox(width: 16),
                        // Custom layer toggle that adds a new layer when activated
                        ToggleItem(
                          label: 'New Layer',
                          function: (isTrue) {
                            if (isTrue) {
                              _addNewLayer();
                            }
                            // Commented code for toggling layer visibility
                            // setState(() {
                            //   _newLayerVisible = !_newLayerVisible;
                            // });
                            // widget.mapboxMap.style
                            //     .setStyleLayerProperty(
                            //         "line-layer",
                            //         "visibility",
                            //         _newLayerVisible ? "visible" : "none")
                            //     .then((_) {
                            //  debugPrint("Toggled new layer: $_newLayerVisible");
                            // }).catchError((error) {
                            //  debugPrint("Error setting layer visibility: $error");
                            // });
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
