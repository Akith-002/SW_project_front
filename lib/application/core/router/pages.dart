class Pages {
  static const routeSplash = "splash";
  static const routeSignIn = "signin";
  static const routeDashboard = "dashboard";
  static const routeI3MasterFileList = "i3masterfilelist";
  static const routeProfileScreen = "profilescreen";
  static const routeConditionReport = "condition-report";
  static const routeRatingCardReport = "rating-card-report";
  static const routeLaSalesEvidence = "la-sales-evidence";
  static const routeLaBuildingRates = "la-building-rates";
  static const routeMrAssetsList = "mr-assets-list";
  static const routeRaAssetsList = "ra-assets-list";
  static const routeRbAssetsList = "rb-assets-list";
  static const routeRoAssetsList = "ro-assets-list";
  static const routeRentalEvidence = "rentalevidence";
  static const routeI2RentalEvidence = "i2rentalevidence";
  static const routeMapScreen = "routemap";
  static const routeAssetMapScreen = "asset-map-screen";
  static const routeSettingsScreen = "settings";
  static const routePastValuation = "past-valuation";
  static const routeInspectionReport = "inspection-report";
  static const routeSketchTool = "sketch-tool";
  static const routeLmMasterfileList = "lm-masterfile-list";

  // Rating Card Forms
  static const routeDomesticRatingCard = "domestic-rating-card";
  static const routeOfficesRatingCard = "offices-rating-card";
  static const routeAgricultureRatingCard = "agriculture-rating-card";
  static const routeShopsRatingCard = "shops-rating-card";
  static const routeSpecialRatingCard = "special-rating-card";
  static const routeTest = "test";
}

extension PagesExtension on String {
  String toPath(
      {bool isSubRoute = false, String? pathParam, String? pathPrefix}) {
    String path = this;
    if (pathPrefix != null && pathPrefix.isNotEmpty) {
      final prefix = pathPrefix.startsWith('/') ? pathPrefix : '/$pathPrefix';
      path = '$prefix/$path';
    } else {
      path = '/$path';
    }
    if (pathParam != null && pathParam.isNotEmpty) {
      final param = pathParam.startsWith(':') ? pathParam : ':$pathParam';
      path = '$path/$param';
    }
    if (isSubRoute) {
      path = path.replaceFirst('/', '');
    }
    return path;
  }

  String toPathName() {
    return replaceFirst('/', '').toUpperCase();
  }
}
