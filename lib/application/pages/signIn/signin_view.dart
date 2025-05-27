import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/signIn/widgets/form_section.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/application/pages/signIn/widgets/login_footer.dart';
import 'package:land_asset_valuation/application/pages/signIn/cubit/signin_cubit.dart';

// SignInView is a stateless widget representing the sign in view in the app.
// It extends from BasePage for consistency across views.
class SignInView extends BasePage {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

// _SignInViewState holds the state for SignInView.
// It extends BasePageState to integrate with the base cubit and view structure.
class _SignInViewState extends BasePageState<SignInView> {
  // Using dependency injection to create an instance of SigninCubit.
  // This handles the business logic for the sign in feature.
  final _cubit = injection<SigninCubit>();

  // buildView constructs the UI of the sign in page.
  @override
  Widget buildView(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        // Scaffold provides the high-level structure for the page.
        body: SingleChildScrollView(
          // SingleChildScrollView makes the content scrollable if it overflows.
          child: Row(
            // Row displays its children in a horizontal array.
            children: [
              Expanded(
                // Expanded widget makes the image take up half the horizontal space.
                flex: 1,
                child: Image.asset(
                  "images/pngs/login_img.png",
                  fit: BoxFit
                      .cover, // Ensures the image covers its allocated space.
                ),
              ),
              Expanded(
                // Second Expanded widget for the form section and footer.
                flex: 1,
                child: Padding(
                  // Padding adds horizontal spacing to the content.
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Column(
                    // Column lays out children vertically.
                    children: [
                      const SizedBox(height: 156), // Spacing at the top.
                      const FormSection(), // Custom widget that contains the sign in form.
                      const SizedBox(
                          height: 64), // Spacing between form and footer.
                      LoginFotter() // Custom widget that contains the login footer.
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // getCubit provides the instance of the cubit responsible for handling business logic.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
