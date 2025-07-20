import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/pages/splash/cubit/splash_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

/// Splash screen that displays when the app starts
/// Shows the Valuation Department logo and name before navigating to sign-in
class SplashView extends BasePage {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends BasePageState<SplashView> {
  final _cubit = injection<SplashCubit>();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      context.go(Pages.routeSignIn.toPath());
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Department logo
            Image.asset(
              "images/pngs/VD_Logo.png",
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            // Department name
            Text(
              AppString.valuationDepartment.localize(context)!,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
