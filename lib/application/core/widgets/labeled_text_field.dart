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
  });

  @override
  _LabeledTextFieldState createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late TextEditingController _controller;
  bool _isTyping = false;

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
              color: colors(context).dropDownBorderColor!,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  // Temporarily remove maxLength
                  // maxLength: 255,
                  // Explicitly enable and make not read-only
                  enabled: true,
                  readOnly: false,
                  // Temporarily remove inputFormatters
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                  // ],
                  // Temporarily set hardcoded style
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  // style: AppStyling.normalTextSize14
                  //     .copyWith(color: colors(context).labelTextColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    counterText: "",
                    hintText: _isTyping ? "" : widget.placeholder,
                    hintStyle: TextStyle(
                      color: colors(context).labelTextColor,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isTyping = value.isNotEmpty;
                    });
                  },
                  validator: widget.validator,
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
