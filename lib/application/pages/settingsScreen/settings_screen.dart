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

class SettingsScreen extends BasePage {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BasePageState<SettingsScreen> {
  final _cubit = injection<SettingsScreenCubit>();

  late AppThemeMode _themeMode;
  late TextScaleFactorModel _textScaleFactorModel;

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

      final currentLocale = ref.watch(languageProvider);

      final currentLanguage = _languages.entries
          .firstWhere(
            (element) => element.value == currentLocale.languageCode,
            orElse: () => MapEntry("English", "en"),
          )
          .key;

      return Scaffold(
        appBar: CustomAppBar(
          title: AppString.settings.localize(context)!,
           style: AppStyling.semiBoldTextSize14
                        .copyWith(color: colors(context).colorGrey6), // Provide the required style argument
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.generalSettings.localize(context)!,
                style: AppStyling.semiBoldTextSize16
                    .copyWith(color: colors(context).colorBlack),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                AppString.changeTheSettingsOfTheMobileApp.localize(context)!,
                style: AppStyling.normalTextSize12
                    .copyWith(color: colors(context).colorGrey8),
              ),
              SizedBox(
                height: 16,
              ),
              // grey horizontal line
              Container(
                height: 2,
                color: colors(context).colorGrey9,
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.appAppearance.localize(context)!,
                      style: AppStyling.semiBoldTextSize14
                          .copyWith(color: colors(context).colorBlack),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<AppThemeMode>(
                                    value: AppThemeMode.light,
                                    groupValue: _themeMode,
                                    activeColor: colors(context).colorPrimary1,
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(appThemeProvider.notifier)
                                            .state = value!;
                                      });
                                    },
                                  ),
                                  Text(AppString.lightMode.localize(context)!),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<AppThemeMode>(
                                    value: AppThemeMode.dark,
                                    groupValue: _themeMode,
                                    activeColor: colors(context).colorPrimary1,
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(appThemeProvider.notifier)
                                            .state = value!;
                                      });
                                    },
                                  ),
                                  Text(AppString.darkMode.localize(context)!),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<AppThemeMode>(
                                    value: AppThemeMode.system,
                                    groupValue: _themeMode,
                                    activeColor: colors(context).colorPrimary1,
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(appThemeProvider.notifier)
                                            .state = value!;
                                      });
                                    },
                                  ),
                                  Text(AppString.systemPreferences
                                      .localize(context)!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppString.language.localize(context)!,
                      style: AppStyling.semiBoldTextSize14
                          .copyWith(color: colors(context).colorBlack),
                    ),
                    SizedBox(
                      height: 16,
                    ),
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
                        width: 322, label: '',
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppString.fontSize.localize(context)!,
                      style: AppStyling.semiBoldTextSize14
                          .copyWith(color: colors(context).colorBlack),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomDropdownField(
                        items: [
                          AppString.small.localize(context)!,
                          AppString.medium.localize(context)!,
                          AppString.large.localize(context)!,
                        ],
                        initialValue: AppString.large.localize(context)!,
                        onChanged: (value) {
                          double scaleFactor;
                          switch (value) {
                            case "Small":
                              scaleFactor = 0.7;
                              break;
                            case "Medium":
                              scaleFactor = 0.9;
                              break;
                            case "Large":
                              scaleFactor = 1.0;
                              break;
                            default:
                              scaleFactor = 1.0;
                          }
                          _textScaleFactorModel.setTextScaleFactor(scaleFactor);
                        },
                        width: 322, label: '',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                text: AppString.save.localize(context)!,
                onPressed: () {},
                backgroundColor: colors(context).colorPrimary5!,
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
