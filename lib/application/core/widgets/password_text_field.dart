import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class PasswordTextField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final FormFieldValidator<String>? validator;
  final Function(bool)? onErrorChange;

  const PasswordTextField({
    super.key,
    this.label,
    required this.placeholder,
    this.controller,
    this.width,
    this.height,
    this.validator,
    this.onErrorChange,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late TextEditingController _controller;
  bool _obscure = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? 484;
    final height = widget.height ?? 48;

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
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1.5,
              color: _errorMessage != null
                  ? Colors.red
                  : colors(context).dropDownBorderColor!,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  obscureText: _obscure,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintText: _controller.text.isEmpty
                        ? (_errorMessage ?? widget.placeholder)
                        : null,
                    hintStyle: TextStyle(
                      color: _errorMessage != null
                          ? Colors.red
                          : colors(context).labelTextColor,
                      fontSize: 14,
                      height: 1.0,
                    ),
                    errorText: null,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  onChanged: (_) {
                    setState(() {
                      _errorMessage = null;
                    });
                    widget.onErrorChange?.call(false);
                  },
                  validator: (value) {
                    final result = widget.validator?.call(value);
                    setState(() => _errorMessage = result);
                    widget.onErrorChange?.call(result != null);
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: colors(context).textGrey,
                  size: 24,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
