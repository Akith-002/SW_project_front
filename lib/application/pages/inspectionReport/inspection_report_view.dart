import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_cubit.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_state.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:land_asset_valuation/data/models/building.dart';
import 'package:land_asset_valuation/data/services/inspection_report_service.dart';
import 'package:land_asset_valuation/data/services/building_service.dart';
import 'package:land_asset_valuation/application/core/widgets/saved_reports_dialog.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Import the new widgets
import 'package:land_asset_valuation/application/pages/inspectionReport/widgets/land_info_tab.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/widgets/building_info_tab.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/widgets/other_constructions_tab.dart';

// Import the new helpers
import 'package:land_asset_valuation/application/pages/inspectionReport/helpers/inspection_form_helpers.dart';

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

  // Building specification dropdown variables
  String? _selectedRoofMaterial;
  String? _selectedRoofFrame;
  String? _selectedRoofFinisher;
  String? _selectedCeiling;
  String? _selectedFoundationStructure;
  String? _selectedWallStructure;
  String? _selectedFloorStructure;
  String? _selectedDoor;
  String? _selectedWindow;
  String? _selectedWindowProtection;
  String? _selectedBathroomToiletDoorsFittings;
  String? _selectedHandRail;
  String? _selectedPantryCupboard;
  String? _selectedOtherDoors;
  String? _selectedWallFinisher;
  String? _selectedFloorFinisher;
  String? _selectedBathroomToilet;
  String? _selectedServices;

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

    _autoFillFormFields();

    debugPrint(
        "InspectionReport: Extracted data - Master File No: $_masterFileNo, Lot ID: $_lotId");
  }

  void _autoFillFormFields() {
    if (_masterFileNo != null && _masterFileNo!.isNotEmpty) {
      _masterFileRefController.text = _masterFileNo!;
    }

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

  void _removeFormListeners() {
    _buildingIdController.removeListener(_updateSaveButtonState);
    _buildingNameController.removeListener(_updateSaveButtonState);
    _noOfFloorsGPlusController.removeListener(_updateSaveButtonState);
    _noOfFloorsGMinusController.removeListener(_updateSaveButtonState);
    _ageController.removeListener(_updateSaveButtonState);
    _expectedLifePeriodController.removeListener(_updateSaveButtonState);
    _structureController.removeListener(_updateSaveButtonState);

    _masterFileRefController.removeListener(_updateSaveButtonState);
    _inspectionDateController.removeListener(_updateSaveButtonState);
    _districtController.removeListener(_updateSaveButtonState);
    _provinceController.removeListener(_updateSaveButtonState);

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
    if (_selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a building first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isEmpty = InspectionFormHelpers.isBuildingFormEmpty(
      buildingDetailsController: _buildingDetailsController,
      noOfFloorsGPlusController: _noOfFloorsGPlusController,
      noOfFloorsGMinusController: _noOfFloorsGMinusController,
      ageController: _ageController,
      expectedLifePeriodController: _expectedLifePeriodController,
      structureController: _structureController,
      parkingSpaceController: _parkingSpaceController,
      designController: _designController,
      conveniencesController: _conveniencesController,
      selectedBuildingCategory: _selectedBuildingCategory,
      selectedBuildingClass: _selectedBuildingClass,
      selectedNatureOfConstruction: _selectedNatureOfConstruction,
      selectedBuildingConditions: _selectedBuildingConditions,
      uploadedImages: uploadedImages,
    );

    if (isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the building information before saving'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    final isPartiallyFilled =
        InspectionFormHelpers.isBuildingFormPartiallyFilled(
      noOfFloorsGPlusController: _noOfFloorsGPlusController,
      noOfFloorsGMinusController: _noOfFloorsGMinusController,
      ageController: _ageController,
      expectedLifePeriodController: _expectedLifePeriodController,
      structureController: _structureController,
      selectedBuildingCategory: _selectedBuildingCategory,
      selectedBuildingClass: _selectedBuildingClass,
      selectedNatureOfConstruction: _selectedNatureOfConstruction,
      selectedBuildingConditions: _selectedBuildingConditions,
    );

    if (isPartiallyFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please complete all required building fields before saving'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // Validate the building form
    if (_buildingInfoFormKey.currentState?.validate() ?? false) {
      final validationErrors = InspectionFormHelpers.validateRequiredFields(
        buildingIdController: _buildingIdController,
        buildingNameController: _buildingNameController,
        noOfFloorsGPlusController: _noOfFloorsGPlusController,
        noOfFloorsGMinusController: _noOfFloorsGMinusController,
        ageController: _ageController,
        expectedLifePeriodController: _expectedLifePeriodController,
        structureController: _structureController,
        selectedBuildingCategory: _selectedBuildingCategory,
        selectedBuildingClass: _selectedBuildingClass,
        selectedNatureOfConstruction: _selectedNatureOfConstruction,
        selectedBuildingConditions: _selectedBuildingConditions,
      );

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
      final formData = InspectionFormHelpers.collectFormData(
        masterFileRefController: _masterFileRefController,
        inspectionDateController: _inspectionDateController,
        dsDivisionController: _dsDivisionController,
        districtController: _districtController,
        provinceController: _provinceController,
        buildingIdController: _buildingIdController,
        buildingNameController: _buildingNameController,
        buildingDetailsController: _buildingDetailsController,
        noOfFloorsGPlusController: _noOfFloorsGPlusController,
        noOfFloorsGMinusController: _noOfFloorsGMinusController,
        ageController: _ageController,
        expectedLifePeriodController: _expectedLifePeriodController,
        parkingSpaceController: _parkingSpaceController,
        designController: _designController,
        conveniencesController: _conveniencesController,
        structureController: _structureController,
        selectedBuildingConditions: _selectedBuildingConditions,
        selectedBuildingCategory: _selectedBuildingCategory,
        selectedBuildingClass: _selectedBuildingClass,
        selectedNatureOfConstruction: _selectedNatureOfConstruction,
        selectedRoofMaterial: _selectedRoofMaterial,
        selectedRoofFrame: _selectedRoofFrame,
        selectedRoofFinisher: _selectedRoofFinisher,
        selectedCeiling: _selectedCeiling,
        selectedFoundationStructure: _selectedFoundationStructure,
        selectedWallStructure: _selectedWallStructure,
        selectedFloorStructure: _selectedFloorStructure,
        selectedDoor: _selectedDoor,
        selectedWindow: _selectedWindow,
        selectedWindowProtection: _selectedWindowProtection,
        selectedBathroomToiletDoorsFittings:
            _selectedBathroomToiletDoorsFittings,
        selectedHandRail: _selectedHandRail,
        selectedPantryCupboard: _selectedPantryCupboard,
        selectedOtherDoors: _selectedOtherDoors,
        selectedWallFinisher: _selectedWallFinisher,
        selectedFloorFinisher: _selectedFloorFinisher,
        selectedBathroomToilet: _selectedBathroomToilet,
        selectedServices: _selectedServices,
        selectedBuilding: _selectedBuilding,
        uploadedImages: uploadedImages,
      );

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
  
  // Helper methods for form validation and state management
  bool _isBuildingFormComplete(String buildingId) {
    return _buildingFormCompletionStatus[buildingId] ?? false;
  }

  bool _areAllBuildingFormsComplete() {
    if (_availableBuildings.isEmpty) return true;
    for (Building building in _availableBuildings) {
      if (!_isBuildingFormComplete(building.id)) {
        return false;
      }
    }
    return true;
  }

  bool _isLandInfoComplete() {
    return _landInfoFormKey.currentState?.validate() ?? false;
  }

  bool _isOtherConstructionsComplete() {
    return true; // Optional for now
  }

  bool _isInspectionReportComplete() {
    return _isLandInfoComplete() &&
        _areAllBuildingFormsComplete() &&
        _isOtherConstructionsComplete();
  }

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

  // Global save method for complete inspection report
  void _saveCompleteInspectionReport() async {
    if (!_canSaveInspectionReport()) {
      _showIncompleteSaveMessage();
      return;
    }

    if (_masterFileNo == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Master File number is required to submit the report.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Submitting inspection report...'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 30),
        ),
      );
    }

    // Collect all data from all tabs
    final landInfoData = InspectionFormHelpers.collectLandInfoData(
      masterFileRefController: _masterFileRefController,
      inspectionDateController: _inspectionDateController,
      dsDivisionController: _dsDivisionController,
      districtController: _districtController,
      provinceController: _provinceController,
    );

    final otherConstructionsData =
        InspectionFormHelpers.collectOtherConstructionsData(
      otherInfoController: _otherInfoController,
      otherConstructionDetailsController: _otherConstructionDetailsController,
      assetDetailsController: _assetDetailsController,
      businessDetailsController: _businessDetailsController,
      remarksController: _remarksController,
    );

    // Populate form service with collected data
    await _cubit.populateFormData(
      landInfo: landInfoData,
      buildingForms: _savedBuildingForms,
      otherConstructions: otherConstructionsData,
      masterFileNo: _masterFileNo!,
      lotId: _lotId,
    );

    // Submit the complete inspection report using cubit
    await _cubit.sendInspectionReport(_masterFileNo!);
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

  void _clearBuildingForm() {
    InspectionFormHelpers.clearBuildingForm(
      buildingIdController: _buildingIdController,
      buildingNameController: _buildingNameController,
      buildingDetailsController: _buildingDetailsController,
      noOfFloorsGPlusController: _noOfFloorsGPlusController,
      noOfFloorsGMinusController: _noOfFloorsGMinusController,
      ageController: _ageController,
      expectedLifePeriodController: _expectedLifePeriodController,
      parkingSpaceController: _parkingSpaceController,
      designController: _designController,
      conveniencesController: _conveniencesController,
      structureController: _structureController,
      buildingConditionsController: _buildingConditionsController,
      uploadedImages: uploadedImages,
      onClearDropdowns: () {
        setState(() {
          _selectedBuildingCategory = null;
          _selectedBuildingClass = null;
          _selectedNatureOfConstruction = null;
          _selectedBuildingConditions = null;
          _selectedRoofMaterial = null;
          _selectedRoofFrame = null;
          _selectedRoofFinisher = null;
          _selectedCeiling = null;
          _selectedFoundationStructure = null;
          _selectedWallStructure = null;
          _selectedFloorStructure = null;
          _selectedDoor = null;
          _selectedWindow = null;
          _selectedWindowProtection = null;
          _selectedBathroomToiletDoorsFittings = null;
          _selectedHandRail = null;
          _selectedPantryCupboard = null;
          _selectedOtherDoors = null;
          _selectedWallFinisher = null;
          _selectedFloorFinisher = null;
          _selectedBathroomToilet = null;
          _selectedServices = null;
        });
      },
    );
  }

  void _showSavedReportsDialog() {
    showDialog(
      context: context,
      builder: (context) => const SavedReportsDialog(),
    );
  }

  @override
  Widget buildView(BuildContext context) {
    final String appBarTitle = _masterFileNo != null
        ? "Inspection Report - #$_masterFileNo"
        : "Inspection Report";
    final String masterFileLabel =
        _masterFileNo != null ? "Master File - #$_masterFileNo" : "Master File";
    final String inspectionReportLabel =
        _lotId != null ? "Inspection Report - #$_lotId" : "Inspection Report";

    return BlocListener<InspectionReportCubit,
        BaseState<InspectionReportState>>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is InspectionReportLoading) {
          // Loading state is already handled in _saveCompleteInspectionReport with SnackBar
        } else if (state is InspectionReportSubmitSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inspection report submitted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        } else if (state is InspectionReportSubmitFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Submission failed: ${state.errorMessage}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (state is InspectionReportSavedOffline) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Report saved offline. ${state.pendingCount} reports pending sync.'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
          Navigator.pop(context);
        } else if (state is InspectionReportSyncing) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Syncing ${state.pendingCount} pending reports...'),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is InspectionReportSyncCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All reports synced successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
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
                top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
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
              LandInfoTab(
                formKey: _landInfoFormKey,
                masterFileRefController: _masterFileRefController,
                inspectionDateController: _inspectionDateController,
                dsDivisionController: _dsDivisionController,
                districtController: _districtController,
                provinceController: _provinceController,
                onCancel: () => Navigator.pop(context),
                onSave: _canSaveInspectionReport()
                    ? _saveCompleteInspectionReport
                    : null,
                saveButtonText: _getGlobalSaveButtonText(),
              ),
              BuildingInfoTab(
                buildingsLoaded: _buildingsLoaded,
                availableBuildings: _availableBuildings,
                selectedBuilding: _selectedBuilding,
                onBuildingSelected: (building) {
                  setState(() {
                    _selectedBuilding = building;
                    _buildingIdController.text = building.id;
                    _buildingNameController.text = building.name;
                    // Reset dropdown selections
                    _selectedBuildingCategory = null;
                    _selectedBuildingClass = null;
                    _selectedNatureOfConstruction = null;
                    _selectedBuildingConditions = null;
                  });
                },
                isBuildingFormComplete: _isBuildingFormComplete,
                onGoBack: () => Navigator.pop(context),
                formKey: _buildingInfoFormKey,
                onBackToList: () {
                  setState(() {
                    _selectedBuilding = null;
                    _clearBuildingForm();
                  });
                },
                buildingIdController: _buildingIdController,
                buildingNameController: _buildingNameController,
                buildingDetailsController: _buildingDetailsController,
                noOfFloorsGPlusController: _noOfFloorsGPlusController,
                noOfFloorsGMinusController: _noOfFloorsGMinusController,
                ageController: _ageController,
                expectedLifePeriodController: _expectedLifePeriodController,
                parkingSpaceController: _parkingSpaceController,
                designController: _designController,
                conveniencesController: _conveniencesController,
                structureController: _structureController,
                selectedBuildingCategory: _selectedBuildingCategory,
                selectedBuildingClass: _selectedBuildingClass,
                selectedNatureOfConstruction: _selectedNatureOfConstruction,
                selectedBuildingConditions: _selectedBuildingConditions,
                selectedRoofMaterial: _selectedRoofMaterial,
                selectedRoofFrame: _selectedRoofFrame,
                selectedRoofFinisher: _selectedRoofFinisher,
                selectedCeiling: _selectedCeiling,
                selectedFoundationStructure: _selectedFoundationStructure,
                selectedWallStructure: _selectedWallStructure,
                selectedFloorStructure: _selectedFloorStructure,
                selectedDoor: _selectedDoor,
                selectedWindow: _selectedWindow,
                selectedWindowProtection: _selectedWindowProtection,
                selectedBathroomToiletDoorsFittings:
                    _selectedBathroomToiletDoorsFittings,
                selectedHandRail: _selectedHandRail,
                selectedPantryCupboard: _selectedPantryCupboard,
                selectedOtherDoors: _selectedOtherDoors,
                selectedWallFinisher: _selectedWallFinisher,
                selectedFloorFinisher: _selectedFloorFinisher,
                selectedBathroomToilet: _selectedBathroomToilet,
                selectedServices: _selectedServices,
                onBuildingCategoryChanged: (value) {
                  setState(() {
                    _selectedBuildingCategory = value;
                  });
                  _updateSaveButtonState();
                },
                onBuildingClassChanged: (value) {
                  setState(() {
                    _selectedBuildingClass = value;
                  });
                  _updateSaveButtonState();
                },
                onNatureOfConstructionChanged: (value) {
                  setState(() {
                    _selectedNatureOfConstruction = value;
                  });
                  _updateSaveButtonState();
                },
                onBuildingConditionsChanged: (value) {
                  setState(() {
                    _selectedBuildingConditions = value;
                  });
                  _updateSaveButtonState();
                },
                onRoofMaterialChanged: (value) {
                  setState(() {
                    _selectedRoofMaterial = value;
                  });
                  _updateSaveButtonState();
                },
                onRoofFrameChanged: (value) {
                  setState(() {
                    _selectedRoofFrame = value;
                  });
                  _updateSaveButtonState();
                },
                onRoofFinisherChanged: (value) {
                  setState(() {
                    _selectedRoofFinisher = value;
                  });
                  _updateSaveButtonState();
                },
                onCeilingChanged: (value) {
                  setState(() {
                    _selectedCeiling = value;
                  });
                  _updateSaveButtonState();
                },
                onFoundationStructureChanged: (value) {
                  setState(() {
                    _selectedFoundationStructure = value;
                  });
                  _updateSaveButtonState();
                },
                onWallStructureChanged: (value) {
                  setState(() {
                    _selectedWallStructure = value;
                  });
                  _updateSaveButtonState();
                },
                onFloorStructureChanged: (value) {
                  setState(() {
                    _selectedFloorStructure = value;
                  });
                  _updateSaveButtonState();
                },
                onDoorChanged: (value) {
                  setState(() {
                    _selectedDoor = value;
                  });
                  _updateSaveButtonState();
                },
                onWindowChanged: (value) {
                  setState(() {
                    _selectedWindow = value;
                  });
                  _updateSaveButtonState();
                },
                onWindowProtectionChanged: (value) {
                  setState(() {
                    _selectedWindowProtection = value;
                  });
                  _updateSaveButtonState();
                },
                onBathroomToiletDoorsFittingsChanged: (value) {
                  setState(() {
                    _selectedBathroomToiletDoorsFittings = value;
                  });
                  _updateSaveButtonState();
                },
                onHandRailChanged: (value) {
                  setState(() {
                    _selectedHandRail = value;
                  });
                  _updateSaveButtonState();
                },
                onPantryCupboardChanged: (value) {
                  setState(() {
                    _selectedPantryCupboard = value;
                  });
                  _updateSaveButtonState();
                },
                onOtherDoorsChanged: (value) {
                  setState(() {
                    _selectedOtherDoors = value;
                  });
                  _updateSaveButtonState();
                },
                onWallFinisherChanged: (value) {
                  setState(() {
                    _selectedWallFinisher = value;
                  });
                  _updateSaveButtonState();
                },
                onFloorFinisherChanged: (value) {
                  setState(() {
                    _selectedFloorFinisher = value;
                  });
                  _updateSaveButtonState();
                },
                onBathroomToiletChanged: (value) {
                  setState(() {
                    _selectedBathroomToilet = value;
                  });
                  _updateSaveButtonState();
                },
                onServicesChanged: (value) {
                  setState(() {
                    _selectedServices = value;
                  });
                  _updateSaveButtonState();
                },
                uploadedImages: uploadedImages,
                onImagePicked: _onImagePicked,
                onDeleteImage: _deleteImage,
                onSave: InspectionFormHelpers.isBuildingFormEmpty(
                          buildingDetailsController: _buildingDetailsController,
                          noOfFloorsGPlusController: _noOfFloorsGPlusController,
                          noOfFloorsGMinusController:
                              _noOfFloorsGMinusController,
                          ageController: _ageController,
                          expectedLifePeriodController:
                              _expectedLifePeriodController,
                          structureController: _structureController,
                          parkingSpaceController: _parkingSpaceController,
                          designController: _designController,
                          conveniencesController: _conveniencesController,
                          selectedBuildingCategory: _selectedBuildingCategory,
                          selectedBuildingClass: _selectedBuildingClass,
                          selectedNatureOfConstruction:
                              _selectedNatureOfConstruction,
                          selectedBuildingConditions:
                              _selectedBuildingConditions,
                          uploadedImages: uploadedImages,
                        ) ||
                        InspectionFormHelpers.isBuildingFormPartiallyFilled(
                          noOfFloorsGPlusController: _noOfFloorsGPlusController,
                          noOfFloorsGMinusController:
                              _noOfFloorsGMinusController,
                          ageController: _ageController,
                          expectedLifePeriodController:
                              _expectedLifePeriodController,
                          structureController: _structureController,
                          selectedBuildingCategory: _selectedBuildingCategory,
                          selectedBuildingClass: _selectedBuildingClass,
                          selectedNatureOfConstruction:
                              _selectedNatureOfConstruction,
                          selectedBuildingConditions:
                              _selectedBuildingConditions,
                        )
                    ? null
                    : _validateAndSaveLocally,
                saveButtonText: InspectionFormHelpers.getSaveButtonText(
                  isEmpty: InspectionFormHelpers.isBuildingFormEmpty(
                    buildingDetailsController: _buildingDetailsController,
                    noOfFloorsGPlusController: _noOfFloorsGPlusController,
                    noOfFloorsGMinusController: _noOfFloorsGMinusController,
                    ageController: _ageController,
                    expectedLifePeriodController: _expectedLifePeriodController,
                    structureController: _structureController,
                    parkingSpaceController: _parkingSpaceController,
                    designController: _designController,
                    conveniencesController: _conveniencesController,
                    selectedBuildingCategory: _selectedBuildingCategory,
                    selectedBuildingClass: _selectedBuildingClass,
                    selectedNatureOfConstruction: _selectedNatureOfConstruction,
                    selectedBuildingConditions: _selectedBuildingConditions,
                    uploadedImages: uploadedImages,
                  ),
                  isPartiallyFilled:
                      InspectionFormHelpers.isBuildingFormPartiallyFilled(
                    noOfFloorsGPlusController: _noOfFloorsGPlusController,
                    noOfFloorsGMinusController: _noOfFloorsGMinusController,
                    ageController: _ageController,
                    expectedLifePeriodController: _expectedLifePeriodController,
                    structureController: _structureController,
                    selectedBuildingCategory: _selectedBuildingCategory,
                    selectedBuildingClass: _selectedBuildingClass,
                    selectedNatureOfConstruction: _selectedNatureOfConstruction,
                    selectedBuildingConditions: _selectedBuildingConditions,
                  ),
                  defaultText: AppString.save.localize(context) ?? 'Save Data',
                ),
                onCancel: () => Navigator.pop(context),
              ),
              OtherConstructionsTab(
                formKey: _otherConstructionsFormKey,
                otherInfoController: _otherInfoController,
                otherConstructionDetailsController:
                    _otherConstructionDetailsController,
                assetDetailsController: _assetDetailsController,
                businessDetailsController: _businessDetailsController,
                remarksController: _remarksController,
                onCancel: () => Navigator.pop(context),
                onSave: _canSaveInspectionReport()
                    ? _saveCompleteInspectionReport
                    : null,
                saveButtonText: _getGlobalSaveButtonText(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
