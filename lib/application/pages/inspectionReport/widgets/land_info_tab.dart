import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/validators/inspection_validator.dart';

class LandInfoTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController masterFileRefController;
  final TextEditingController inspectionDateController;
  final TextEditingController dsDivisionController;
  final TextEditingController districtController;
  final TextEditingController provinceController;
  final VoidCallback onCancel;
  final VoidCallback? onSave;
  final String saveButtonText;

  const LandInfoTab({
    super.key,
    required this.formKey,
    required this.masterFileRefController,
    required this.inspectionDateController,
    required this.dsDivisionController,
    required this.districtController,
    required this.provinceController,
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
              label: "Master File Ref No",
              placeholder: "Enter Master File Reference Number",
              controller: masterFileRefController,
              validator: (value) => InspectionValidator.required(
                  value, "Master File Reference Number"),
            ),
            LabeledTextField(
              label: "Inspection Date",
              placeholder: "Enter Inspection Date",
              controller: inspectionDateController,
              validator: (value) =>
                  InspectionValidator.required(value, "Inspection Date"),
            ),
            LabeledTextField(
              label: "DS Division",
              placeholder: "Enter DS Division",
              controller: dsDivisionController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 50, "DS Division"),
            ),
            LabeledTextField(
              label: "District",
              placeholder: "Enter District",
              controller: districtController,
              validator: (value) =>
                  InspectionValidator.required(value, "District"),
            ),
            LabeledTextField(
              label: "Province",
              placeholder: "Enter Province",
              controller: provinceController,
              validator: (value) =>
                  InspectionValidator.required(value, "Province"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Village/GN Division",
                    style: TextStyle(
                      color: colors(context).labelTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: "GN Division and Village",
                    onPressed: () {},
                    width: 380,
                    height: 48,
                    backgroundColor: colors(context).colorPrimary1!,
                  ),
                ],
              ),
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
