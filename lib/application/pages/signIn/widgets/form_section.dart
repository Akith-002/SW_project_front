import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/password_text_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';
import 'package:land_asset_valuation/data/services/sign_in_service.dart';

class FormSection extends StatefulWidget {
  const FormSection({super.key});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final appSharedData = injection<AppSharedData>();
    final signInService = SignInService(sharedData: appSharedData);

    final success = await signInService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      context.go(Pages.routeDashboard.toPath());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 440,
      child: Column(
        children: [
          Center(
            child: SizedBox(
              width: 257,
              child: Column(
                children: [
                  Image.asset(
                    "images/pngs/VD_Logo.png",
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppString.welcome.localize(context)!,
                    style: AppStyling.boldTextSize24.copyWith(
                      color: colors(context).colorGrey2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),

          /// Username
          LabeledTextField(
            controller: _usernameController,
            placeholder: AppString.username.localize(context)!,
            icon: PhosphorIconsRegular.user,
            width: 440,
            height: 48,
          ),

          const SizedBox(height: 16),

          /// Password
          PasswordTextField(
            controller: _passwordController,
            placeholder: AppString.password.localize(context)!,
            width: 440,
            height: 48,
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppString.forgotPassword.localize(context)!,
              style: AppStyling.mediumTextSize16.copyWith(
                color: colors(context).colorPrimary5,
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// Login Button
          CustomButton(
            text: AppString.login.localize(context)!,
            onPressed: () => _login(context),
            backgroundColor: colors(context).colorPrimary5 ?? Colors.blue,
            height: 56,
            width: 440,
          ),
        ],
      ),
    );
  }
}
