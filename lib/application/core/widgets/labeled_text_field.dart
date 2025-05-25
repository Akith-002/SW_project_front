import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class LabeledTextField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final TextEditingController? controller;
  final IconData? icon;
  final double? width;
  final double? height;
  // Add validator property
  final FormFieldValidator<String>? validator;
  final Function(bool)? onErrorChange; // Add this new property

  const LabeledTextField({
    super.key,
    this.label,
    required this.placeholder,
    this.controller,
    this.icon,
    this.width,
    this.height,
    // Include validator in constructor
    this.validator,
    this.onErrorChange, // Add this to constructor
  });

  @override
  _LabeledTextFieldState createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late TextEditingController _controller;
  bool _isTyping = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Only dispose the controller if it was created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
      widget.onErrorChange?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = widget.width ?? (widget.icon != null ? 380 : 484);
    final double fieldHeight = widget.height ?? (widget.icon != null ? 48 : 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) // Label is optional
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: AppStyling.mediumTextSize14.copyWith(
                  color: colors(context).labelTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        Container(
          width: fieldWidth,
          height: fieldHeight,
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
                  controller: _controller,
                  enabled: true,
                  readOnly: false,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: false, // Changed from true to false
                    contentPadding: const EdgeInsets.symmetric(vertical: 14), // Increased padding for better centering
                    counterText: "",
                    // Show error message as hint text if there's an error and field is empty
                    // Otherwise show normal placeholder when field is empty
                    hintText: _controller.text.isEmpty 
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
                  onTap: () {
                    setState(() {
                      _isTyping = _controller.text.isNotEmpty;
                    });
                    _clearError();
                  },
                  onChanged: (value) {
                    setState(() {
                      _isTyping = value.isNotEmpty;
                      _errorMessage = null; // Clear error on change
                    });
                    widget.onErrorChange?.call(false);
                  },
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
              if (widget.icon != null) // Add icon if provided
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    widget.icon,
                    color: colors(context).textGrey,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}