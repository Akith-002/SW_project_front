import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/draw_polygon/rectanglePainter.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';

/// Enum representing the four sides of a polygon/rectangle
enum Side { left, right, top, bottom }

/// Dialog widget for collecting measurements for each side of a polygon
class DrawPolygonDialog extends StatefulWidget {
  const DrawPolygonDialog({super.key});

  @override
  State<DrawPolygonDialog> createState() => _DrawPolygonDialogState();
}

class _DrawPolygonDialogState extends State<DrawPolygonDialog> {
  /// Currently selected side for measurement input
  Side selectedSide = Side.left;

  /// Controllers for feet and inches input fields
  final feetController = TextEditingController();
  final inchesController = TextEditingController();

  /// Store measurements for each side in feet and inches
  final Map<Side, Map<String, double>> measurements = {
    Side.left: {'feet': 0, 'inches': 0},
    Side.right: {'feet': 0, 'inches': 0},
    Side.top: {'feet': 0, 'inches': 0},
    Side.bottom: {'feet': 0, 'inches': 0},
  };

  /// Convert Side enum to display string (capitalize first letter)
  String _sideToString(Side side) {
    return side.name[0].toUpperCase() + side.name.substring(1);
  }

  /// Convert display string back to Side enum
  Side _stringToSide(String sideString) {
    return Side.values.firstWhere(
      (side) => _sideToString(side) == sideString,
      orElse: () => Side.left,
    );
  }

  /// Get list of side options for dropdown
  List<String> get _sideOptions => Side.values.map(_sideToString).toList();

  /// Error message to display when validation fails
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Load initial values for the default selected side
    feetController.text = measurements[selectedSide]!['feet']!.toString();
    inchesController.text = measurements[selectedSide]!['inches']!.toString();
  }

  @override
  void dispose() {
    feetController.dispose();
    inchesController.dispose();
    super.dispose();
  }

  /// Save current input values to the measurements map before switching sides
  void _saveSideValues() {
    double feet = double.tryParse(feetController.text) ?? 0;
    double inches = double.tryParse(inchesController.text) ?? 0;

    measurements[selectedSide] = {'feet': feet, 'inches': inches};
  }

  /// Validate that all sides have non-zero measurements
  bool _validateMeasurements() {
    for (var side in Side.values) {
      if (measurements[side]!['feet']! <= 0 &&
          measurements[side]!['inches']! <= 0) {
        setState(() {
          errorMessage = "Please enter measurements for all sides";
        });
        return false;
      }
    }
    setState(() {
      errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        AppString.drawPolygon.localize(context)!,
        style: AppStyling.semiBoldTextSize18,
      ),
      contentPadding: const EdgeInsets.all(24),
      content: SizedBox(
        width: 510,
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input section: side selector and measurement fields
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dropdown to select which side to measure
                        CustomDropdownField(
                          label: 'Select Side',
                          items: _sideOptions,
                          initialValue: _sideToString(selectedSide),
                          onChanged: (value) {
                            _saveSideValues(); // Preserve current input
                            setState(() {
                              selectedSide = _stringToSide(value!);
                              // Load saved values for the newly selected side
                              feetController.text =
                                  measurements[selectedSide]!['feet']!
                                      .toString();
                              inchesController.text =
                                  measurements[selectedSide]!['inches']!
                                      .toString();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        // Feet and inches input fields side by side
                        Row(
                          children: [
                            Expanded(
                              child: LabeledTextField(
                                label: AppString.feet.localize(context)!,
                                placeholder: AppString.feet.localize(context)!,
                                controller: feetController,
                                width: 149,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: LabeledTextField(
                                placeholder:
                                    AppString.inches.localize(context)!,
                                label: AppString.inches.localize(context)!,
                                controller: inchesController,
                                width: 149,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Visual preview: rectangle with highlighted selected side
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: RectanglePainter(selectedSide),
                    ),
                  ),
                ],
              ),
              // Show validation error message if present
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel button - closes dialog without saving
            CustomButton(
              text: AppString.cancel.localize(context)!,
              onPressed: () => Navigator.pop(context, null),
              backgroundColor: colors(context).colorGrey1!,
            ),
            // Save button - validates and returns measurements
            CustomButton(
                text: AppString.save.localize(context)!,
                onPressed: () {
                  debugPrint("Save button pressed");
                  _saveSideValues(); // Save current input first

                  // Debug: log all measurements
                  for (var side in Side.values) {
                    debugPrint(
                        "Side: $side, Feet: ${measurements[side]!['feet']}, Inches: ${measurements[side]!['inches']}");
                  }

                  bool isValid = _validateMeasurements();
                  debugPrint("Validation result: $isValid");

                  if (isValid) {
                    debugPrint("Returning measurements and closing dialog");
                    // Return flattened measurement data for easy access
                    final result = {
                      'valid': true,
                      'action': 'save',
                      'leftFeet': measurements[Side.left]!['feet'],
                      'leftInches': measurements[Side.left]!['inches'],
                      'rightFeet': measurements[Side.right]!['feet'],
                      'rightInches': measurements[Side.right]!['inches'],
                      'topFeet': measurements[Side.top]!['feet'],
                      'topInches': measurements[Side.top]!['inches'],
                      'bottomFeet': measurements[Side.bottom]!['feet'],
                      'bottomInches': measurements[Side.bottom]!['inches'],
                    };

                    Navigator.of(context).pop<Map<String, dynamic>>(result);
                  } else {
                    debugPrint(
                        "Validation failed, showing error message but not closing dialog");
                    // Keep dialog open for user to fix validation errors
                  }
                },
                backgroundColor: colors(context).colorPrimary5!),
          ],
        ),
      ],
    );
  }
}
