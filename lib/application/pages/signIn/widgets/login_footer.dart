import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class LoginFotter extends StatelessWidget {
  const LoginFotter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 206,
        child: Align(
          alignment: Alignment
              .center, 
          child: RichText(
            textAlign: TextAlign
                .center, 
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppString.loginFooter
                      .localize(context)!
                      .substring(0, 40),
                  style: AppStyling.normalTextSize12.copyWith(
                      color: colors(context).colorGrey8),
                ),
                TextSpan(
                  text: AppString.loginFooter
                      .localize(context)!
                      .substring(40),
                  style: AppStyling.normalTextSize12.copyWith(
                    color: colors(context).colorGrey8,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
