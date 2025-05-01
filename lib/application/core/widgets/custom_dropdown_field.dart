import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class CustomDropdownField extends StatefulWidget {
  final String? label;
  final List<String> items;
  final String initialValue;
  final Function(String) onChanged;
  final double? width;

  const CustomDropdownField({
    super.key,
    this.label,
    required this.items,
    required this.initialValue,
    required this.onChanged,
    this.width,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.items.contains(widget.initialValue)
        ? widget.initialValue
        : widget.items.isNotEmpty
            ? widget.items.first
            : '';
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        colors(context).dropDownBorderColor ?? Colors.grey;
    final double fieldWidth = widget.width ?? 484; // Default width if null

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Column(
            children: [
              Text(widget.label!,
                  style: AppStyling.mediumTextSize14.copyWith(
                      color: colors(context).labelTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedValue.isNotEmpty ? _selectedValue : null,
              icon: Icon(Icons.keyboard_arrow_down, color: borderColor),
              style: AppStyling.normalTextSize14
                  .copyWith(color: colors(context).labelTextColor),
              dropdownColor: colors(context).colorWhite,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                  widget.onChanged(newValue);
                }
              },
              items: widget.items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
