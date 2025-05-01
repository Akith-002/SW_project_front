import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/cubit/rental_evidence_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

/// RentalEvidenceView is the main view for displaying the rental evidence form.
class RentalEvidenceView extends BasePage {
  const RentalEvidenceView({super.key});

  @override
  _RentalEvidenceViewState createState() => _RentalEvidenceViewState();
}

/// State for RentalEvidenceView that handles user input and image uploads.
class _RentalEvidenceViewState extends BasePageState<RentalEvidenceView> {
  // Instantiate the cubit using dependency injection.
  final _cubit = injection<RentalEvidenceCubit>();

  // List to store uploaded images.
  List<dynamic> uploadedImages = [];

  /// Callback when an image is picked.
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Delete an image from the uploadedImages list by index.
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      // Custom app bar with a localized title.
      appBar: CustomAppBar(
        title: AppString.rentalEvidence.localize(context) ?? '',
      ),
      // Allows the entire view to be scrollable.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb navigation.
            Breadcrumb(items: [
              BreadcrumbItem(
                  label: AppString.landAcquisition.localize(context) ?? ''),
              BreadcrumbItem(label: AppString.masterFile.localize(context)!),
              BreadcrumbItem(
                  label: AppString.rentalEvidenceForm.localize(context) ?? ''),
            ]),
            // LayoutBuilder used to determine the width constraints for form fields.
            LayoutBuilder(
              builder: (context, constraints) {
                double fieldWidth = constraints.maxWidth * 0.47;
                double fullWidth = constraints.maxWidth * 0.96;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap widget to arrange text fields responsively.
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.start,
                        children: [
                          // Each LabeledTextField represents a form field with a label and placeholder.
                          LabeledTextField(
                            placeholder: AppString.assesmentNoPlaceholder
                                .localize(context)!,
                            label:
                                AppString.assesmentNo.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder: AppString.masterFileRefNoPlaceholder
                                .localize(context)!,
                            label:
                                AppString.masterFileRefNo.localize(context) ??
                                    '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.owner.localize(context) ?? '',
                            label: AppString.owner.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.occupier.localize(context) ?? '',
                            label: AppString.occupier.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.description.localize(context) ?? '',
                            label:
                                AppString.description.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder: AppString.floorRatePlaceholder
                                .localize(context)!,
                            label: AppString.floorRate.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.ratePerSqft.localize(context) ?? '',
                            label:
                                AppString.ratePerSqft.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.ratePerMonth.localize(context) ?? '',
                            label:
                                AppString.ratePerMonth.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder: AppString.locationLongitudePlaceholder
                                .localize(context)!,
                            label:
                                AppString.locationLatitude.localize(context) ??
                                    '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder: AppString.locationLatitudePlaceholder
                                .localize(context)!,
                            label:
                                AppString.locationLatitude.localize(context) ??
                                    '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.headOfTerms.localize(context) ?? '',
                            label:
                                AppString.headOfTerms.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            placeholder:
                                AppString.situation.localize(context) ?? '',
                            label: AppString.situation.localize(context) ?? '',
                            width: fieldWidth,
                          ),
                          // Full width text field for remarks.
                          LabeledTextField(
                            placeholder:
                                AppString.remarks.localize(context) ?? '',
                            label: AppString.remarks.localize(context) ?? '',
                            width: fullWidth,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Section title for image uploads.
                      Text(
                        AppString.uploadImgs.localize(context) ?? '',
                        style: AppStyling.mediumTextSize14,
                      ),
                      const SizedBox(height: 16),
                      // Image upload section using Wrap for responsive image display.
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.start,
                        children: [
                          // Display each uploaded image with a delete button.
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
                          // Button to upload a new image.
                          ImageUpload(
                            isUploadButton: true,
                            onImagePicked: _onImagePicked,
                            onDelete: () {},
                            size: 128,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Row for Cancel, Save, and Send Data buttons.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Cancel button.
                          CustomButton(
                            text: AppString.cancel.localize(context) ?? '',
                            onPressed: () {},
                            backgroundColor: colors(context).colorGrey1 ??
                                LightColorList.lightGrey50,
                          ),
                          Row(
                            children: [
                              // Save button.
                              CustomButton(
                                text: AppString.save.localize(context) ?? '',
                                onPressed: () {},
                                backgroundColor:
                                    colors(context).colorPrimary5 ??
                                        LightColorList.lightPrimary700,
                              ),
                              const SizedBox(width: 40),
                              // Send data button.
                              CustomButton(
                                text:
                                    AppString.sendData.localize(context) ?? '',
                                onPressed: () {},
                                backgroundColor:
                                    colors(context).colorPrimary1 ??
                                        LightColorList.lightPrimary500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Returns the cubit instance for managing state.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}