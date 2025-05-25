import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class CustomDropdownField extends StatefulWidget {
  final String? label;
  final List<String> items;
  final String? initialValue;
  final Function(String?)? onChanged;
  final bool required;
  final String? Function(String?)? validator;
  final double? width;

  const CustomDropdownField({
    super.key,
    this.label,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.required = true,
    this.validator,
    this.width,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  late String? _selectedValue;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _errorMessage != null
        ? Colors.red
        : colors(context).dropDownBorderColor ?? Colors.grey;
    final double fieldWidth = widget.width ?? 484; // Default width if null

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Column(
            children: [
              Text(
                '${widget.label!}${widget.required ? ' *' : ''}',
                style: AppStyling.mediumTextSize14.copyWith(
                  color: colors(context).labelTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        Container(
          width: fieldWidth,
          height: 48,
          decoration: BoxDecoration(
            color: colors(context).colorWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: _selectedValue,
            icon: Icon(Icons.keyboard_arrow_down, color: borderColor),
            style: AppStyling.normalTextSize14
                .copyWith(color: colors(context).labelTextColor),
            dropdownColor: colors(context).colorWhite,
            isExpanded: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              errorText: null,
            ),
            validator: (value) {
              final error = widget.validator?.call(value) ??
                  (widget.required && (value == null || value.isEmpty)
                      ? 'This field is required'
                      : null);
              setState(() {
                _errorMessage = error;
              });
              return error;
            },
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
                _errorMessage = null;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: item == _selectedValue && _errorMessage != null
                        ? Colors.red
                        : colors(context).labelTextColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
