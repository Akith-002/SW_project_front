import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/inspection_validator.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:http/http.dart' as http;

class InspectionReportView extends BasePage {
  final MasterDataResponse masterData;
  const InspectionReportView({super.key, required this.masterData});

  @override
  State<InspectionReportView> createState() => _InspectionReportViewState();
}

class _InspectionReportViewState extends BasePageState<InspectionReportView>
    with SingleTickerProviderStateMixin {
  final _cubit = injection<InspectionReportCubit>();
  late TabController _tabController;
  final List<String> tabTitles = [
    "Land Info",
    "Building Info",
    "Other Constructions"
  ];
  List<dynamic> uploadedImages = [];

  // Form keys for validation
  final _landInfoFormKey = GlobalKey<FormState>();
  final _buildingInfoFormKey = GlobalKey<FormState>();
  final _otherConstructionsFormKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _masterFileRefController = TextEditingController();
  final _inspectionDateController = TextEditingController();
  final _dsDivisionController = TextEditingController();
  final _districtController = TextEditingController();
  final _provinceController = TextEditingController();

  // State for Building Info Tab
  String? _selectedBuildingName;
  final List<String> _buildingNames = [
    'B1',
    'B2',
    'B3'
  ]; // Example building names

  // Add controllers for building info form
  final _buildingIdController = TextEditingController();
  final _buildingNameController = TextEditingController();
  final _buildingDetailsController = TextEditingController();
  final _noOfFloorsGPlusController = TextEditingController();
  final _noOfFloorsGMinusController = TextEditingController();
  final _ageController = TextEditingController();
  final _expectedLifePeriodController = TextEditingController();
  final _parkingSpaceController = TextEditingController();
  final _designController = TextEditingController();
  final _conveniencesController = TextEditingController();
  final _structureController = TextEditingController();
  final _buildingConditionsController = TextEditingController();

  // Add controllers for other constructions form
  final _otherInfoController = TextEditingController();
  final _otherConstructionDetailsController = TextEditingController();
  final _assetDetailsController = TextEditingController();
  final _businessDetailsController = TextEditingController();
  final _remarksController = TextEditingController();

  // Data passed from navigation
  String? _masterFileNo;
  String? _planType;
  String? _planNo;
  String? _authorityRefNo;
  String? _lotId;
  bool _dataExtracted = false;

  @override
  void initState() {
    _tabController = TabController(length: tabTitles.length, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataExtracted) {
      _extractNavigationData();
      _dataExtracted = true;
    }
  }

  void _extractNavigationData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;

    _masterFileNo = queryParams['masterFileNo'];
    _planType = queryParams['planType'];
    _planNo = queryParams['planNo'];
    _authorityRefNo = queryParams['authorityRefNo'];
    _lotId = queryParams['lotId'];

    debugPrint(
        "InspectionReport: Extracted data - Master File No: $_masterFileNo, Lot ID: $_lotId");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _masterFileRefController.dispose();
    _inspectionDateController.dispose();
    _dsDivisionController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    _buildingIdController.dispose();
    _buildingNameController.dispose();
    _buildingDetailsController.dispose();
    _noOfFloorsGPlusController.dispose();
    _noOfFloorsGMinusController.dispose();
    _ageController.dispose();
    _expectedLifePeriodController.dispose();
    _parkingSpaceController.dispose();
    _designController.dispose();
    _conveniencesController.dispose();
    _structureController.dispose();
    _buildingConditionsController.dispose();
    _otherInfoController.dispose();
    _otherConstructionDetailsController.dispose();
    _assetDetailsController.dispose();
    _businessDetailsController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

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

  // Add this function to handle validation, submission, and image upload
  void _validateAndSubmit() async {
    if (_buildingInfoFormKey.currentState?.validate() ?? false) {
      final reportId = await _submitFormData();
      if (reportId != null) {
        await _uploadImages(reportId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Inspection report submitted successfully!'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit inspection report.'),
              backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fix the validation errors in the form'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<String?> _submitFormData() async {
    try {
      final uri = Uri.parse('http://10.0.2.2:5221/api/InspectionReport');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: _buildFormJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final reportId =
            RegExp(r'"reportId"\s*:\s*(\d+)').firstMatch(data)?.group(1);
        print('DEBUG: InspectionReport reportId: $reportId');
        return reportId;
      } else {
        print(
            'DEBUG: InspectionReport submission failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('DEBUG: Exception during InspectionReport submission: $e');
      return null;
    }
  }

  String _buildFormJson() {
    // Build JSON string for the form data (add more fields as needed)
    return '''{
      "masterFileRef": "", // Add actual value if needed
      "inspectionDate": "", // Add actual value if needed
      "dsDivision": "", // Add actual value if needed
      "district": "", // Add actual value if needed
      "province": "", // Add actual value if needed
      "buildingId": "", // Add actual value if needed
      "buildingName": "", // Add actual value if needed
      "buildingDetails": "", // Add actual value if needed
      "noOfFloorsGPlus": "", // Add actual value if needed
      "noOfFloorsGMinus": "", // Add actual value if needed
      "age": "", // Add actual value if needed
      "expectedLifePeriod": "", // Add actual value if needed
      "parkingSpace": "", // Add actual value if needed
      "design": "", // Add actual value if needed
      "conveniences": "", // Add actual value if needed
      "structure": "", // Add actual value if needed
      "buildingConditions": "", // Add actual value if needed
      "otherInfo": "", // Add actual value if needed
      "otherConstructionDetails": "", // Add actual value if needed
      "assetDetails": "", // Add actual value if needed
      "businessDetails": "", // Add actual value if needed
      "remarks": "" // Add actual value if needed
    }''';
  }

  Future<void> _uploadImages(String reportId) async {
    print('DEBUG: _uploadImages called with reportId: $reportId');
    print('DEBUG: Number of images to upload: ${uploadedImages.length}');
    if (uploadedImages.isEmpty) return;
    var uri = Uri.parse('http://10.0.2.2:5221/api/ImageData/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['reportId'] = reportId;
    for (var image in uploadedImages) {
      if (image is File) {
        print('DEBUG: Adding image file: ${image.path}');
        request.files
            .add(await http.MultipartFile.fromPath('files', image.path));
      } else {
        print('DEBUG: Skipping non-File image: $image');
      }
    }
    try {
      var response = await request.send();
      print('DEBUG: Image upload response status: ${response.statusCode}');
      final respStr = await response.stream.bytesToString();
      print('DEBUG: Image upload response body: $respStr');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Images uploaded successfully.'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to upload images.'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('DEBUG: Exception during image upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error uploading images: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget buildView(BuildContext context) {
    // Create dynamic titles
    final String appBarTitle = _masterFileNo != null
        ? "Inspection Report - #$_masterFileNo"
        : "Inspection Report";

    final String masterFileLabel =
        _masterFileNo != null ? "Master File - #$_masterFileNo" : "Master File";

    final String inspectionReportLabel =
        _lotId != null ? "Inspection Report - #$_lotId" : "Inspection Report";

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: appBarTitle),
          Container(
            width: double.infinity,
            color: const Color(0xFFF3F4F6),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Breadcrumb(
              items: [
                BreadcrumbItem(label: "Land Miscellaneous", onTap: () {}),
                BreadcrumbItem(label: masterFileLabel, onTap: () {}),
                BreadcrumbItem(label: inspectionReportLabel, onTap: () {}),
              ],
            ),
          ),
          Expanded(
            child: _buildInspectionReportTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionReportTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 0.0,
                left: 16.0,
                right: 16.0), // Added padding to match image
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                color: colors(context).colorPrimary6 ?? const Color(0xff007bce),
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorColor: colors(context).colorBlack ?? Colors.transparent,
              dividerColor: Colors.transparent,
              labelColor: colors(context).colorWhite ?? Colors.white,
              unselectedLabelColor:
                  colors(context).colorBlack ?? Colors.black87,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: tabTitles.map((title) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.transparent, width: 0),
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLandInfoTab(),
              _buildBuildingInfoTab(), // This will now be conditional
              _buildOtherConstructionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandInfoTab() {
    return Form(
      key: _landInfoFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              label: "Master File Ref No",
              placeholder: "Enter Master File Reference Number",
              controller: _masterFileRefController,
              validator: (value) => InspectionValidator.required(
                  value, "Master File Reference Number"),
            ),
            LabeledTextField(
              label: "Inspection Date",
              placeholder: "Enter Inspection Date",
              controller: _inspectionDateController,
              validator: (value) =>
                  InspectionValidator.required(value, "Inspection Date"),
            ),
            LabeledTextField(
              label: "DS Division",
              placeholder: "Enter DS Division",
              controller: _dsDivisionController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 50, "DS Division"),
            ),
            LabeledTextField(
              label: "District",
              placeholder: "Enter District",
              controller: _districtController,
              validator: (value) =>
                  InspectionValidator.required(value, "District"),
            ),
            LabeledTextField(
              label: "Province",
              placeholder: "Enter Province",
              controller: _provinceController,
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
                    style: AppStyling.mediumTextSize14.copyWith(
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
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const Spacer(),
                CustomButton(
                  text: AppString.save.localize(context) ?? 'Save',
                  onPressed: () {
                    if (_landInfoFormKey.currentState?.validate() ?? false) {
                      // Handle save logic here
                    }
                  },
                  backgroundColor: colors(context).colorPrimary1!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingInfoTab() {
    // Conditionally show list or form
    if (_selectedBuildingName == null) {
      return _buildBuildingList();
    } else {
      return _buildBuildingForm();
    }
  }

  Widget _buildBuildingList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Building List",
            style: TextStyle(
              fontSize: 20, // Or adjust as per your app's typography
              fontWeight: FontWeight.bold,
              color: colors(context).colorBlack,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // if the list itself shouldn't scroll within its parent
            itemCount: _buildingNames.length,
            itemBuilder: (context, index) {
              final buildingName = _buildingNames[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedBuildingName = buildingName;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Building name:",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              colors(context).labelTextColor ?? Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        buildingName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors(context).colorBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: colors(context).colorBlack ?? Colors.black54,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingForm() {
    return Form(
      key: _buildingInfoFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button section remains the same...

            _buildRow([
              LabeledTextField(
                label:
                    "${AppString.buildingId.localize(context) ?? 'Building ID'} ($_selectedBuildingName)",
                placeholder: "Enter Building ID",
                controller: _buildingIdController,
                validator: (value) =>
                    InspectionValidator.required(value, "Building ID"),
              ),
              LabeledTextField(
                label: AppString.buildingName.localize(context) ?? '',
                placeholder: "Enter Building Name",
                controller: _buildingNameController,
                validator: (value) =>
                    InspectionValidator.required(value, "Building Name"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.buildingCategory.localize(context) ?? '',
                items: widget.masterData.buildingCategory,
                initialValue: widget.masterData.buildingCategory.isNotEmpty
                    ? widget.masterData.buildingCategory.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Category"),
              ),
              CustomDropdownField(
                label: AppString.buildingClass.localize(context) ?? '',
                items: widget.masterData.buildingClass,
                initialValue: widget.masterData.buildingClass.isNotEmpty
                    ? widget.masterData.buildingClass.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Class"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.detailOfBuilding.localize(context) ?? '',
                placeholder: "Enter Details",
                controller: _buildingDetailsController,
                validator: (value) => InspectionValidator.optionalAlphaNum(
                    value, 200, "Building Details"),
              ),
              LabeledTextField(
                label: AppString.noOfFloorsGPlus.localize(context) ?? '',
                placeholder: "Enter Number of Floors",
                controller: _noOfFloorsGPlusController,
                validator: (value) => InspectionValidator.required(
                    value, "Number of Floors (G+)"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.noOfFloorsGMinus.localize(context) ?? '',
                placeholder: "Enter Number of Floors",
                controller: _noOfFloorsGMinusController,
                validator: (value) => InspectionValidator.required(
                    value, "Number of Floors (G-)"),
              ),
              LabeledTextField(
                label: AppString.age.localize(context) ?? '',
                placeholder: "Enter Age",
                controller: _ageController,
                validator: (value) =>
                    InspectionValidator.required(value, "Age"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.expectedLifePeriod.localize(context) ?? '',
                placeholder: "Enter Expected Life Period",
                controller: _expectedLifePeriodController,
                validator: (value) =>
                    InspectionValidator.required(value, "Expected Life Period"),
              ),
              LabeledTextField(
                label: AppString.parkingSpace.localize(context) ?? '',
                placeholder: "Enter Parking Space",
                controller: _parkingSpaceController,
                validator: (value) => InspectionValidator.optionalAlphaNum(
                    value, 100, "Parking Space"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.design.localize(context) ?? '',
                placeholder: "Design",
                controller: _designController,
                validator: (value) =>
                    InspectionValidator.optionalAlphaNum(value, 100, "Design"),
              ),
              LabeledTextField(
                label: AppString.conveniences.localize(context) ?? '',
                placeholder: "Conveniences",
                controller: _conveniencesController,
                validator: (value) => InspectionValidator.optionalAlphaNum(
                    value, 100, "Conveniences"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.structure.localize(context) ?? '',
                placeholder: "Structure",
                controller: _structureController,
                validator: (value) =>
                    InspectionValidator.required(value, "Structure"),
              ),
              LabeledTextField(
                label: AppString.buildingConditions.localize(context) ?? '',
                placeholder: "Building Conditions",
                controller: _buildingConditionsController,
                validator: (value) =>
                    InspectionValidator.required(value, "Building Conditions"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.natureOfConstruction.localize(context) ?? '',
                items: widget.masterData.natureOfConstruction,
                initialValue: widget.masterData.natureOfConstruction.isNotEmpty
                    ? widget.masterData.natureOfConstruction.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Nature of Building"),
              ),
            ]),

            const SizedBox(height: 16),
            Text(
              AppString.roofDetails.localize(context) ?? '',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label: AppString.roofMaterial.localize(context) ?? '',
                items: widget.masterData.roofMaterial,
                initialValue: widget.masterData.roofMaterial.isNotEmpty
                    ? widget.masterData.roofMaterial.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Roof Material"),
              ),
              CustomDropdownField(
                label: AppString.roofFrame.localize(context) ?? '',
                items: widget.masterData.roofFrame,
                initialValue: widget.masterData.roofFrame.isNotEmpty
                    ? widget.masterData.roofFrame.first
                    : null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Roof Frame"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.roofFinisher.localize(context) ?? '',
                items: widget.masterData.roofFinisher,
                initialValue: widget.masterData.roofFinisher.isNotEmpty
                    ? widget.masterData.roofFinisher.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Roof Finisher"),
              ),
              CustomDropdownField(
                label: AppString.ceiling.localize(context) ?? '',
                items: widget.masterData.celing,
                initialValue: widget.masterData.celing.isNotEmpty
                    ? widget.masterData.celing.first
                    : null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Ceiling"),
              ),
            ]),

            const SizedBox(height: 16),
            Text(
              AppString.structureDetails.localize(context) ?? '',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label: AppString.foundationStructure.localize(context) ?? '',
                items: widget.masterData.foundationStructure,
                initialValue: widget.masterData.foundationStructure.isNotEmpty
                    ? widget.masterData.foundationStructure.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Foundation Structure"),
              ),
              CustomDropdownField(
                label: AppString.wallStructure.localize(context) ?? '',
                items: widget.masterData.wallStructure,
                initialValue: widget.masterData.wallStructure.isNotEmpty
                    ? widget.masterData.wallStructure.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Wall Structure"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.floorStructure.localize(context) ?? '',
                items: widget.masterData.floorStructure,
                initialValue: widget.masterData.floorStructure.isNotEmpty
                    ? widget.masterData.floorStructure.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Floor Structure"),
              ),
            ]),

            Text(
              AppString.fixedAndFittingDetails.localize(context) ?? '',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label: AppString.door.localize(context) ?? '',
                items: widget.masterData.door,
                initialValue: widget.masterData.door.isNotEmpty
                    ? widget.masterData.door.first
                    : null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Door"),
              ),
              CustomDropdownField(
                label: AppString.window.localize(context) ?? '',
                items: widget.masterData.window,
                initialValue: widget.masterData.window.isNotEmpty
                    ? widget.masterData.window.first
                    : null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Window"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.windowProtection.localize(context) ?? '',
                items: widget.masterData.windowProtection,
                initialValue: widget.masterData.windowProtection.isNotEmpty
                    ? widget.masterData.windowProtection.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Window Protection"),
              ),
              CustomDropdownField(
                label:
                    AppString.doorsBathroomToiletFittings.localize(context) ??
                        '',
                items: widget.masterData.doorsBathroomAndToiletFittings,
                initialValue:
                    widget.masterData.doorsBathroomAndToiletFittings.isNotEmpty
                        ? widget.masterData.doorsBathroomAndToiletFittings.first
                        : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Doors Bathroom and Toilet Fittings"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.doorsHandRail.localize(context) ?? '',
                items: widget.masterData.doorsHandRail,
                initialValue: widget.masterData.doorsHandRail.isNotEmpty
                    ? widget.masterData.doorsHandRail.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Doors Hand Rail"),
              ),
              CustomDropdownField(
                label: AppString.doorsPantryCupboard.localize(context) ?? '',
                items: widget.masterData.doorsPantryCupboard,
                initialValue: widget.masterData.doorsPantryCupboard.isNotEmpty
                    ? widget.masterData.doorsPantryCupboard.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Doors Pantry Cupboard"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.doorsOther.localize(context) ?? '',
                items: widget.masterData.doorsOther,
                initialValue: widget.masterData.doorsOther.isNotEmpty
                    ? widget.masterData.doorsOther.first
                    : null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Doors Other"),
              ),
            ]),

            const SizedBox(height: 16),
            Text(
              AppString.finishersServiceDetails.localize(context) ?? '',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label: AppString.wallFinisher.localize(context) ?? '',
                items: widget.masterData.wallFinisher,
                initialValue: widget.masterData.wallFinisher.isNotEmpty
                    ? widget.masterData.wallFinisher.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Wall Finisher"),
              ),
              CustomDropdownField(
                label: AppString.floorFinisher.localize(context) ?? '',
                items: widget.masterData.floorFinisher,
                initialValue: widget.masterData.floorFinisher.isNotEmpty
                    ? widget.masterData.floorFinisher.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Floor Finisher"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.bathroomToilet.localize(context) ?? '',
                items: widget.masterData.bathroomAndToilet,
                initialValue: widget.masterData.bathroomAndToilet.isNotEmpty
                    ? widget.masterData.bathroomAndToilet.first
                    : null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Bathroom and Toilet"),
              ),
              CustomDropdownField(
                label: AppString.services.localize(context) ?? '',
                items: widget.masterData.services,
                initialValue: widget.masterData.services.isNotEmpty
                    ? widget.masterData.services.first
                    : null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Services"),
              ),
            ]),

            const SizedBox(height: 16),
            Text(
              AppString.finishersServiceDetails.localize(context) ?? '',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            CustomButton(
              text: AppString.addOwner.localize(context) ?? '',
              onPressed: () {},
              backgroundColor: colors(context).colorGrey1!,
              width: 150,
              height: 48,
            ),

            const SizedBox(height: 16),
            Text(
              AppString.imageCapturingUpload.localize(context) ?? '',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

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
                  text: AppString.cancel.localize(context) ?? '',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const Spacer(),
                CustomButton(
                  text: AppString.sendData.localize(context) ?? '',
                  onPressed: _validateAndSubmit,
                  backgroundColor: colors(context).colorPrimary5!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherConstructionsTab() {
    return Form(
      key: _otherConstructionsFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              label: "Other Information",
              placeholder: "Enter other information",
              controller: _otherInfoController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Other Information"),
            ),
            LabeledTextField(
              label: "Other Construction Details",
              placeholder: "Enter construction details",
              controller: _otherConstructionDetailsController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Other Construction Details"),
            ),
            LabeledTextField(
              label: "Details of Assets/Inventory Items",
              placeholder: "Enter asset details",
              controller: _assetDetailsController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Asset Details"),
            ),
            LabeledTextField(
              label: "Details of Business",
              placeholder: "Enter business details",
              controller: _businessDetailsController,
              validator: (value) => InspectionValidator.optionalAlphaNum(
                  value, 200, "Business Details"),
            ),
            LabeledTextField(
              label: "Remarks",
              placeholder: "Enter remarks",
              controller: _remarksController,
              validator: (value) =>
                  InspectionValidator.optionalAlphaNum(value, 500, "Remarks"),
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
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const Spacer(),
                CustomButton(
                  text: AppString.save.localize(context) ?? 'Save',
                  onPressed: () {
                    if (_otherConstructionsFormKey.currentState?.validate() ??
                        false) {
                      // Handle save logic here
                    }
                  },
                  backgroundColor: colors(context).colorPrimary1!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children
            .map((widget) => Expanded(
                child: Padding(
                    // Added padding around each item in the row
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: widget)))
            .toList(),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
