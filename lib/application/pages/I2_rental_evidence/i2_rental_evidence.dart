import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/pages/I2_rental_evidence/cubit/i2_rental_evidence_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

/// Main page widget for displaying rental evidence.
class I2RentalEvidence extends BasePage {
  const I2RentalEvidence({super.key});

  @override
  _I2RentalEvidenceState createState() => _I2RentalEvidenceState();
}

/// State implementation for I2RentalEvidence page.
class _I2RentalEvidenceState extends BasePageState<I2RentalEvidence> {
  // Cubit instance for managing the page state
  final _cubit = injection<I2RentalEvidenceCubit>();

  // List to hold the uploaded images (can be File or String type)
  List<dynamic> uploadedImages = [];

  /// Callback function when an image is picked.
  /// Adds the picked [file] to the uploadedImages list.
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Deletes the image at a given [index] from the uploadedImages list.
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  /// Builds the view for the rental evidence page.
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      // Customized AppBar with title and customized styling.
      appBar: CustomAppBar(
        title: AppString.rentalEvidence.localize(context)!,
      ),
      // Main body wrapped in a SingleChildScrollView to allow vertical scrolling.
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb navigation for a clear page hierarchy.
            Breadcrumb(items: [
              BreadcrumbItem(label: AppString.massRating.localize(context)!),
              BreadcrumbItem(label: AppString.rentalEvidence.localize(context)!),
            ]),
            // LayoutBuilder to determine available width and adjust field sizes accordingly.
            LayoutBuilder(builder: (context, constraints) {
              double fieldWidth = constraints.maxWidth * 0.47;

              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap widget for grouping input fields with spacing.
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        // Dropdown field for selecting a building.
                        CustomDropdownField(
                          label: AppString.selectBuilding.localize(context)!,
                          items: [
                            AppString.selectBuilding.localize(context)!,
                            AppString.building1.localize(context)!,
                            AppString.building2.localize(context)!
                          ],
                          initialValue: AppString.selectBuilding.localize(context)!,
                          onChanged: (value) {},
                          width: fieldWidth,
                        ),
                        // Dropdown field for selecting a property category.
                        CustomDropdownField(
                          label: AppString.propertyCategory.localize(context)!,
                          items: [
                            AppString.selectPropertyCategory.localize(context)!,
                            AppString.category1.localize(context)!,
                            AppString.category2.localize(context)!
                          ],
                          initialValue: AppString.selectPropertyCategory.localize(context)!,
                          onChanged: (value) {},
                          width: fieldWidth,
                        ),
                        // Dropdown field for selecting a property subcategory.
                        CustomDropdownField(
                          label: AppString.propertySubcategory.localize(context)!,
                          items: [
                            AppString.selectPropertySubcategory.localize(context)!,
                            AppString.subcategory1.localize(context)!,
                            AppString.subcategory2.localize(context)!
                          ],
                          initialValue: AppString.selectPropertySubcategory.localize(context)!,
                          onChanged: (value) {},
                          width: fieldWidth,
                        ),
                        // Dropdown field for selecting a property type.
                        CustomDropdownField(
                          label: AppString.propertyType.localize(context)!,
                          items: [
                            AppString.selectPropertyType.localize(context)!,
                            AppString.type1.localize(context)!,
                            AppString.type2.localize(context)!
                          ],
                          initialValue: AppString.selectPropertyType.localize(context)!,
                          onChanged: (value) {},
                          width: fieldWidth,
                        ),
                        // Text field for inputting assessment number.
                        LabeledTextField(
                          label: AppString.assesmentNo.localize(context)!,
                          placeholder: AppString.assesmentNo.localize(context)!,
                          width: fieldWidth,
                        ),
                        // Text field for inputting owner name.
                        LabeledTextField(
                          label: AppString.ownerName.localize(context)!,
                          placeholder: AppString.ownerName.localize(context)!,
                          width: fieldWidth,
                        ),
                        // Dropdown field for selecting property type.
                        CustomDropdownField(
                          label: AppString.propertyType.localize(context)!,
                          items: [
                            AppString.propertyType.localize(context)!,
                            AppString.typeA.localize(context)!,
                            AppString.typeB.localize(context)!
                          ],
                          initialValue: AppString.propertyType.localize(context)!,
                          onChanged: (value) {},
                          width: fieldWidth,
                        ),
                        // Text field for inputting occupier name.
                        LabeledTextField(
                          label: AppString.occupierName.localize(context)!,
                          placeholder: AppString.occupierName.localize(context)!,
                          width: fieldWidth,
                        ),
                        // Text field for describing the property.
                        LabeledTextField(
                          label: AppString.descriptionOfProperty.localize(context)!,
                          placeholder: AppString.descriptionOfProperty.localize(context)!,
                          width: fieldWidth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Labeling section for the image capturing area.
                    Text(
                      AppString.imageCapturing.localize(context)!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    // Wrap widget for displaying uploaded images and an upload button.
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        // Generate a widget for each uploaded image.
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
                        // Upload button for picking new images.
                        ImageUpload(
                          isUploadButton: true,
                          onImagePicked: _onImagePicked,
                          onDelete: () {},
                          size: 128,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Row widget containing the action buttons.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Save and Cancel buttons grouped together.
                        Row(
                          children: [
                            CustomButton(
                              text: AppString.save.localize(context)!,
                              onPressed: () {},
                              backgroundColor: colors(context).colorPrimary5!,
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: AppString.cancel,
                              onPressed: () {},
                              backgroundColor: colors(context).colorGrey1!,
                            ),
                          ],
                        ),
                        // Button for sending data.
                        CustomButton(
                          text: AppString.sendData.localize(context)!,
                          onPressed: () {},
                          backgroundColor: colors(context).colorPrimary5!,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Returns the cubit instance associated with this page.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
