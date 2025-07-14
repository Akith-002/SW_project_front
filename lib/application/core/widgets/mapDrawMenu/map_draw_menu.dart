import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/mapDrawMenu/draw_menu_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A expandable floating menu for map drawing operations.
///
/// This widget provides a collapsible UI for map interactions like drawing shapes,
/// adding markers, and clearing selections. It appears as a floating action button
/// that expands to show multiple options when tapped.
class MapDrawMenu extends StatefulWidget {
  final VoidCallback onAddMarker; // Callback when user adds a marker
  final VoidCallback onAddDrawer; // Callback when user activates drawing mode
  final VoidCallback
      onClearSelection; // Callback when user clears existing selections
  final bool showOnlyAddMarker; // New flag

  const MapDrawMenu({
    super.key,
    required this.onAddMarker,
    required this.onAddDrawer,
    required this.onClearSelection,
    this.showOnlyAddMarker = false, // Default to false
  });

  @override
  State<MapDrawMenu> createState() => _MapDrawMenuState();
}

class _MapDrawMenuState extends State<MapDrawMenu> {
  bool _isMenuVisible = false;

  /// Toggles the visibility of the expanded menu options
  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Animated container that shows/hides menu items
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isMenuVisible
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Conditionally show Draw/Clear options
                      if (!widget.showOnlyAddMarker) ...[
                        DrawMenuItem(
                          icon: PhosphorIconsRegular.pencilSimple,
                          onPressed: () {
                            widget.onAddDrawer();
                            _toggleMenu();
                          },
                          menuText:
                              AppString.draw_selection_layer.l10n(context)!,
                        ),
                        SizedBox(height: 14),
                        DrawMenuItem(
                          icon: PhosphorIconsRegular.polygon,
                          onPressed: () {
                            // TODO: Implement measured selection logic
                            _toggleMenu();
                          },
                          menuText: AppString.draw_measured_selection_layer
                              .l10n(context)!,
                        ),
                        SizedBox(height: 14),
                        DrawMenuItem(
                          icon: PhosphorIconsRegular.eraser,
                          onPressed: () {
                            widget.onClearSelection();
                            _toggleMenu();
                          },
                          menuText: AppString.clear_selection_layer
                              .l10n(context)!,
                        ),
                        SizedBox(height: 14),
                      ],

                      // Always show Add Marker option when menu is visible
                      DrawMenuItem(
                        icon: PhosphorIconsRegular.pushPin,
                        onPressed: () {
                          widget.onAddMarker();
                          _toggleMenu();
                        },
                        menuText: AppString.add_marker.l10n(context)!,
                      ),
                      SizedBox(height: 14),
                    ],
                  )
                : SizedBox.shrink(),
          ),

          // Main toggle button that always remains visible
          // Shows + when collapsed, X when expanded
          DrawMenuItem(
            icon: _isMenuVisible
                ? PhosphorIconsRegular.x
                : PhosphorIconsRegular.plus,
            iconColor: _isMenuVisible
                ? colors(context).colorGrey3
                : colors(context).colorPrimary6,
            size: 40,
            onPressed: _toggleMenu,
          ),
        ],
      ),
    );
  }
}
