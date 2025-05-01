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
  static const routeRentalEvidence = "rentalevidence";
  static const routeI2RentalEvidence = "i2rentalevidence";
  static const routeMapScreen = "routemap";
  static const routeSettingsScreen = "settings";
  static const routePastValuation = "past-valuation";
  static const routeInspectionReport = "inspection-report";
  static const routeSketchTool = "sketch-tool";
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
