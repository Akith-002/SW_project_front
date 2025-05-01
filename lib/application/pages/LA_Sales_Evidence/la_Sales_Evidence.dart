import 'dart:io';

import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

/// Sales Evidence form screen for Land Acquisition module
/// Allows users to input and manage land sales evidence data
class LaSalesEvidence extends BasePage {
  const LaSalesEvidence({super.key});

  @override
  State<LaSalesEvidence> createState() => _LaSalesEvidenceState();
}

class _LaSalesEvidenceState extends BasePageState<LaSalesEvidence> {
  final _cubit = injection<LaSalesEvidenceCubit>();

  // Stores both File objects (newly picked images) and String paths (previously saved images)
  List<dynamic> uploadedImages = [];

  /// Adds a newly picked image to the collection
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Removes an image from the collection by index
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: AppString.salesEvidencesForm.localize(context)!),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the width for form fields based on available screen width
          double fieldWidth = constraints.maxWidth * 0.47;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Navigation breadcrumb
                Breadcrumb(
                  items: [
                    BreadcrumbItem(
                        label: AppString.landAcquisition.localize(context)!),
                    BreadcrumbItem(
                        label: AppString.masterFile.localize(context)!),
                    BreadcrumbItem(
                        label: AppString.salesEvidences.localize(context)!),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form fields section
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.start,
                        children: [
                          // Property identification fields
                          LabeledTextField(
                            label: AppString.assetNumber.localize(context)!,
                            placeholder:
                                AppString.assetNumber.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.masterFilerefno.localize(context)!,
                            placeholder:
                                AppString.masterFilerefno.localize(context)!,
                            width: fieldWidth,
                          ),

                          // Location information fields
                          LabeledTextField(
                            label: AppString.roadName.localize(context)!,
                            placeholder: AppString.owner.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.village.localize(context)!,
                            placeholder: AppString.occupier.localize(context)!,
                            width: fieldWidth,
                          ),

                          // Transaction information fields
                          LabeledTextField(
                            label: AppString.vendor.localize(context)!,
                            placeholder: AppString.situation.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.deedNumber.localize(context)!,
                            placeholder: AppString.floorRate.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label:
                                AppString.deedAttestedNumber.localize(context)!,
                            placeholder:
                                AppString.deedAttestedNumber.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.notaryName.localize(context)!,
                            placeholder:
                                AppString.notaryName.localize(context)!,
                            width: fieldWidth,
                          ),

                          // Land specification fields
                          LabeledTextField(
                            label: AppString.lotNumber.localize(context)!,
                            placeholder:
                                AppString.noofLotNumbergiven.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.planNumber.localize(context)!,
                            placeholder:
                                AppString.planNumber.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.planDate.localize(context)!,
                            placeholder: AppString.planDate.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.extent.localize(context)!,
                            placeholder: AppString.extent.localize(context)!,
                            width: fieldWidth,
                          ),

                          // Financial and valuation fields
                          LabeledTextField(
                            label: AppString.consideration.localize(context)!,
                            placeholder:
                                AppString.consideration.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.remarks.localize(context)!,
                            placeholder: AppString.remarks.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.rate.localize(context)!,
                            placeholder: AppString.rate.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.rateType.localize(context)!,
                            placeholder: AppString.rateType.localize(context)!,
                            width: fieldWidth,
                          ),

                          // Geolocation fields
                          LabeledTextField(
                            label:
                                AppString.locationLongitude.localize(context)!,
                            placeholder:
                                AppString.locationLongitude.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label:
                                AppString.locationLatitude.localize(context)!,
                            placeholder:
                                AppString.locationLatitude.localize(context)!,
                            width: fieldWidth,
                          ),

                          // Additional reference and description fields
                          LabeledTextField(
                            label: AppString.landRegistryReferences
                                .localize(context)!,
                            placeholder: AppString.landRegistryReferences
                                .localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.situation.localize(context)!,
                            placeholder: AppString.situation.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label:
                                AppString.descriptionOfLand.localize(context)!,
                            placeholder:
                                AppString.descriptionOfLand.localize(context)!,
                            width: fieldWidth,
                          ),
                        ],
                      ),

                      // Image upload section
                      const SizedBox(height: 24),
                      Text(
                        AppString.imageCapturing.localize(context)!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          // Display all previously uploaded images
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
                          // Upload button for adding new images
                          ImageUpload(
                            isUploadButton: true,
                            onImagePicked: _onImagePicked,
                            onDelete: () {}, // Not used for upload button
                            size: 128,
                          ),
                        ],
                      ),

                      // Divider
                      Container(
                        height: 1,
                        margin: const EdgeInsets.all(16),
                        width: double.infinity,
                        color: Colors.grey,
                      ),

                      // Action buttons section
                      Row(
                        children: [
                          CustomButton(
                            text: AppString.cancel.localize(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorGrey1!,
                          ),
                          const Spacer(),
                          CustomButton(
                            text: AppString.save.localize(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorPrimary1!,
                          ),
                          const SizedBox(width: 40),
                          CustomButton(
                            text: AppString.sendData.localize(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorPrimary5!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
