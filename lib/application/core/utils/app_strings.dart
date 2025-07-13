import 'package:flutter/cupertino.dart';
import 'package:land_asset_valuation/application/core/utils/app_localizations.dart';

// Export the localization extension so it's available wherever AppString is imported
export 'package:land_asset_valuation/application/core/utils/app_localizations.dart' show LocalizeString;

class AppString {
  /// **General**
  static const String welcome = "welcome";
  static const String save = "save";
  static const String saveAs = "save_as";
  static const String open = "open";
  static const String openNew = "new";
  static const String sendData = "send_data";
  static const String success = "success";
  static const String rejected = "rejected";
  static const String reject = "reject";
  static const String cancel = "cancel";
  static const String approved = "approved";
  static const String approve = "approve";
  static const String pending = "pending";
  static const String close = "close";
  static const String delete_q = "delete_q";
  static const String delete = "delete";

  /// **Sketch Tools**
  static const String sketchTool = "sketch_tools";
  static const String polygon = "polygon";
  static const String line = "line";
  static const String circle = "circle";
  static const String text = "text";
  static const String partition = "partition";
  static const String graph = "graph";
  static const String report = "report";
  static const String move = "move";
  static const String ruler = "ruler";
  static const String image = "image";
  static const String draw_selection_layer = "draw_selection_layer";
  static const String draw_measured_selection_layer =
      "draw_measured_selection_layer";
  static const String clear_selection_layer = "clear_selection_layer";
  static const String add_marker = "add_marker";

  /// **Map Layers**
  static const String at_map = "at_map";
  static const String pp_map = "pp_map";
  static const String zoning_layer = "zoning_layer";
  static const String data_layer = "data_layer";

  /// **Authentication & Navigation**
  static const String landMiscellaneous = "landMiscellaneous";
  static const String login = "login";
  static const String forgotPassword = "forgot_password";
  static const String username = "username";
  static const String password = "password";
  static const String loginFooter = "login_footer";
  static const String all_files = "all_files";
  static const String search = "search";
  static const String advanced = "advanced";
  static const String dashboard = "dashboard";
  static const String landAcquisition = "landAcquisition";
  static const String massRatingMR = "massRatingMR";
  static const String massRating = "massRating";
  static const String ratingAssessmentRA = "ratingAssessmentRA";
  static const String ratingAssessment = "ratingAssessment";
  static const String ratingBuildingRB = "ratingBuildingRB";
  static const String ratingBuilding = "ratingBuilding";
  static const String ratingObjectRO = "ratingObjectRO";
  static const String ratingObject = "ratingObject";
  static const String mrRentalEvidence = "mrRentalEvidence";

  /// **Land Info Form**
  static const String landInfo = "land_info";
  static const String nameOfVillage = "name_of_village";
  static const String nameOfLand = "name_of_land";
  static const String atPlanNumber = "at_plan_number";
  static const String atLotNumber = "at_lot_number";
  static const String ppCadNumber = "pp_cad_number";
  static const String ppCadLotNumber = "pp_cad_lot_number";
  static const String acquiredExtent = "acquired_extent";
  static const String assessmentNumber = "assessmentNumber";
  static const String roadName = "road_name";
  static const String accessCategory = "access_category";
  static const String accessCategoryDescription = "access_category_description";
  static const String descriptionOfLand = "description_of_land";
  static const String situation = "situation";
  static const String addPr = "add_pr";
  static const String landUseDescription = "land_use_description";
  static const String landUseType = "land_use_type";
  static const String frontageFeet = "frontage_feet";
  static const String depthOfLandFeet = "depth_of_land_feet";
  static const String levelWithAccess = "level_with_access";
  static const String plantationDetails = "plantation_details";
  static const String detailsOfBusiness = "details_of_business";
  static const String acquisitionName = "acquisition_name";
  static const String dateOfPrepared = "date_of_prepared";
  static const String dateOfSection3BA = "date_of_section_3ba";
  static const String date = "date";

  /// **Boundaries**
  static const String boundaries = "boundaries";
  static const String north = "north";
  static const String east = "east";
  static const String west = "west";
  static const String south = "south";
  static const String bottom = "bottom";

  /// **Building Info & Other Constructions**
  static const String buildingInfo = "building_info";
  static const String otherConstructions = "other_constructions";
  static const String buildingDescription = "building_description";
  static const String buildingName = "building_name";
  static const String constructionName = "construction_name";

  /// **Signatures Form**
  static const String signatures = "signatures";
  static const String acquiringOfficer = "acquiring_officer";
  static const String gramaSeveka = "grama_seveka";
  static const String chiefValuersRepresentative =
      "chief_valuers_representative";
  static const String clear = "clear";
  static const String submit = "submit";

  /// **Rating Card Form**
  static const String selectBuilding = "select_building";
  static const String localAuthority = "local_authority";
  static const String localAuthorityCode = "local_authority_code";
  static const String newNumber = "new_number";
  static const String obsoleteNumber = "obsolete_number";
  static const String owner = "owner";
  static const String description = "description";
  static const String selectWalls = "select_walls";
  static const String floor = "floor";
  static const String conveniences = "conveniences";
  static const String condition = "condition";
  static const String age = "age";
  static const String access = "access";
  static const String tsBop = "ts_bop";
  static const String parkingSpace = "parking_space";
  static const String propertySubCategory = "property_sub_category";
  static const String propertyType = "property_type";
  static const String wardNumber = "ward_number";
  static const String roadStreetNumber = "road_street_number";
  static const String occupier = "occupier";
  static const String rentPM = "rent_pm";
  static const String terms = "terms";
  static const String topicFloorwiseArea = "topic_floorwise_area";
  static const String building = "building";
  static const String totalArea = "total_area";
  static const String totalFloorArea = "total_floor_area";
  static const String suggestedRate = "suggested_rate";
  static const String notes = "notes";
  static const String send = "send";

  /// **Land Acquisition Sales Evidence**
  static const String salesEvidencesForm = "salesEvidencesForm";
  static const String masterFile = "masterFile";
  static const String salesEvidences = "salesEvidences";
  static const String assetNumber = "assetNumber";
  static const String masterFilerefno = "masterFilerefno";
  static const String road = "road";
  static const String village = "village";
  static const String vendor = "vendor";
  static const String deedNumber = "deedNumber";
  static const String floorRate = "floorRate";
  static const String deedAttestedNumber = "deedAttestedNumber";
  static const String notaryName = "notaryName";
  static const String lotNumber = "lotNumber";
  static const String noofLotNumbergiven = "noofLotNumbergiven";
  static const String planNumber = "planNumber";
  static const String planDate = "planDate";
  static const String extent = "extent";
  static const String consideration = "consideration";
  static const String remarks = "remarks";
  static const String rate = "rate";
  static const String rateType = "rateType";
  static const String selectRateType = "selectRateType";
  static const String locationLongitude = "locationLongitude";
  static const String locationLatitude = "locationLatitude";
  static const String landRegistryReferences = "landRegistryReferences";
  static const String landRegistryReferencesDescription =
      "landRegistryReferencesDescription";

  // Land Acquisition Building Rates
  static const String buildingratesform = "buildingratesform";
  static const String buidlingRates = "buidlingRates";
  static const String buildingRatesForm = "buildingRatesForm";
  static const String buildingRates = "buildingRates";
  static const String nameOfTheOwner = "nameOfTheOwner";
  static const String constructedBy = "constructedBy";
  static const String yearofConstruction = "yearofConstruction";
  static const String descriptionofProperty = "descriptionofProperty";
  static const String propertyDescription = "propertyDescription";
  static const String floorAreaSQFT = "floorAreaSQFT";
  static const String ratePerSQFT = "ratePerSQFT";
  static const String cost = "cost";

  // MR Assets List
  static const String request = "request";
  static const String allAssets = "allAssets";
  static const String decisions = "decisions";
  static const String edit = "edit";
  static const String rentalEvidence = "rental_evidence";
  static const String rentalEvidenceForm = "rental_evidence_form";

  static const String uploadImgs = "upload_imgs";
  static const String assesmentNo = "assesment_no";
  static const String assesmentNoPlaceholder = "assesment_no_placeholder";
  static const String masterFileRefNo = "master_file_ref_no";
  static const String masterFileRefNoPlaceholder =
      "master_file_ref_no_placeholder";

  static const String floorRatePlaceholder = "floor_rate_placeholder";
  static const String ratePerSqft = "rate_per_sqft";
  static const String ratePerMonth = "rate_per_month";
  static const String locationLongitudePlaceholder =
      "location_longitude_placeholder";
  static const String locationLatitudePlaceholder =
      "location_latitude_placeholder";
  static const String headOfTerms = "head_of_terms";

  static const String selectPropertyCategory = "select_property_category";
  static const String selectPropertySubcategory = "select_property_subcategory";
  static const String selectPropertyType = "select_property_type";
  static const String propertyCategory = "property_category";
  static const String propertySubcategory = "property_subcategory";

  static const String building1 = "building_1";
  static const String building2 = "building_2";
  static const String category1 = "category_1";
  static const String category2 = "category_2";
  static const String subcategory1 = "subcategory_1";
  static const String subcategory2 = "subcategory_2";
  static const String type1 = "type_1";
  static const String type2 = "type_2";
  static const String typeA = "type_a";
  static const String typeB = "type_b";
  static const String imageCapturing = "image_capturing";
  static const String descriptionOfProperty = "description_of_property";
  static const String ownerName = "owner_name";
  static const String occupierName = "occupier_name";

  /// **Past Valuation Form**
  static const String pastValuationForm = "past_valuation_form";
  static const String fileNoGnDivision = "file_no_gn_division";
  static const String dateOfValuation = "date_of_valuation";
  static const String purposeOfValuation = "purpose_of_valuation";
  static const String planOfParticulars = "plan_of_particulars";
  static const String imageCapturingUpload = "image_capturing_upload";
  static const String addNewImage = "add_new_image";

  /// **App Bar Drop Down**
  static const String profile = "profile";
  static const String settings = "settings";
  static const String logOut = "log_out";

  /// **Inspection Report Form**
  static const String buildingInformation = "building_information";
  static const String buildingId = "building_id";
  static const String buildingCategory = "building_category";
  static const String buildingClass = "building_class";
  static const String detailOfBuilding = "detail_of_building";
  static const String noOfFloorsGPlus = "no_of_floors_g_plus";
  static const String noOfFloorsGMinus = "no_of_floors_g_minus";
  static const String ageYears = "age_years";
  static const String expectedLifePeriod = "expected_life_period";
  static const String design = "design";
  static const String structure = "structure";
  static const String buildingConditions = "building_conditions";
  static const String natureOfConstruction = "nature_of_construction";

  /// **Roof Details**
  static const String roofDetails = "roof_details";
  static const String roofMaterial = "roof_material";
  static const String roofFrame = "roof_frame";
  static const String roofFinisher = "roof_finisher";
  static const String ceiling = "ceiling";

  /// **Structure Details**
  static const String structureDetails = "structure_details";
  static const String foundationStructure = "foundation_structure";
  static const String wallStructure = "wall_structure";
  static const String floorStructure = "floor_structure";

  /// **Fixed and Fitting Details**
  static const String fixedAndFittingDetails = "fixed_and_fitting_details";
  static const String door = "door";
  static const String window = "window";
  static const String windowProtection = "window_protection";
  static const String doorsBathroomToiletFittings =
      "doors_bathroom_toilet_fittings";
  static const String doorsHandRail = "doors_hand_rail";
  static const String doorsPantryCupboard = "doors_pantry_cupboard";
  static const String doorsOther = "doors_other";

  /// **Finishers / Service Details**
  static const String finishersServiceDetails = "finishers_service_details";
  static const String wallFinisher = "wall_finisher";
  static const String floorFinisher = "floor_finisher";
  static const String bathroomToilet = "bathroom_toilet";
  static const String services = "services";
  static const String addOwner = "add_owner";

  // settings screen
  static const String generalSettings = "generalSettings";
  static const String changeTheSettingsOfTheMobileApp =
      "change_the_settings_of_the_mobile_app";
  static const String appAppearance = "app_appearance";
  static const String lightMode = "light_mode";
  static const String darkMode = "dark_mode";
  static const String systemPreferences = "system_preferences";
  static const String language = "language";
  static const String english = "english";
  static const String sinhala = "sinhala";
  static const String tamil = "tamil";
  static const String fontSize = "font_size";
  static const String small = "small";
  static const String medium = "medium";
  static const String large = "large";

  static const String saveLotId = "save_lot_id";
  static const String searchEllipsis = "search_ellipsis";
  static const String saveLot = "save_lot";
  static const String lotId = "lot_id";
  static const String selectLotId = "select_lot_id";

  /// **Profile Screen**
  static const String myActivities = "my_activities";
  static const String johnDoe = "john_doe";
  static const String email = "johndoe@valdept.com";
  static const String employeeId = "employee_id";
  static const String assignedDivision = "assigned_division";
  static const String position = "position";
  static const String adv = "adv";
  static const String overview = "overview";
  static const String id = "#12345";
  static const String pending1 = "pending";
  static const String completed = "completed";
  static const String kollupitiya = "kollupitiya";
  static const String totalActivities = "total_activities";

  static const String drawPolygon = "draw_polygon";
  static const String feet = "feet";
  static const String inches = "inches";
  static const String valuationDepartment = "valuation_department";
  static const String selectTool = "select_tool";

  static const String floors = "floors";
  static const String addFloor = "add_floor";
  static const String add = "add";
  static const String floorName = "floor_name";
  static const String above = "above";
  static const String below = "below";
}
