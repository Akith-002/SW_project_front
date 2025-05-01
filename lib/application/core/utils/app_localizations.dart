import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  static const String _languageKey = 'preferred_language';
  static const String _defaultLanguage = 'en';

  LanguageNotifier() : super(const Locale(_defaultLanguage, 'US')) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? _defaultLanguage;

      if (_AppLocalizationsDelegate.supportedLanguages.contains(languageCode)) {
        state = Locale(languageCode);
      } else {
        state = const Locale(_defaultLanguage);
      }
    } catch (e) {
      // Fallback to default language if loading fails
      state = const Locale(_defaultLanguage);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      state = Locale(languageCode);
    } catch (e) {
      // Optional: Add logging or error handling
      debugPrint('Failed to change language: $e');
    }
  }
}

class AppLocalizations {
  final Locale locale;

  // Cached localizations to improve performance
  static final Map<String, Map<String, String>> _cachedLocalizations = {};

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    debugPrint("Loading localization for ${locale.languageCode}");
    // Check if localization is already cached
    if (_cachedLocalizations.containsKey(locale.languageCode)) {
      _localizedStrings = _cachedLocalizations[locale.languageCode]!;
      return true;
    }

    try {
      // Load the language JSON file from the "locales" folder
      String jsonString =
          await rootBundle.loadString('locales/${locale.languageCode}.json');

      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Convert and cache the localization
      _localizedStrings =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
      _cachedLocalizations[locale.languageCode] = _localizedStrings;

      return true;
    } catch (e) {
      // Fallback to default language if loading fails
      return false;
    }
  }

  // Null-safe translation method
  String? translate(String? key) {
    if (key == null) return null;
    return _localizedStrings[key] ?? key;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  // Supported language codes
  static const supportedLanguages = ['en', 'si', 'ta'];

  @override
  bool isSupported(Locale locale) {
    return supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizeString on String {
  String? localize(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this);
  }
}
