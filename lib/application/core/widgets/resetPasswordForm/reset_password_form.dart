import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/pages/resetPassword/cubit/reset_password_cubit.dart';
import 'package:land_asset_valuation/application/pages/resetPassword/cubit/reset_password_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordOtpSent) {
          context.go(
            Pages.routeVerifyOtp.toPath(),
            extra: {'email': emailController.text},
          );
        } else if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ResetPasswordLoading;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back button and title in a row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 24, color: Color(0xFF9EA2AE)),
                  onPressed: () => context.go(Pages.routeSignIn.toPath()),
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                ),
                Text(
                  AppString.resetPassword.localize(context) ?? 'Reset password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 28 / 24,
                    color: colors(context).labelTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppString.resetPasswordDescription.localize(context) ??
                    'Please provide your email address to get a one-time code for resetting your password.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 24 / 16,
                  color: colors(context).labelTextColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 32),
            // Email input
            LabeledTextField(
              controller: emailController,
              placeholder:
                  AppString.emailAddress.localize(context) ?? 'Email address',
              icon: Icons.email_outlined,
              width: 440,
              height: 48,
            ),
            const SizedBox(height: 32),
            // Continue button
            CustomButton(
              text: AppString.continueText.localize(context) ?? 'Continue',
              onPressed: context.watch<ResetPasswordCubit>().state
                      is ResetPasswordLoading
                  ? null
                  : () {
                      context.read<ResetPasswordCubit>().requestOtp(
                            emailController.text,
                          );
                    },
              width: 440,
              height: 56,
              backgroundColor: colors(context).colorPrimary5!,
              isLoading: context.watch<ResetPasswordCubit>().state
                  is ResetPasswordLoading,
            ),
            const SizedBox(height: 16),
            // Cancel button
            CustomButton(
              text: AppString.cancel.localize(context) ?? 'Cancel',
              onPressed: context.watch<ResetPasswordCubit>().state
                      is ResetPasswordLoading
                  ? null
                  : () {
                      context.go(Pages.routeSignIn.toPath());
                    },
              width: 440,
              height: 48,
              backgroundColor: colors(context).colorGrey1!,
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}
