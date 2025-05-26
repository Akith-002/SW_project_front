import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class LabeledDateField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Function(bool)? onErrorChange;

  const LabeledDateField({
    Key? key,
    this.label,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.onErrorChange,
  }) : super(key: key);

  @override
  State<LabeledDateField> createState() => _LabeledDateFieldState();
}

class _LabeledDateFieldState extends State<LabeledDateField> {
  String? _errorMessage;

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
      widget.onErrorChange?.call(false);
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    _clearError(); // Clear error when user interacts
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors(context).colorPrimary5!,
              onPrimary: Colors.white,
              onSurface: colors(context).labelTextColor!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      // Clear error message and validate the field
      setState(() {
        _errorMessage = widget.validator?.call(widget.controller.text);
      });
      // Notify parent about error state change
      widget.onErrorChange?.call(_errorMessage != null);

      // Force the form field to revalidate
      Form.of(context)?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: AppStyling.mediumTextSize14.copyWith(
                color: colors(context).labelTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _errorMessage != null
                  ? Colors.red
                  : colors(context).dropDownBorderColor!,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  readOnly: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: false, // Changed from true to false
                    contentPadding: const EdgeInsets.symmetric(vertical: 14), // Increased padding for better centering
                    counterText: "",
                    // Show error message as hint text if there's an error and field is empty
                    // Otherwise show normal placeholder when field is empty
                    hintText: widget.controller.text.isEmpty 
                        ? (_errorMessage ?? widget.placeholder) 
                        : null,
                    // Explicitly set errorText to null to prevent showing error below
                    errorText: null,
                    // Set errorStyle with height 0 to completely hide any error text
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    hintStyle: TextStyle(
                      // Use red color for error message, normal color for placeholder
                      color: _errorMessage != null 
                          ? Colors.red 
                          : colors(context).labelTextColor,
                      fontSize: 14, // Ensure consistent font size
                      height: 1.0, // Consistent line height
                    ),
                  ),
                  onTap: () => _showDatePicker(context),
                  validator: (value) {
                    if (!mounted) return null;

                    final result = widget.validator?.call(value);
                    if (mounted) {
                      setState(() {
                        _errorMessage = result;
                      });
                      widget.onErrorChange?.call(result != null);
                    }
                    // Return null instead of the error to prevent Flutter from showing it below
                    return null;
                  },
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: colors(context).labelTextColor,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}