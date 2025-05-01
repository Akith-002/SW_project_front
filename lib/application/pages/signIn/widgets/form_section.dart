import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
  });

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
                        color: colors(context).colorGrey2),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),
          Center(
            child: SizedBox(
              width: 440,
              height: 224,
              child: Column(
                children: [
                  LabeledTextField(
                    placeholder: AppString.username.localize(context)!,
                    icon: PhosphorIconsRegular.user,
                    width: 440,
                    height: 48,
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    placeholder: AppString.password.localize(context)!,
                    icon: PhosphorIconsRegular.lock,
                    width: 440,
                    height: 48,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppString.forgotPassword.localize(context)!,
                      style: AppStyling.mediumTextSize16.copyWith(
                          color: colors(context).colorPrimary5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: AppString.login.localize(context)!,
                    onPressed: () {
                      context.go(Pages.routeDashboard.toPath());
                    },
                    backgroundColor:
                        colors(context).colorPrimary5 ??
                            LightColorList.lightPrimary700,
                    height: 56,
                    width: 440,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

