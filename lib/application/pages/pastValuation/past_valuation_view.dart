import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/application/pages/pastValuation/cubit/past_valuation_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/validators/past_valuation_validator.dart';

class PastValuationView extends BasePage {
  const PastValuationView({super.key});

  @override
  _PastValuationViewState createState() => _PastValuationViewState();
}

class _PastValuationViewState extends BasePageState<PastValuationView> {
  final _cubit = injection<PastValuationCubit>();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> uploadedImages = [];

  void _onImagePicked(File? file) {
    if (file != null) {
      setState(() {
        uploadedImages.add(file);
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: CustomAppBar(title: "Past Valuation Form #1234"),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumb(items: [
                    BreadcrumbItem(label: "Land Acquisition"),
                    BreadcrumbItem(label: "Master File - #56249"),
                    BreadcrumbItem(label: "Past Valuation Form #1234"),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.masterFilerefno.l10n(context)!,
                      placeholder: "Metro/2/LM/123",
                    ),
                    LabeledTextField(
                      label: AppString.fileNoGnDivision.l10n(context)!,
                      placeholder: AppString.fileNoGnDivision.l10n(context)!,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(value, 255, "Assessment No"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.situation.l10n(context)!,
                      placeholder: AppString.situation.l10n(context)!,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(value, 255, "Situation"),
                    ),
                    LabeledTextField(
                      label: AppString.dateOfValuation.l10n(context)!,
                      placeholder: "AT Lot 01",
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.purposeOfValuation.l10n(context)!,
                      placeholder: AppString.purposeOfValuation.l10n(context)!,
                      validator: (value) => PastValuationValidator.optionalAlphaNum(value, 255, "Purpose of Valuation"),
                    ),
                    LabeledTextField(
                      label: AppString.planOfParticulars.l10n(context)!,
                      placeholder: AppString.planOfParticulars.l10n(context)!,
                      validator: (value) => PastValuationValidator.optionalAlphaNum(value, 255, "Plan Particulars"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.extent.l10n(context)!,
                      placeholder: AppString.extent.l10n(context)!,
                      validator: (value) => PastValuationValidator.optionalNumeric(value, 255, "Extent"),
                    ),
                    LabeledTextField(
                      label: AppString.rate.l10n(context)!,
                      placeholder: AppString.rate.l10n(context)!,
                      validator: (value) => PastValuationValidator.optionalNumeric(value, 255, "Rate per unit"),
                    ),
                  ]),
                  _buildRow([
                    CustomDropdownField(
                      label: AppString.rateType.l10n(context)!,
                      items: ["Market Value", "Government Valuation"],
                      initialValue: "Market Value",
                      onChanged: (value) {},
                      width: 484,
                    ),
                    LabeledTextField(
                      label: AppString.remarks.l10n(context)!,
                      placeholder: AppString.remarks.l10n(context)!,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(value, 255, "Remarks"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.locationLongitude.l10n(context)!,
                      placeholder: "6.123456789",
                      validator: (value) =>
                          PastValuationValidator.optionalNumeric(value, 255, "Longitude"),
                    ),
                    LabeledTextField(
                      label: AppString.locationLatitude.l10n(context)!,
                      placeholder: "6.123456789",
                      validator: (value) =>
                          PastValuationValidator.optionalNumeric(value, 255, "Latitude"),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Text(AppString.uploadImgs.l10n(context)!, style: AppStyling.mediumTextSize14),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    children: [
                      ...List.generate(
                        uploadedImages.length,
                        (index) {
                          final image = uploadedImages[index];
                          return ImageUpload(
                            imageFile: image is File ? image : null,
                            imagePath: image is String ? image : null,
                            onDelete: () => _deleteImage(index),
                            size: 128,
                          );
                        },
                      ),
                      ImageUpload(
                        isUploadButton: true,
                        onImagePicked: _onImagePicked,
                        onDelete: () {},
                        size: 128,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: AppString.cancel.l10n(context)!,
                        onPressed: () {},
                        backgroundColor: colors(context).colorGrey1!,
                      ),
                      Row(
                        children: [
                          CustomButton(
                            text: AppString.save.l10n(context)!,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Form valid. Saving..."), backgroundColor: Colors.green),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please fix the errors"), backgroundColor: Colors.red),
                                );
                              }
                            },
                            backgroundColor: colors(context).colorPrimary5!,
                          ),
                          const SizedBox(width: 40),
                          CustomButton(
                            text: AppString.sendData.l10n(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorPrimary1!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children.map((widget) => Expanded(child: widget)).toList(),
      ),
    );
  }
}
