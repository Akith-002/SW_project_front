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
import 'package:land_asset_valuation/data/models/building.dart';
import 'package:land_asset_valuation/data/services/inspection_report_service.dart';
import 'package:land_asset_valuation/data/services/building_service.dart';
import 'package:land_asset_valuation/application/core/widgets/saved_reports_dialog.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

  // State for Building Info Tab - Dynamic Buildings
  Building? _selectedBuilding;
  List<Building> _availableBuildings = [];
  bool _buildingsLoaded = false;
  final BuildingService _buildingService = BuildingService();
  final InspectionReportService _inspectionReportService =
      InspectionReportService();

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

  // Dropdown selection variables for validation
  String? _selectedBuildingCategory;
  String? _selectedBuildingClass;
  String? _selectedNatureOfConstruction;
  String? _selectedBuildingConditions;

  // Add controllers for other constructions form
  final _otherInfoController = TextEditingController();
  final _otherConstructionDetailsController = TextEditingController();
  final _assetDetailsController = TextEditingController();
  final _businessDetailsController = TextEditingController();
  final _remarksController = TextEditingController();

  // Data passed from navigation
  String? _masterFileNo;
  String? _lotId;
  bool _dataExtracted = false;

  // Building form completion tracking
  Map<String, bool> _buildingFormCompletionStatus = {};
  Map<String, Map<String, dynamic>> _savedBuildingForms = {};

  @override
  void initState() {
    _tabController = TabController(length: tabTitles.length, vsync: this);

    // Add listeners to text controllers to update save button state
    _addFormListeners();

    super.initState();
  }

  // Method to add listeners to form controllers for real-time validation
  void _addFormListeners() {
    // Add listeners to required text controllers for building form
    _buildingIdController.addListener(_updateSaveButtonState);
    _buildingNameController.addListener(_updateSaveButtonState);
    _noOfFloorsGPlusController.addListener(_updateSaveButtonState);
    _noOfFloorsGMinusController.addListener(_updateSaveButtonState);
    _ageController.addListener(_updateSaveButtonState);
    _expectedLifePeriodController.addListener(_updateSaveButtonState);
    _structureController.addListener(_updateSaveButtonState);

    // Add listeners to land info form controllers
    _masterFileRefController.addListener(_updateSaveButtonState);
    _inspectionDateController.addListener(_updateSaveButtonState);
    _districtController.addListener(_updateSaveButtonState);
    _provinceController.addListener(_updateSaveButtonState);

    // Add listeners to other constructions form controllers
    _otherInfoController.addListener(_updateSaveButtonState);
    _otherConstructionDetailsController.addListener(_updateSaveButtonState);
  }

  // Method to update save button state when form changes
  void _updateSaveButtonState() {
    // Trigger a rebuild to update the save button state
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataExtracted) {
      _extractNavigationData();
      _dataExtracted = true;
      // Load buildings after extracting navigation data
      _loadBuildingsForLot();
    }
  }

  /// Load buildings for the current lot and master file
  Future<void> _loadBuildingsForLot() async {
    if (_lotId != null && _masterFileNo != null) {
      debugPrint(
          "Loading buildings for lot: $_lotId, masterFile: $_masterFileNo");
      try {
        final buildings =
            await _buildingService.getBuildingsForLot(_lotId!, _masterFileNo!);
        setState(() {
          _availableBuildings = buildings;
          _buildingsLoaded = true;
        });
        debugPrint("Loaded ${buildings.length} buildings");
      } catch (e) {
        debugPrint("Error loading buildings: $e");
        setState(() {
          _availableBuildings = [];
          _buildingsLoaded = true;
        });
      }
    } else {
      debugPrint(
          "Cannot load buildings: lotId=$_lotId, masterFileNo=$_masterFileNo");
      setState(() {
        _buildingsLoaded = true;
      });
    }
  }

  void _extractNavigationData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;

    _masterFileNo = queryParams['masterFileNo'];
    _lotId = queryParams['lotId'];

    // Auto-fill the form fields
    _autoFillFormFields();

    debugPrint(
        "InspectionReport: Extracted data - Master File No: $_masterFileNo, Lot ID: $_lotId");
  }

  void _autoFillFormFields() {
    // Auto-fill Master File Reference Number if available
    if (_masterFileNo != null && _masterFileNo!.isNotEmpty) {
      _masterFileRefController.text = _masterFileNo!;
    }

    // Auto-fill Inspection Date with today's date
    final DateTime now = DateTime.now();
    final String todayDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    _inspectionDateController.text = todayDate;

    debugPrint(
        "InspectionReport: Auto-filled Master File Ref: ${_masterFileRefController.text}");
    debugPrint(
        "InspectionReport: Auto-filled Inspection Date: ${_inspectionDateController.text}");
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _removeFormListeners();

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

  // Method to remove listeners from form controllers
  void _removeFormListeners() {
    // Remove building form listeners
    _buildingIdController.removeListener(_updateSaveButtonState);
    _buildingNameController.removeListener(_updateSaveButtonState);
    _noOfFloorsGPlusController.removeListener(_updateSaveButtonState);
    _noOfFloorsGMinusController.removeListener(_updateSaveButtonState);
    _ageController.removeListener(_updateSaveButtonState);
    _expectedLifePeriodController.removeListener(_updateSaveButtonState);
    _structureController.removeListener(_updateSaveButtonState);

    // Remove land info form listeners
    _masterFileRefController.removeListener(_updateSaveButtonState);
    _inspectionDateController.removeListener(_updateSaveButtonState);
    _districtController.removeListener(_updateSaveButtonState);
    _provinceController.removeListener(_updateSaveButtonState);

    // Remove other constructions form listeners
    _otherInfoController.removeListener(_updateSaveButtonState);
    _otherConstructionDetailsController.removeListener(_updateSaveButtonState);
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

  // Function to handle validation and save data locally
  void _validateAndSaveLocally() async {
    // Check if we have required building information
    if (_selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a building first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if the building form is completely empty (newly drawn building)
    if (_isBuildingFormEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the building information before saving'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // Check if the form is partially filled but incomplete
    if (_isBuildingFormPartiallyFilled()) {
      // Show a more specific message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please complete all required building fields before saving'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return; // Add return statement to prevent further execution
    }

    // Validate the building form
    if (_buildingInfoFormKey.currentState?.validate() ?? false) {
      // Additional manual validation for critical fields
      final validationErrors = _validateRequiredFields();

      if (validationErrors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please fill required fields: ${validationErrors.join(', ')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      // Collect all form data
      final formData = _collectFormData();

      // Save data locally using the inspection report service
      final success =
          await _inspectionReportService.saveInspectionReportLocally(
        masterFileRef: _masterFileRefController.text,
        buildingId: _buildingIdController.text,
        buildingName: _buildingNameController.text,
        formData: formData,
      );

      if (success) {
        if (mounted) {
          // Mark this building as complete
          setState(() {
            _buildingFormCompletionStatus[_selectedBuilding!.id] = true;
            _savedBuildingForms[_selectedBuilding!.id] = formData;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Building inspection data saved successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Optionally clear the form or navigate back
          setState(() {
            _selectedBuilding = null;
            _clearBuildingForm();
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to save inspection data. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the validation errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to check if building form is completely empty
  bool _isBuildingFormEmpty() {
    // Don't count building ID and name as they are auto-filled when building is selected
    // Check if all user-entered required text controllers are empty
    bool userTextFieldsEmpty = _buildingDetailsController.text.trim().isEmpty &&
        _noOfFloorsGPlusController.text.trim().isEmpty &&
        _noOfFloorsGMinusController.text.trim().isEmpty &&
        _ageController.text.trim().isEmpty &&
        _expectedLifePeriodController.text.trim().isEmpty &&
        _structureController.text.trim().isEmpty;

    // Check if all required dropdowns are empty
    bool dropdownsEmpty = _selectedBuildingCategory == null &&
        _selectedBuildingClass == null &&
        _selectedNatureOfConstruction == null &&
        _selectedBuildingConditions == null;

    // Check if optional fields are also empty
    bool optionalFieldsEmpty = _parkingSpaceController.text.trim().isEmpty &&
        _designController.text.trim().isEmpty &&
        _conveniencesController.text.trim().isEmpty;

    // Check if no images are uploaded
    bool noImages = uploadedImages.isEmpty;

    // Form is considered empty if all user-filled required fields and dropdowns are empty
    return userTextFieldsEmpty &&
        dropdownsEmpty &&
        optionalFieldsEmpty &&
        noImages;
  }

  // Method to check if user has started filling form but hasn't completed it
  bool _isBuildingFormPartiallyFilled() {
    // Count filled required fields (excluding auto-filled Building ID and Name)
    int filledRequiredFields = 0;
    int totalRequiredFields =
        9; // Floors G+, Floors G-, Age, Expected Life, Structure + 4 dropdowns

    // Don't count auto-filled fields: _buildingIdController and _buildingNameController
    if (_noOfFloorsGPlusController.text.trim().isNotEmpty)
      filledRequiredFields++;
    if (_noOfFloorsGMinusController.text.trim().isNotEmpty)
      filledRequiredFields++;
    if (_ageController.text.trim().isNotEmpty) filledRequiredFields++;
    if (_expectedLifePeriodController.text.trim().isNotEmpty)
      filledRequiredFields++;
    if (_structureController.text.trim().isNotEmpty) filledRequiredFields++;
    if (_selectedBuildingCategory != null) filledRequiredFields++;
    if (_selectedBuildingClass != null) filledRequiredFields++;
    if (_selectedNatureOfConstruction != null) filledRequiredFields++;
    if (_selectedBuildingConditions != null) filledRequiredFields++;

    // Return true if some but not all required fields are filled
    return filledRequiredFields > 0 &&
        filledRequiredFields < totalRequiredFields;
  }

  // Method to get appropriate save button text based on form state
  String _getSaveButtonText() {
    if (_isBuildingFormEmpty()) {
      return 'Fill Form to Save';
    } else if (_isBuildingFormPartiallyFilled()) {
      return 'Complete Required Fields';
    } else {
      return AppString.save.localize(context) ?? 'Save Data';
    }
  }

  // Method to check if a building form is complete
  bool _isBuildingFormComplete(String buildingId) {
    return _buildingFormCompletionStatus[buildingId] ?? false;
  }

  // Method to check if all building forms are complete
  bool _areAllBuildingFormsComplete() {
    if (_availableBuildings.isEmpty) return true; // No buildings to complete

    for (Building building in _availableBuildings) {
      if (!_isBuildingFormComplete(building.id)) {
        return false;
      }
    }
    return true;
  }

  // Individual tab validation methods
  bool _isLandInfoComplete() {
    return _landInfoFormKey.currentState?.validate() ?? false;
  }

  bool _isOtherConstructionsComplete() {
    // Other constructions are optional, so always return true for now
    return true;
  }

  // Comprehensive validation for all tabs
  bool _isInspectionReportComplete() {
    return _isLandInfoComplete() &&
        _areAllBuildingFormsComplete() &&
        _isOtherConstructionsComplete();
  }

  // Global save button text and state
  String _getGlobalSaveButtonText() {
    if (_canSaveInspectionReport()) {
      return 'Save Inspection Report';
    } else {
      return 'Complete All Required Fields';
    }
  }

  bool _canSaveInspectionReport() {
    return _isInspectionReportComplete();
  }

  // Data collection methods
  Map<String, dynamic> _collectLandInfoData() {
    return {
      'masterFileRef': _masterFileRefController.text,
      'inspectionDate': _inspectionDateController.text,
      'dsDivision': _dsDivisionController.text,
      'district': _districtController.text,
      'province': _provinceController.text,
    };
  }

  Map<String, dynamic> _collectOtherConstructionsData() {
    return {
      'otherInfo': _otherInfoController.text,
      'otherConstructionDetails': _otherConstructionDetailsController.text,
      'assetDetails': _assetDetailsController.text,
      'businessDetails': _businessDetailsController.text,
      'remarks': _remarksController.text,
    };
  }

  // Global save method for complete inspection report
  void _saveCompleteInspectionReport() async {
    if (!_canSaveInspectionReport()) {
      _showIncompleteSaveMessage();
      return;
    }

    // Collect all data from all tabs
    final completeReportData = {
      'landInfo': _collectLandInfoData(),
      'buildingForms': _savedBuildingForms,
      'otherConstructions': _collectOtherConstructionsData(),
      'masterFileNo': _masterFileNo,
      'lotId': _lotId,
      'savedAt': DateTime.now().toIso8601String(),
    };

    // Save complete inspection report
    // TODO: Implement saveCompleteInspectionReport method in InspectionReportService
    // For now, use the existing method as a placeholder
    final success = await _inspectionReportService.saveInspectionReportLocally(
      masterFileRef: _masterFileRefController.text,
      buildingId: 'COMPLETE_REPORT',
      buildingName: 'Complete Inspection Report',
      formData: completeReportData,
    );

    if (success) {
      if (mounted) {
        // Show success and navigate away
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complete inspection report saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to save complete inspection report. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showIncompleteSaveMessage() {
    String message = '';
    if (!_isLandInfoComplete()) {
      message = 'Please complete the Land Info tab first';
    } else if (!_areAllBuildingFormsComplete()) {
      int completedBuildings = _buildingFormCompletionStatus.values
          .where((completed) => completed)
          .length;
      message =
          'Please complete all building forms (${completedBuildings}/${_availableBuildings.length} completed)';
    } else if (!_isOtherConstructionsComplete()) {
      message = 'Please complete the Other Constructions tab';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Method to validate required fields manually
  List<String> _validateRequiredFields() {
    List<String> errors = [];

    // Check required text fields
    if (_buildingIdController.text.trim().isEmpty) {
      errors.add('Building ID');
    }
    if (_buildingNameController.text.trim().isEmpty) {
      errors.add('Building Name');
    }
    if (_noOfFloorsGPlusController.text.trim().isEmpty) {
      errors.add('Number of Floors (G+)');
    }
    if (_noOfFloorsGMinusController.text.trim().isEmpty) {
      errors.add('Number of Floors (G-)');
    }
    if (_ageController.text.trim().isEmpty) {
      errors.add('Age');
    }
    if (_expectedLifePeriodController.text.trim().isEmpty) {
      errors.add('Expected Life Period');
    }
    if (_structureController.text.trim().isEmpty) {
      errors.add('Structure');
    }

    // Check required dropdown fields
    if (_selectedBuildingCategory == null ||
        _selectedBuildingCategory!.isEmpty) {
      errors.add('Building Category');
    }
    if (_selectedBuildingClass == null || _selectedBuildingClass!.isEmpty) {
      errors.add('Building Class');
    }
    if (_selectedNatureOfConstruction == null ||
        _selectedNatureOfConstruction!.isEmpty) {
      errors.add('Nature of Construction');
    }
    if (_selectedBuildingConditions == null ||
        _selectedBuildingConditions!.isEmpty) {
      errors.add('Building Conditions');
    }

    return errors;
  }

  // Helper method to collect all form data
  Map<String, dynamic> _collectFormData() {
    return {
      'masterFileRef': _masterFileRefController.text,
      'inspectionDate': _inspectionDateController.text,
      'dsDivision': _dsDivisionController.text,
      'district': _districtController.text,
      'province': _provinceController.text,
      'buildingId': _buildingIdController.text,
      'buildingName': _buildingNameController.text,
      'buildingDetails': _buildingDetailsController.text,
      'noOfFloorsGPlus': _noOfFloorsGPlusController.text,
      'noOfFloorsGMinus': _noOfFloorsGMinusController.text,
      'age': _ageController.text,
      'expectedLifePeriod': _expectedLifePeriodController.text,
      'parkingSpace': _parkingSpaceController.text,
      'design': _designController.text,
      'conveniences': _conveniencesController.text,
      'structure': _structureController.text,
      'buildingConditions': _selectedBuildingConditions,
      'buildingCategory': _selectedBuildingCategory,
      'buildingClass': _selectedBuildingClass,
      'natureOfConstruction': _selectedNatureOfConstruction,
      'selectedBuilding': _selectedBuilding?.toJson(),
      'images': uploadedImages
          .map((img) => img is File ? img.path : img.toString())
          .toList(),
      'savedAt': DateTime.now().toIso8601String(),
    };
  }

  // Method to clear building form data
  void _clearBuildingForm() {
    _buildingIdController.clear();
    _buildingNameController.clear();
    _buildingDetailsController.clear();
    _noOfFloorsGPlusController.clear();
    _noOfFloorsGMinusController.clear();
    _ageController.clear();
    _expectedLifePeriodController.clear();
    _parkingSpaceController.clear();
    _designController.clear();
    _conveniencesController.clear();
    _structureController.clear();
    _buildingConditionsController.clear();

    // Reset dropdown selections
    _selectedBuildingCategory = null;
    _selectedBuildingClass = null;
    _selectedNatureOfConstruction = null;
    _selectedBuildingConditions = null;

    // Clear uploaded images
    uploadedImages.clear();
  }

  // Method to show saved reports dialog
  void _showSavedReportsDialog() {
    showDialog(
      context: context,
      builder: (context) => const SavedReportsDialog(),
    );
  }

  // Helper method to get building category options from structured data
  List<String> _getBuildingCategoryOptions() {
    return [
      "Residential Building -Single storied",
      "Commercial Building  Multistoried",
      "Commercial Building",
      "Residential Building -Multi storied",
      "Industrial Building",
      "Tenement",
      "Sheds",
      "Stair Case"
    ];
  }

  // Helper method to get building class options from structured data
  List<String> _getBuildingClassOptions() {
    return [
      "Special Type",
      "Ultra Modern",
      "Modern",
      "Semi Modern",
      "Obsolete",
      "Non",
      "Building Hight 12 feet",
      "Building Hight 15feet",
      "Concrete",
      "Iron"
    ];
  }

  // Helper method to get nature of construction options from structured data
  List<String> _getNatureOfConstructionOptions() {
    return [
      "Permanent",
      "Renovated",
      "Temporary",
      "Incomplete",
      "Under Construction",
      "Converted",
      "Abandon Building"
    ];
  }

  // Helper method to get building conditions options from structured data
  List<String> _getBuildingConditionsOptions() {
    return ["Sel", "V.Good", "Good", "Faire+", "Faire-", "Poor", "V,Poor"];
  }

  // Helper methods for roof section
  List<String> _getRoofMaterialOptions() {
    return [
      "Color-Con Tiled",
      "Calicut Tiled -Color up",
      "Reinforced Cement Concrete",
      "Fiber glass Sheets",
      "Clay Tiled",
      "Galvanized (Aluminium) Corrugated Sheets",
      "Zink aluminum tile sheet",
      "ASB Color up sheets",
      "Asbestos Sheets",
      "Aluminum Sheets Roofed plane",
      "Corrugated iron sheet",
      "Plastic Sheets",
      "Tar Sheets",
      "Cajon"
    ];
  }

  List<String> _getRoofFrameOptions() {
    return [
      "Sawn Timber class 1",
      "Detail Timber Frame",
      "Sawn Timber class 2",
      "Sawn coconut rafter",
      "C purlin -GI",
      "Coconut rafter",
      "Iron Craft",
      "GI Pipe",
      "Round timber"
    ];
  }

  List<String> _getRoofFinisherOptions() {
    return [
      "Valance board - Wooden calss 1 or 2",
      "Gutters-Aluminum",
      "Downpipes-Aluminum",
      "Valance boards - Aluminum",
      "Downpipes-Plastic"
    ];
  }

  List<String> _getCeilingOptions() {
    return [
      "Timber Plank",
      "Decorative timber plank",
      "Detail celling",
      "Asb Exposed rafter"
    ];
  }

  // Helper methods for structure section
  List<String> _getFoundationStructureOptions() {
    return [
      "RCC",
      "Pile",
      "Mini plie",
      "Random rubble with Rcc Column and beam"
    ];
  }

  List<String> _getWallStructureOptions() {
    return [
      "Columns with 9\" brick all 9\"",
      "Brick 9\"",
      "Glass",
      "Cement hollow block"
    ];
  }

  List<String> _getFloorStructureOptions() {
    return ["RCC Concrete", "Concrete", "Brick"];
  }

  // Helper methods for fixture and fitting section
  List<String> _getDoorOptions() {
    return ["Timber panel with timber frame", "Iron Roller shutter"];
  }

  List<String> _getWindowOptions() {
    return ["Timber panel with timber frame", "Glazed with timber frame"];
  }

  List<String> _getWindowProtectionOptions() {
    return ["Stainless Steel", "Iron Drill", "Iron rode"];
  }

  List<String> _getDoorsBathroomAndToiletFittingsOptions() {
    return [
      "Full furnished bath room with class 1 fittings -Unit",
      "Full furnished bath room with class 2-3 fittings  Unit"
    ];
  }

  List<String> _getDoorsHandRailOptions() {
    return ["Wooden- Class 01 unit", "Wooden landing- Class 01 unit"];
  }

  List<String> _getDoorsPantryCupboardOptions() {
    return ["Wooden pantry cupboard class 1 unit", "Aluminum unit"];
  }

  List<String> _getDoorsOtherOptions() {
    return ["Air conditions-central unit", "Sola panel- unit"];
  }

  // Helper methods for finishers and services section
  List<String> _getWallFinisherOptions() {
    return ["Tiled", "Wall Papers"];
  }

  List<String> _getFloorFinisherOptions() {
    return ["Granite", "Terrazzo"];
  }

  List<String> _getBathroomAndToiletOptions() {
    return [" tile Grade A- Floor+Wall", "Tile Class 2- Floor+Wall"];
  }

  List<String> _getServicesOptions() {
    return ["Three phase electricity", "Additional transformer"];
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
          CustomAppBar(
            title: appBarTitle,
            rightIcon1: (style) => PhosphorIcons.archive(style),
            onRightIcon1Pressed: _showSavedReportsDialog,
          ),
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
                  text: _getGlobalSaveButtonText(),
                  onPressed: _canSaveInspectionReport()
                      ? _saveCompleteInspectionReport
                      : null,
                  backgroundColor: _canSaveInspectionReport()
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

  Widget _buildBuildingInfoTab() {
    // Show loading indicator while buildings are being loaded
    if (!_buildingsLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show empty state if no buildings found
    if (_availableBuildings.isEmpty) {
      return _buildNoBuildingsState();
    }

    // Show building list or form based on selection
    if (_selectedBuilding == null) {
      return _buildBuildingList();
    } else {
      return _buildBuildingForm();
    }
  }

  Widget _buildNoBuildingsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No buildings found for this lot",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Draw buildings in the map sketch tools first",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Go Back to Map",
              onPressed: () => Navigator.pop(context),
              backgroundColor: colors(context).colorPrimary1!,
              width: 200,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Buildings (${_availableBuildings.length})",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors(context).colorBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _availableBuildings.length,
              itemBuilder: (context, index) {
                final building = _availableBuildings[index];
                final isComplete = _isBuildingFormComplete(building.id);
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedBuilding = building;
                      // Pre-fill form with building data
                      _buildingIdController.text =
                          building.id; // Auto-fill building ID
                      _buildingNameController.text = building.name;
                      // Reset dropdown selections to ensure validation
                      _selectedBuildingCategory = null;
                      _selectedBuildingClass = null;
                      _selectedNatureOfConstruction = null;
                      _selectedBuildingConditions = null;
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
                        // Completion status indicator
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isComplete
                                ? Colors.green
                                : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Building name:",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors(context).labelTextColor ??
                                Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          building.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isComplete
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: colors(context).colorBlack,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isComplete)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
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
            // Back button to return to building list
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedBuilding = null;
                      // Clear form data
                      _clearBuildingForm();
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: colors(context).colorPrimary5,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Back to Building List",
                        style: TextStyle(
                          color: colors(context).colorPrimary5,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildRow([
              LabeledTextField(
                label:
                    "${AppString.buildingId.localize(context) ?? 'Building ID'} (${_selectedBuilding?.name ?? 'Unknown'})",
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
                items: _getBuildingCategoryOptions(),
                initialValue: _selectedBuildingCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedBuildingCategory = value;
                  });
                  _updateSaveButtonState();
                },
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Category"),
              ),
              CustomDropdownField(
                label: AppString.buildingClass.localize(context) ?? '',
                items: _getBuildingClassOptions(),
                initialValue: _selectedBuildingClass,
                onChanged: (value) {
                  setState(() {
                    _selectedBuildingClass = value;
                  });
                  _updateSaveButtonState();
                },
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
              CustomDropdownField(
                label: AppString.buildingConditions.localize(context) ?? '',
                items: _getBuildingConditionsOptions(),
                initialValue: _selectedBuildingConditions,
                onChanged: (value) {
                  setState(() {
                    _selectedBuildingConditions = value;
                  });
                  _updateSaveButtonState();
                },
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Conditions"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.natureOfConstruction.localize(context) ?? '',
                items: _getNatureOfConstructionOptions(),
                initialValue: _selectedNatureOfConstruction,
                onChanged: (value) {
                  setState(() {
                    _selectedNatureOfConstruction = value;
                  });
                  _updateSaveButtonState();
                },
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
                items: _getRoofMaterialOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Roof Material"),
              ),
              CustomDropdownField(
                label: AppString.roofFrame.localize(context) ?? '',
                items: _getRoofFrameOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Roof Frame"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.roofFinisher.localize(context) ?? '',
                items: _getRoofFinisherOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Roof Finisher"),
              ),
              CustomDropdownField(
                label: AppString.ceiling.localize(context) ?? '',
                items: _getCeilingOptions(),
                initialValue: null,
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
                items: _getFoundationStructureOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Foundation Structure"),
              ),
              CustomDropdownField(
                label: AppString.wallStructure.localize(context) ?? '',
                items: _getWallStructureOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Wall Structure"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.floorStructure.localize(context) ?? '',
                items: _getFloorStructureOptions(),
                initialValue: null,
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
                items: _getDoorOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Door"),
              ),
              CustomDropdownField(
                label: AppString.window.localize(context) ?? '',
                items: _getWindowOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Window"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.windowProtection.localize(context) ?? '',
                items: _getWindowProtectionOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Window Protection"),
              ),
              CustomDropdownField(
                label:
                    AppString.doorsBathroomToiletFittings.localize(context) ??
                        '',
                items: _getDoorsBathroomAndToiletFittingsOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Doors Bathroom and Toilet Fittings"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.doorsHandRail.localize(context) ?? '',
                items: _getDoorsHandRailOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Doors Hand Rail"),
              ),
              CustomDropdownField(
                label: AppString.doorsPantryCupboard.localize(context) ?? '',
                items: _getDoorsPantryCupboardOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Doors Pantry Cupboard"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.doorsOther.localize(context) ?? '',
                items: _getDoorsOtherOptions(),
                initialValue: null,
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
                items: _getWallFinisherOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Wall Finisher"),
              ),
              CustomDropdownField(
                label: AppString.floorFinisher.localize(context) ?? '',
                items: _getFloorFinisherOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Floor Finisher"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.bathroomToilet.localize(context) ?? '',
                items: _getBathroomAndToiletOptions(),
                initialValue: null,
                onChanged: (value) {},
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Bathroom and Toilet"),
              ),
              CustomDropdownField(
                label: AppString.services.localize(context) ?? '',
                items: _getServicesOptions(),
                initialValue: null,
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
                  onPressed: () {
                    setState(() {
                      _selectedBuilding = null;
                      _clearBuildingForm();
                    });
                  },
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const Spacer(),
                CustomButton(
                  text: _getSaveButtonText(),
                  onPressed:
                      _isBuildingFormEmpty() ? null : _validateAndSaveLocally,
                  backgroundColor: _isBuildingFormEmpty()
                      ? colors(context).colorGrey1!
                      : colors(context).colorPrimary5!,
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
                  text: _getGlobalSaveButtonText(),
                  onPressed: _canSaveInspectionReport()
                      ? _saveCompleteInspectionReport
                      : null,
                  backgroundColor: _canSaveInspectionReport()
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
