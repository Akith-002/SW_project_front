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
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

class LaBuildingRates extends BasePage {
  const LaBuildingRates({super.key});

  @override
  State<LaBuildingRates> createState() => _LaBuildingRatesState();
}

class _LaBuildingRatesState extends BasePageState<LaBuildingRates> {
  final _cubit = injection<LaBuildingRatesCubit>();
  List<dynamic> uploadedImages = [];

  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: AppString.buildingRatesForm.localize(context)!),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double fieldWidth = constraints.maxWidth * 0.47;

          return SingleChildScrollView(
            child: Column(
              children: [
                Breadcrumb(
                  items: [
                    BreadcrumbItem(
                        label: AppString.landAcquisition.localize(context)!),
                    BreadcrumbItem(
                        label: AppString.masterFile.localize(context)!),
                    BreadcrumbItem(
                        label: AppString.buildingRates.localize(context)!),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.start,
                        children: [
                          LabeledTextField(
                            label:
                                AppString.assessmentNumber.localize(context)!,
                            placeholder:
                                AppString.assessmentNumber.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.owner.localize(context)!,
                            placeholder:
                                AppString.nameOfTheOwner.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.constructedBy.localize(context)!,
                            placeholder:
                                AppString.constructedBy.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label:
                                AppString.yearofConstruction.localize(context)!,
                            placeholder:
                                AppString.yearofConstruction.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.descriptionofProperty
                                .localize(context)!,
                            placeholder: AppString.propertyDescription
                                .localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.floorAreaSQFT.localize(context)!,
                            placeholder:
                                AppString.floorAreaSQFT.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.ratePerSQFT.localize(context)!,
                            placeholder:
                                AppString.ratePerSQFT.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.cost.localize(context)!,
                            placeholder: AppString.cost.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label: AppString.remarks.localize(context)!,
                            placeholder: AppString.remarks.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label:
                                AppString.locationLatitude.localize(context)!,
                            placeholder:
                                AppString.locationLatitude.localize(context)!,
                            width: fieldWidth,
                          ),
                          LabeledTextField(
                            label:
                                AppString.locationLongitude.localize(context)!,
                            placeholder:
                                AppString.locationLongitude.localize(context)!,
                            width: fieldWidth,
                          ),
                        ],
                      ),
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
                      Container(
                        height: 1,
                        margin: EdgeInsets.all(16),
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          CustomButton(
                            text: AppString.cancel.localize(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorGrey1!,
                          ),
                          Spacer(),
                          CustomButton(
                            text: AppString.save.localize(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorPrimary1!,
                          ),
                          SizedBox(width: 40),
                          CustomButton(
                            text: AppString.sendData.localize(context)!,
                            onPressed: () {},
                            backgroundColor: colors(context).colorPrimary5!,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
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
