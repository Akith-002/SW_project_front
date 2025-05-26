import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:land_asset_valuation/application/core/router/routes.dart';
import 'package:land_asset_valuation/application/core/services/text_scale_factor.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/app_theme_provider.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_constants.dart';
import 'package:land_asset_valuation/application/core/utils/app_localizations.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VD extends ConsumerStatefulWidget {
  const VD({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VDState();
}

class _VDState extends ConsumerState {
  final AppRouter routerServices = injection<AppRouter>();
  final AppSharedData appSharedData = injection<AppSharedData>();

  @override
  void initState() {
    super.initState();
  }

  ThemeMode getThemeMode(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor =
        context.watch<TextScaleFactorModel>().textScaleFactor;
    final themeMode = ref.watch(appThemeProvider);
    final locale = ref.watch(languageProvider);

    return Sizer(builder: (BuildContext, Orientation, ScreenType) {
      return MaterialApp.router(
          theme: getAppTheme(context, false),
          darkTheme: getAppTheme(context, true),
          themeMode: getThemeMode(themeMode),
          builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScaleFactor)),
                child: child!,
              ),

          // theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme,
          routerConfig: routerServices.router,
          supportedLocales: const [
            Locale(kLocaleEN, "US"),
            Locale(kLocaleSI, "LK"),
            Locale(kLocaleTA, "TA")
          ],
          locale: locale,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ]);
    });
  }
}
