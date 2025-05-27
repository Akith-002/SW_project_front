import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class LabeledNumericField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function(bool)? onErrorChange;
  final bool allowDecimals;
  final bool isRequired;
  final double? width;
  final double? height;

  const LabeledNumericField({
    super.key,
    this.label,
    required this.placeholder,
    this.controller,
    this.validator,
    this.onErrorChange,
    this.allowDecimals = false,
    this.isRequired = true,
    this.width,
    this.height,
  });

  @override
  State<LabeledNumericField> createState() => _LabeledNumericFieldState();
}

class _LabeledNumericFieldState extends State<LabeledNumericField> {
  late TextEditingController _controller;
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
    final double fieldWidth = widget.width ?? 484;
    final double fieldHeight = widget.height ?? 48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${widget.label!}${widget.isRequired ? ' *' : ''}',
              style: AppStyling.mediumTextSize14.copyWith(
                color: colors(context).labelTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
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
                  keyboardType: widget.allowDecimals
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  inputFormatters: [
                    if (widget.allowDecimals)
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    else
                      FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    counterText: "",
                    hintText: _controller.text.isEmpty
                        ? (_errorMessage ?? widget.placeholder)
                        : null,
                    errorText: null,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    hintStyle: TextStyle(
                      color: _errorMessage != null
                          ? Colors.red
                          : colors(context).labelTextColor,
                      fontSize: 14,
                      height: 1.0,
                    ),
                  ),
                  onTap: _clearError,
                  onChanged: (value) {
                    setState(() {
                      _errorMessage = null;
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
                    return null;
                  },
                ),
              ),
              Icon(
                Icons.tag,
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
