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

class PastValuationView extends BasePage {
  const PastValuationView({super.key});

  @override
  _PastValuationViewState createState() => _PastValuationViewState();
}

class _PastValuationViewState extends BasePageState<PastValuationView> {
  final _cubit = injection<PastValuationCubit>();
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
        double formWidth = constraints.maxWidth - 32; // Responsive width
        return Scaffold(
          appBar: CustomAppBar(
            title: "Past Valuation Form #1234",
          ),
          body: SingleChildScrollView(
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
                    label: AppString.masterFilerefno.localize(context)!,
                    placeholder: "Metro/2/LM/123",
                  ),
                  LabeledTextField(
                    label: AppString.fileNoGnDivision.localize(context)!,
                    placeholder: AppString.fileNoGnDivision.localize(context)!,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.situation.localize(context)!,
                    placeholder: AppString.situation.localize(context)!,
                  ),
                  LabeledTextField(
                    label: AppString.dateOfValuation.localize(context)!,
                    placeholder: "AT Lot 01",
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.purposeOfValuation.localize(context)!,
                    placeholder: AppString.purposeOfValuation.localize(context)!,
                  ),
                  LabeledTextField(
                    label: AppString.planOfParticulars.localize(context)!,
                    placeholder: AppString.planOfParticulars.localize(context)!,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.extent.localize(context)!,
                    placeholder: AppString.extent.localize(context)!,
                  ),
                  LabeledTextField(
                    label: AppString.rate.localize(context)!,
                    placeholder: AppString.rate.localize(context)!,
                  ),
                ]),
                _buildRow([
                  CustomDropdownField(
                    label: AppString.rateType.localize(context)!,
                    items: ["Market Value", "Government Valuation"],
                    initialValue: "Market Value",
                    onChanged: (value) {}, width: 484,
                  ),
                  LabeledTextField(
                    label: AppString.remarks.localize(context)!,
                    placeholder: AppString.remarks.localize(context)!,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.locationLongitude.localize(context)!,
                    placeholder: "6.123456789",
                  ),
                  LabeledTextField(
                    label: AppString.locationLatitude.localize(context)!,
                    placeholder: "6.123456789",
                  ),
                ]),

                const SizedBox(height: 24),

                // ✅ Image Upload Section
                Text(
                  AppString.uploadImgs.localize(context)!,
                  style: AppStyling.mediumTextSize14,
                ),
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
                      text: AppString.cancel.localize(context)!,
                      onPressed: () {},
                      backgroundColor: colors(context).colorGrey1!,
                    ),
                    Row(
                      children: [
                        CustomButton(
                          text: AppString.save.localize(context)!,
                          onPressed: () {},
                          backgroundColor: colors(context).colorPrimary5!,
                        ),
                        const SizedBox(width: 40),
                        CustomButton(
                          text: AppString.sendData.localize(context)!,
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
