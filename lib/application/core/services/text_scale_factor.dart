import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Adjust the import according to your project structure

class TextScaleFactorModel with ChangeNotifier {
  static const String _fontSizeKey = AppConstants.FONT_SIZE;
  double _textScaleFactor = 1;
  // small 0.7 medium 0.9 large 1.0

  TextScaleFactorModel() {
    _loadTextScaleFactor();
  }

  double get textScaleFactor => _textScaleFactor;

  Future<void> _loadTextScaleFactor() async {
    final prefs = await SharedPreferences.getInstance();
    _textScaleFactor = prefs.getDouble(_fontSizeKey) ?? 1;
    notifyListeners();
  }

  Future<void> setTextScaleFactor(double newScale) async {
    _textScaleFactor = newScale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, newScale);
    notifyListeners();
  }
}
