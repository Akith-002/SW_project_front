import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SketchToolsMenu extends StatefulWidget {
  final Function(String)? onToolSelected;
  final String? initialTool;
  final bool isViewInsideMode;

  const SketchToolsMenu({
    super.key,
    this.onToolSelected,
    this.initialTool,
    this.isViewInsideMode = false,
  });

  @override
  State<SketchToolsMenu> createState() => _SketchToolsMenuState();
}

class _SketchToolsMenuState extends State<SketchToolsMenu> {
  bool _isExpanded = true; // Start collapsed by default, feels more natural
  String? _selectedTool;

  @override
  void initState() {
    super.initState();
    _selectedTool = widget.initialTool; // Only set what parent provides

    debugPrint(
        "SketchToolsMenu INIT: ViewInside: ${widget.isViewInsideMode}, Parent initialTool: ${widget.initialTool}, Selected: $_selectedTool");
  }

  @override
  void didUpdateWidget(covariant SketchToolsMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Debug print update triggers
    debugPrint(
        "SketchToolsMenu didUpdateWidget: New isViewInside=${widget.isViewInsideMode}, Old=${oldWidget.isViewInsideMode}, New initialTool=${widget.initialTool}, Old=${oldWidget.initialTool}, Current internal tool=$_selectedTool");

    bool needsSetState = false;

    // 1. Handle Mode Change (if it somehow occurs without full rebuild)
    if (widget.isViewInsideMode != oldWidget.isViewInsideMode) {
      debugPrint(
          "SketchToolsMenu: Mode changed in didUpdateWidget (less common scenario).");
      // Reset the tool based strictly on the new mode
      _selectedTool = widget.isViewInsideMode ? 'line' : 'polygon';
      _isExpanded = false; // Collapse menu on mode change detected here
      needsSetState = true;
    }
    // 2. Handle External Tool Change (when mode remains the same)
    else if (widget.initialTool != _selectedTool) {
      // Check if the new initialTool is valid for the current mode
      bool newToolIsValidForMode = true;
      if (widget.isViewInsideMode && widget.initialTool == 'polygon') {
        newToolIsValidForMode = false;
        debugPrint(
            "SketchToolsMenu: Received invalid initialTool ('${widget.initialTool}') for ViewInside mode. Ignoring update.");
      }

      if (newToolIsValidForMode) {
        debugPrint(
            "SketchToolsMenu: External tool change detected and applied: ${widget.initialTool}");
        _selectedTool = widget.initialTool;
        needsSetState = true;
      }
    }

    // Apply state changes if necessary
    if (needsSetState) {
      setState(() {});
    }
  }

  // Helper to get the list of tools based on the current mode
  List<Map<String, dynamic>> _getTools(BuildContext context) {
    if (widget.isViewInsideMode) {
      return [
        {
          'id': 'line',
          'label': AppString.line.l10n(context)!,
          'icon': PhosphorIcons.lineSegment(
              PhosphorIconsStyle.regular), // Use lineSegment for clarity
        },
        {
          'id': 'circle',
          'label': AppString.circle.l10n(context)!,
          'icon': PhosphorIcons.circle(PhosphorIconsStyle.regular),
        },
        {
          'id': 'text',
          'label': AppString.text.l10n(context)!,
          'icon': PhosphorIcons.textT(PhosphorIconsStyle.regular),
        },
        {
          'id': 'partition',
          'label': AppString.partition.l10n(context)!,
          'icon': PhosphorIcons.house(PhosphorIconsStyle.regular),
        },
        {
          'id': 'graph',
          'label': AppString.graph.l10n(context)!,
          'icon': PhosphorIcons.chartLine(PhosphorIconsStyle.regular),
        },
        {
          'id': 'report',
          'label': AppString.report.l10n(context)!,
          'icon': PhosphorIcons.notebook(PhosphorIconsStyle.regular),
        },
        {
          'id': 'image',
          'label': AppString.image.l10n(context)!,
          'icon': PhosphorIconsRegular.imageSquare, // Correct icon name
        },
      ];
    } else {
      // Return the standard sketch tools
      return [
        {
          'id': 'polygon',
          'label': AppString.polygon.l10n(context)!,
          'icon': PhosphorIcons.pentagon(PhosphorIconsStyle.regular),
        },
        {
          'id': 'line',
          'label': AppString.line.l10n(context)!,
          'icon': PhosphorIcons.lineSegment(
              PhosphorIconsStyle.regular), // Use lineSegment for clarity
        },
        {
          'id': 'circle',
          'label': AppString.circle.l10n(context)!,
          'icon': PhosphorIcons.circle(PhosphorIconsStyle.regular),
        },
        {
          'id': 'text',
          'label': AppString.text.l10n(context)!,
          'icon': PhosphorIcons.textT(PhosphorIconsStyle.regular),
        },
        // Keep 'image' if it's implemented, otherwise remove
        {
          'id': 'image',
          'label': AppString.image.l10n(context)!,
          'icon': PhosphorIconsRegular.imageSquare, // Correct icon name
        },
      ];
    }
  }

  // Helper to get the display information for the currently selected tool
  Map<String, dynamic>? _getSelectedToolInfo(BuildContext context) {
    if (_selectedTool == null) return null;
    try {
      // Get tools appropriate for the *current* mode
      return _getTools(context)
          .firstWhere((tool) => tool['id'] == _selectedTool);
    } catch (e) {
      // This might happen if the selected tool becomes invalid after a mode switch
      // before the state updates completely. Return null.
      debugPrint(
          "SketchToolsMenu Warning: Could not find info for tool '$_selectedTool' in current mode (isViewInside: ${widget.isViewInsideMode}). Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tools = _getTools(context);
    final selectedToolDisplayInfo = _getSelectedToolInfo(context);

    // Debug print for the build method
    debugPrint(
        "SketchToolsMenu building: ViewInside: ${widget.isViewInsideMode}, internal selectedTool: $_selectedTool, Got tools count: ${tools.length}, SelectedInfo: ${selectedToolDisplayInfo?['id']}");
    if (widget.isViewInsideMode) {
      debugPrint(
          "View Inside Tools Available: ${tools.map((t) => t['id']).join(', ')}");
    } else {
      debugPrint(
          "Normal Sketch Tools Available: ${tools.map((t) => t['id']).join(', ')}");
    }

    return Container(
      width: 200, // Keep consistent width
      decoration: BoxDecoration(
        color: colors(context).colorWhite ?? Colors.white, // Provide fallback
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color:
                colors(context).colorBlack?.withOpacity(0.15) ?? // Use fallback
                    LightColorList.lightColorBlack.withOpacity(0.15),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space
        children: [
          // --- Header Row (Tappable to expand/collapse) ---
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: _isExpanded
                    ? Radius.zero
                    : Radius.circular(8)), // Match container border
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10), // Adjusted padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Display Logic for Header ---
                  Expanded(
                    // Allow text/icon row to take available space
                    child: _isExpanded
                        ? Text(
                            // Show title when expanded
                            AppString.sketchTool.l10n(context)!,
                            style: AppStyling.normalTextSize15.copyWith(
                                fontWeight:
                                    FontWeight.w600 // Slightly bolder title
                                ),
                            overflow: TextOverflow.ellipsis,
                          )
                        : (selectedToolDisplayInfo !=
                                null // Show selected tool when collapsed
                            ? Row(
                                children: [
                                  PhosphorIcon(
                                    selectedToolDisplayInfo['icon'],
                                    color: colors(context).colorIconBlack ??
                                        Colors.black87,
                                    size: 22, // Slightly smaller icon in header
                                  ),
                                  const SizedBox(width: 10), // Adjusted spacing
                                  Expanded(
                                    // Allow label to take space and ellipsis
                                    child: Text(
                                      selectedToolDisplayInfo['label'],
                                      style:
                                          AppStyling.normalTextSize15.copyWith(
                                        color: colors(context).colorGrey7 ??
                                            Colors.grey[700],
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Handle long labels
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                // Fallback when collapsed and no tool selected
                                AppString.selectTool.l10n(context)!,
                                style: AppStyling.normalTextSize15.copyWith(
                                  color: colors(context).colorGrey7 ??
                                      Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              )),
                  ),
                  // --- Caret Icon ---
                  Padding(
                    // Add padding around caret for easier tapping
                    padding: const EdgeInsets.only(left: 8.0),
                    child: PhosphorIcon(
                      _isExpanded
                          ? PhosphorIconsRegular.caretUp
                          : PhosphorIconsRegular.caretDown,
                      color: colors(context).colorIconDefault ?? Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Animated Tool List ---
          AnimatedCrossFade(
            firstChild: Container(
              // Add padding for the list items, separate from header padding
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: tools.map((tool) {
                  // Use the internal _selectedTool state for highlighting
                  final bool isSelected = _selectedTool == tool['id'];
                  return Padding(
                    // Add vertical spacing between buttons
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, // Inner padding for button content
                        vertical: 10,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedTool = tool['id'];
                          _isExpanded = false; // Collapse after selection
                        });
                        // Notify the parent widget
                        widget.onToolSelected?.call(tool['id']);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6), // Slightly smaller radius for items
                      ),
                      color: isSelected
                          ? (colors(context).colorPrimary1 ??
                              Theme.of(context).primaryColorLight)
                          : null, // Use theme fallback
                      elevation:
                          isSelected ? 1 : 0, // Subtle elevation for selected
                      hoverElevation: 1, // Elevation on hover
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // Fit content
                      child: Row(
                        children: [
                          PhosphorIcon(
                            tool['icon'],
                            color: isSelected
                                ? (colors(context).colorWhite ?? Colors.white)
                                : (colors(context).colorGrey7 ??
                                    Colors.grey[700]),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            // Ensure text doesn't overflow container
                            child: Text(
                              tool['label'],
                              style: TextStyle(
                                color: isSelected
                                    ? (colors(context).colorWhite ??
                                        Colors.white)
                                    : (colors(context).colorGrey7 ??
                                        Colors.grey[700]),
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handle long labels
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Use SizedBox.shrink() for the collapsed state
            secondChild: const SizedBox.shrink(),
            // Control the animation based on the _isExpanded state
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            // Animation duration
            duration: const Duration(milliseconds: 250), // Slightly longer fade
            // Curves for fading
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeOut,
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
