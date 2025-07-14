import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/services/text_scale_factor.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/app_theme_provider.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_localizations.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/pages/settingsScreen/cubit/settings_screen_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

/// Settings screen for managing app preferences including theme, language, and font size
class SettingsScreen extends BasePage {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BasePageState<SettingsScreen> {
  final _cubit = injection<SettingsScreenCubit>();

  late AppThemeMode _themeMode;
  late TextScaleFactorModel _textScaleFactorModel;

  /// Available languages with their display names and locale codes
  final Map<String, String> _languages = {
    "English": "en",
    "Sinhala": "si",
    "Tamil": "ta"
  };

  @override
  void initState() {
    super.initState();
    _textScaleFactorModel = context.read<TextScaleFactorModel>();
  }

  @override
  Widget buildView(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      _themeMode = ref.watch(appThemeProvider);
      
      // Debug print to check theme
      print('Current theme mode: $_themeMode');
      print('Current brightness: ${Theme.of(context).brightness}');

      // Get current language and find display name
      final currentLocale = ref.watch(languageProvider);
      final currentLanguage = _languages.entries
          .firstWhere(
            (element) => element.value == currentLocale.languageCode,
            orElse: () => MapEntry("English", "en"),
          )
          .key;

      return Scaffold(
        appBar: CustomAppBar(
          title: AppString.settings.l10n(context)!,
          style: AppStyling.semiBoldTextSize14
              .copyWith(color: colors(context).colorGrey6),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF021526)
            : colors(context).colorWhite,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings header section
              Text(
                AppString.generalSettings.l10n(context)!,
                style: AppStyling.semiBoldTextSize16
                    .copyWith(color: colors(context).colorBlack),
              ),
              SizedBox(height: 4),
              Text(
                AppString.changeTheSettingsOfTheMobileApp.l10n(context)!,
                style: AppStyling.normalTextSize12
                    .copyWith(color: colors(context).colorGrey8),
              ),
              SizedBox(height: 16),

              // Divider line
              Container(
                height: 2,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF03346E)
                    : colors(context).colorGrey9,
              ),
              SizedBox(height: 16),

              // Settings content
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Appearance Section
                    Text(
                      AppString.appAppearance.l10n(context)!,
                      style: AppStyling.semiBoldTextSize14
                          .copyWith(color: colors(context).colorBlack),
                    ),
                    SizedBox(height: 16),

                    // Theme selection radio buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Light mode option
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<AppThemeMode>(
                                    value: AppThemeMode.light,
                                    groupValue: _themeMode,
                                    activeColor: Theme.of(context).brightness == Brightness.dark
                                        ? Color(0xFF6EACDA)
                                        : colors(context).colorPrimary1,
                                    fillColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Theme.of(context).brightness == Brightness.dark
                                            ? Color(0xFF6EACDA)
                                            : colors(context).colorPrimary1;
                                      }
                                      return Theme.of(context).brightness == Brightness.dark
                                          ? Color(0xFF9CADBF)
                                          : colors(context).colorGrey4;
                                    }),
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(appThemeProvider.notifier)
                                            .state = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    AppString.lightMode.l10n(context)!,
                                    style: AppStyling.normalTextSize14
                                        .copyWith(color: colors(context).colorBlack),
                                  ),
                                ],
                              ),
                            ),
                            // Dark mode option
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<AppThemeMode>(
                                    value: AppThemeMode.dark,
                                    groupValue: _themeMode,
                                    activeColor: Theme.of(context).brightness == Brightness.dark
                                        ? Color(0xFF6EACDA)
                                        : colors(context).colorPrimary1,
                                    fillColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Theme.of(context).brightness == Brightness.dark
                                            ? Color(0xFF6EACDA)
                                            : colors(context).colorPrimary1;
                                      }
                                      return Theme.of(context).brightness == Brightness.dark
                                          ? Color(0xFF9CADBF)
                                          : colors(context).colorGrey4;
                                    }),
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(appThemeProvider.notifier)
                                            .state = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    AppString.darkMode.l10n(context)!,
                                    style: AppStyling.normalTextSize14
                                        .copyWith(color: colors(context).colorBlack),
                                  ),
                                ],
                              ),
                            ),
                            // System preference option
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<AppThemeMode>(
                                    value: AppThemeMode.system,
                                    groupValue: _themeMode,
                                    activeColor: Theme.of(context).brightness == Brightness.dark
                                        ? Color(0xFF6EACDA)
                                        : colors(context).colorPrimary1,
                                    fillColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Theme.of(context).brightness == Brightness.dark
                                            ? Color(0xFF6EACDA)
                                            : colors(context).colorPrimary1;
                                      }
                                      return Theme.of(context).brightness == Brightness.dark
                                          ? Color(0xFF9CADBF)
                                          : colors(context).colorGrey4;
                                    }),
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(appThemeProvider.notifier)
                                            .state = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    AppString.systemPreferences
                                        .l10n(context)!,
                                    style: AppStyling.normalTextSize14
                                        .copyWith(color: colors(context).colorBlack),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomDropdownField(
                        items: _languages.keys.toList(),
                        initialValue: currentLanguage,
                        onChanged: (value) {
                          setState(() {
                            ref
                                .read(languageProvider.notifier)
                                .changeLanguage(_languages[value]!);
                          });
                        },
                        width: 322,
                        label: AppString.language.l10n(context)!,
                        required: false,
                      ),
                    ),
                    SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomDropdownField(
                        items: [
                          AppString.small.l10n(context)!,
                          AppString.medium.l10n(context)!,
                          AppString.large.l10n(context)!,
                        ],
                        initialValue: AppString.large.l10n(context)!,
                        onChanged: (value) {
                          // Map font size selection to scale factor
                          double scaleFactor;
                          // Check against the localized values
                          if (value == AppString.small.l10n(context)!) {
                            scaleFactor = 0.7;
                          } else if (value == AppString.medium.l10n(context)!) {
                            scaleFactor = 0.9;
                          } else if (value == AppString.large.l10n(context)!) {
                            scaleFactor = 1.0;
                          } else {
                            scaleFactor = 1.0;
                          }
                          _textScaleFactorModel.setTextScaleFactor(scaleFactor);
                        },
                        width: 322,
                        label: AppString.fontSize.l10n(context)!,
                        required: false,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Save button (currently no-op)
              CustomButton(
                text: AppString.save.l10n(context)!,
                onPressed: () {},
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF6EACDA)
                    : colors(context).colorPrimary5!,
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
