class InspectionDropdownOptions {
  // Building category options
  static List<String> getBuildingCategoryOptions() {
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

  // Building class options
  static List<String> getBuildingClassOptions() {
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

  // Nature of construction options
  static List<String> getNatureOfConstructionOptions() {
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

  // Building conditions options
  static List<String> getBuildingConditionsOptions() {
    return ["Sel", "V.Good", "Good", "Faire+", "Faire-", "Poor", "V,Poor"];
  }

  // Roof material options
  static List<String> getRoofMaterialOptions() {
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

  // Roof frame options
  static List<String> getRoofFrameOptions() {
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

  // Roof finisher options
  static List<String> getRoofFinisherOptions() {
    return [
      "Valance board - Wooden calss 1 or 2",
      "Gutters-Aluminum",
      "Downpipes-Aluminum",
      "Valance boards - Aluminum",
      "Downpipes-Plastic"
    ];
  }

  // Ceiling options
  static List<String> getCeilingOptions() {
    return [
      "Timber Plank",
      "Decorative timber plank",
      "Detail celling",
      "Asb Exposed rafter"
    ];
  }

  // Foundation structure options
  static List<String> getFoundationStructureOptions() {
    return [
      "RCC",
      "Pile",
      "Mini plie",
      "Random rubble with Rcc Column and beam"
    ];
  }

  // Wall structure options
  static List<String> getWallStructureOptions() {
    return [
      "Columns with 9\" brick all 9\"",
      "Brick 9\"",
      "Glass",
      "Cement hollow block"
    ];
  }

  // Floor structure options
  static List<String> getFloorStructureOptions() {
    return ["RCC Concrete", "Concrete", "Brick"];
  }

  // Door options
  static List<String> getDoorOptions() {
    return ["Timber panel with timber frame", "Iron Roller shutter"];
  }

  // Window options
  static List<String> getWindowOptions() {
    return ["Timber panel with timber frame", "Glazed with timber frame"];
  }

  // Window protection options
  static List<String> getWindowProtectionOptions() {
    return ["Stainless Steel", "Iron Drill", "Iron rode"];
  }

  // Bathroom and toilet fittings options
  static List<String> getDoorsBathroomAndToiletFittingsOptions() {
    return [
      "Full furnished bath room with class 1 fittings -Unit",
      "Full furnished bath room with class 2-3 fittings  Unit"
    ];
  }

  // Hand rail options
  static List<String> getDoorsHandRailOptions() {
    return ["Wooden- Class 01 unit", "Wooden landing- Class 01 unit"];
  }

  // Pantry cupboard options
  static List<String> getDoorsPantryCupboardOptions() {
    return ["Wooden pantry cupboard class 1 unit", "Aluminum unit"];
  }

  // Other doors options
  static List<String> getDoorsOtherOptions() {
    return ["Air conditions-central unit", "Sola panel- unit"];
  }

  // Wall finisher options
  static List<String> getWallFinisherOptions() {
    return ["Tiled", "Wall Papers"];
  }

  // Floor finisher options
  static List<String> getFloorFinisherOptions() {
    return ["Granite", "Terrazzo"];
  }

  // Bathroom and toilet options
  static List<String> getBathroomAndToiletOptions() {
    return [" tile Grade A- Floor+Wall", "Tile Class 2- Floor+Wall"];
  }

  // Services options
  static List<String> getServicesOptions() {
    return ["Three phase electricity", "Additional transformer"];
  }
}
