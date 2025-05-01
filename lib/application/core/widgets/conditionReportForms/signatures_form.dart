import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/signature_box.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'dart:typed_data';

class SignaturesForm extends StatelessWidget {
  const SignaturesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double formWidth = constraints.maxWidth - 32; // Adjust for sidebar changes
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Signature Fields
              SignatureBox(
                title: AppString.acquiringOfficer.localize(context)!,
                onSignatureChanged: (Uint8List? signature) {},
              ),
              const SizedBox(height: 16),

              SignatureBox(
                title: AppString.gramaSeveka.localize(context)!,
                onSignatureChanged: (Uint8List? signature) {},
              ),
              const SizedBox(height: 16),

              SignatureBox(
                title: AppString.chiefValuersRepresentative.localize(context)!,
                onSignatureChanged: (Uint8List? signature) {},
              ),

              const SizedBox(height: 24),

              // Divider Section (Make sure it does not clip the buttons)
              Container(
                width: formWidth,
                height: 1.5, // Reduced height
                color: colors(context).colorGrey5,
              ),

              const SizedBox(height: 16), // Extra space before buttons

              // Save & Cancel Buttons (Ensure correct layout)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Ensure space at the bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: AppString.cancel.localize(context)!,
                      backgroundColor: colors(context).colorGrey1!,
                      onPressed: () {},
                      width: 120,
                      height: 48,
                    ),
                    CustomButton(
                      text: AppString.save.localize(context)!,
                      backgroundColor: colors(context).colorPrimary5!,
                      onPressed: () {},
                      width: 120,
                      height: 48,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
