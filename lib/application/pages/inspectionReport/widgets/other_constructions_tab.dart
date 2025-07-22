import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/validators/inspection_validator.dart';

class OtherConstructionsTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController otherInfoController;
  final TextEditingController otherConstructionDetailsController;
  final TextEditingController assetDetailsController;
  final TextEditingController businessDetailsController;
  final TextEditingController remarksController;
  final VoidCallback onCancel;
  final VoidCallback? onSave;
  final String saveButtonText;

  const OtherConstructionsTab({
    super.key,
    required this.formKey,
    required this.otherInfoController,
    required this.otherConstructionDetailsController,
    required this.assetDetailsController,
    required this.businessDetailsController,
    required this.remarksController,
    required this.onCancel,
    required this.onSave,
    required this.saveButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              label: "Other Info",
              placeholder: "Enter Other Information",
              controller: otherInfoController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Other Info"),
            ),
            LabeledTextField(
              label: "Other Construction Details",
              placeholder: "Enter Other Construction Details",
              controller: otherConstructionDetailsController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 300, "Other Construction Details"),
            ),
            LabeledTextField(
              label: "Asset Details",
              placeholder: "Enter Asset Details",
              controller: assetDetailsController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Asset Details"),
            ),
            LabeledTextField(
              label: "Business Details",
              placeholder: "Enter Business Details",
              controller: businessDetailsController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Business Details"),
            ),
            LabeledTextField(
              label: "Remarks",
              placeholder: "Enter Remarks",
              controller: remarksController,
              validator: (value) =>
                  InspectionValidator.optionalAlphaNum(value, 300, "Remarks"),
            ),
            const SizedBox(height: 24),
            Container(
              height: 1,
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.grey,
            ),
            Row(
              children: [
                CustomButton(
                  text: AppString.cancel.localize(context) ?? 'Cancel',
                  onPressed: onCancel,
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const Spacer(),
                CustomButton(
                  text: saveButtonText,
                  onPressed: onSave,
                  backgroundColor: onSave != null
                      ? colors(context).colorPrimary1!
                      : colors(context).colorGrey1!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
