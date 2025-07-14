import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'dart:convert';

/// A widget that lets the user draw a signature and submit or clear it.
class SignatureBox extends StatefulWidget {
  final String title;
  final Function(Uint8List?)? onSignatureChanged;
  final String? errorMessage; 

  const SignatureBox({
    super.key,
    required this.title,
    this.onSignatureChanged,
    this.errorMessage, // ✅ Include in constructor
  });

  @override
  State<SignatureBox> createState() => _SignatureBoxState();
}

class _SignatureBoxState extends State<SignatureBox> {
  late final SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    _controller.addListener(_handleSignatureChange);
  }

  Future<void> _handleSignatureChange() async {
    if (!mounted) return;
    if (_controller.isNotEmpty && widget.onSignatureChanged != null) {
      try {
        final signature = await _controller.toPngBytes();
        widget.onSignatureChanged!(signature);
      } catch (e) {
        debugPrint('Error converting signature to PNG: $e');
        widget.onSignatureChanged!(null);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (_controller.isEmpty) {
      debugPrint('No signature to submit');
      return;
    }

    try {
      final signature = await _controller.toPngBytes();
      if (signature != null) {
        final base64String = base64Encode(signature);
        debugPrint('Submitted Signature as Base64: $base64String');
      }
    } catch (e) {
      debugPrint('Error converting signature to base64: $e');
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onSignatureChanged?.call(null);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleSignatureChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: AppStyling.normalTextSize14.copyWith(
            color: colors(context).colorGrey6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 496,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: colors(context).colorPrimary5 ?? LightColorList.lightPrimary700,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Signature(
              controller: _controller,
              backgroundColor: colors(context).colorWhite ?? LightColorList.lightColorWhite,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 496,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: 'Clear',
                onPressed: _handleClear,
                backgroundColor: colors(context).colorGrey1 ?? LightColorList.lightGrey50,
              ),
              const SizedBox(width: 8),
              CustomButton(
                text: 'Submit',
                onPressed: _handleSubmit,
                backgroundColor: colors(context).colorPrimary5 ?? LightColorList.lightPrimary700,
              ),
            ],
          ),
        ),
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
