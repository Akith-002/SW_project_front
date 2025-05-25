import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/draw_polygon/rectanglePainter.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';

enum Side { left, right, top, bottom }

class DrawPolygonDialog extends StatefulWidget {
  const DrawPolygonDialog({super.key});

  @override
  State<DrawPolygonDialog> createState() => _DrawPolygonDialogState();
}

class _DrawPolygonDialogState extends State<DrawPolygonDialog> {
  Side selectedSide = Side.left;

  final feetController = TextEditingController();
  final inchesController = TextEditingController();

  // Track measurements for each side
  final Map<Side, Map<String, double>> measurements = {
    Side.left: {'feet': 0, 'inches': 0},
    Side.right: {'feet': 0, 'inches': 0},
    Side.top: {'feet': 0, 'inches': 0},
    Side.bottom: {'feet': 0, 'inches': 0},
  };

  // Add this method to convert Side enum to display string
  String _sideToString(Side side) {
    return side.name[0].toUpperCase() + side.name.substring(1);
  }

  // Add this method to convert string back to Side enum
  Side _stringToSide(String sideString) {
    return Side.values.firstWhere(
      (side) => _sideToString(side) == sideString,
      orElse: () => Side.left,
    );
  }

  // Add this list for dropdown items
  List<String> get _sideOptions => Side.values.map(_sideToString).toList();

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values for the first side
    feetController.text = measurements[selectedSide]!['feet']!.toString();
    inchesController.text = measurements[selectedSide]!['inches']!.toString();
  }

  @override
  void dispose() {
    feetController.dispose();
    inchesController.dispose();
    super.dispose();
  }

  void _saveSideValues() {
    // Save the current values before switching sides
    double feet = double.tryParse(feetController.text) ?? 0;
    double inches = double.tryParse(inchesController.text) ?? 0;

    measurements[selectedSide] = {'feet': feet, 'inches': inches};
  }

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
        height: 180, // Slightly increased to accommodate error message
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left column: dropdown + inputs
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomDropdownField(
                        label: 'Select Side',
                        items: _sideOptions,
                        initialValue: _sideToString(selectedSide),
                        onChanged: (value) {
                          _saveSideValues(); // Save current values
                          setState(() {
                            selectedSide = _stringToSide(value!);
                            // Load values for the new side
                            feetController.text =
                                measurements[selectedSide]!['feet']!.toString();
                            inchesController.text =
                                measurements[selectedSide]!['inches']!
                                    .toString();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
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
                              placeholder: AppString.inches.localize(context)!,
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
                // Right: rectangle preview
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: CustomPaint(
                    size: const Size(120, 120),
                    painter: RectanglePainter(selectedSide),
                  ),
                ),
              ],
            ),
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
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              text: AppString.cancel.localize(context)!,
              onPressed: () => Navigator.pop(context, null),
              backgroundColor: colors(context).colorGrey1!,
            ),
            CustomButton(
                text: AppString.save.localize(context)!,
                onPressed: () {
                  debugPrint("Save button pressed");
                  _saveSideValues(); // Save current values first

                  // Debug print all measurements
                  for (var side in Side.values) {
                    debugPrint(
                        "Side: $side, Feet: ${measurements[side]!['feet']}, Inches: ${measurements[side]!['inches']}");
                  }

                  bool isValid = _validateMeasurements();
                  debugPrint("Validation result: $isValid");

                  if (isValid) {
                    debugPrint("Returning measurements and closing dialog");
                    // Create a new result structure with flattened measurements
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

                    // Remove the Future.delayed and just pop immediately
                    Navigator.of(context).pop<Map<String, dynamic>>(result);
                  } else {
                    debugPrint(
                        "Validation failed, showing error message but not closing dialog");
                    // Dialog stays open so user can fix the inputs
                  }
                },
                backgroundColor: colors(context).colorPrimary5!),
          ],
        ),
      ],
    );
  }
}
