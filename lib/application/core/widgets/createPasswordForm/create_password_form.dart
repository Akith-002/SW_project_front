import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/pages/createPassword/cubit/create_password_cubit.dart';
import 'package:land_asset_valuation/application/pages/createPassword/cubit/create_password_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class CreatePasswordForm extends StatefulWidget {
  final String email;
  final String otp;
  const CreatePasswordForm({super.key, required this.email, required this.otp});

  @override
  State<CreatePasswordForm> createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Password requirement checks
  bool get hasMinLength => passwordController.text.length >= 8;
  bool get hasUppercase => passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => passwordController.text.contains(RegExp(r'[a-z]'));
  bool get hasNumber => passwordController.text.contains(RegExp(r'[0-9]'));

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {}); // Triggers rebuild for live validation
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePasswordCubit, CreatePasswordState>(
      listener: (context, state) {
        if (state is CreatePasswordSuccess) {
          context.go(Pages.routeSignIn.toPath());
        } else if (state is CreatePasswordError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          // );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreatePasswordLoading;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back button and title (same line)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 24, color: colors(context).colorGrey4),
                  onPressed: isLoading
                      ? null
                      : () => context.go(Pages.routeVerifyOtp.toPath()),
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                ),
                Expanded(
                  child: Text(
                    AppString.createPassword.localize(context) ??
                        'Create your new password',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 28 / 24,
                      color: colors(context).labelTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description below title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppString.createPasswordDescription.localize(context) ??
                    'Please enter your new password.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 24 / 16,
                  color: colors(context).labelTextColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // New password input
            SizedBox(
              width: 440,
              height: 48,
              child: TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: AppString.enterNewPassword.localize(context) ??
                      'Enter your new password',
                  filled: true,
                  fillColor: colors(context).colorGrey1!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: colors(context).colorGrey5!, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: colors(context).colorGrey5!, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword ? Icons.lock_outline : Icons.lock_open,
                        color: colors(context).colorGrey4),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // Confirm password input
            SizedBox(
              width: 440,
              height: 48,
              child: TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: AppString.reenterNewPassword.localize(context) ??
                      'Re-enter your new password',
                  filled: true,
                  fillColor: colors(context).colorGrey1!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: colors(context).colorGrey5!, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: colors(context).colorGrey5!, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.lock_outline
                            : Icons.lock_open,
                        color: colors(context).colorGrey4),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // Password requirements
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppString.passwordMustInclude.localize(context) ??
                          'Your password must include:',
                      style: AppStyling.mediumTextSize14.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors(context).labelTextColor)),
                  const SizedBox(height: 4),
                  _PasswordRequirement(
                    text: AppString.atLeast8Characters.localize(context) ??
                        'at least 8 characters',
                    fulfilled: hasMinLength,
                  ),
                  _PasswordRequirement(
                    text: AppString.atLeastOneUppercase.localize(context) ??
                        'at least one uppercase letter',
                    fulfilled: hasUppercase,
                  ),
                  _PasswordRequirement(
                    text: AppString.atLeastOneLowercase.localize(context) ??
                        'at least one lowercase letter',
                    fulfilled: hasLowercase,
                  ),
                  _PasswordRequirement(
                    text: AppString.atLeastOneNumber.localize(context) ??
                        'at least a number',
                    fulfilled: hasNumber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Set New Password button
            CustomButton(
              text: AppString.setNewPassword.localize(context) ??
                  'Set New Password',
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<CreatePasswordCubit>().createPassword(
                            widget.email,
                            widget.otp,
                            passwordController.text,
                          );
                    },
              width: 440,
              height: 56,
              backgroundColor: colors(context).colorPrimary5!,
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            // Cancel button
            CustomButton(
              text: AppString.cancel.localize(context) ?? 'Cancel',
              onPressed: isLoading
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

class _PasswordRequirement extends StatelessWidget {
  final String text;
  final bool fulfilled;
  const _PasswordRequirement({required this.text, required this.fulfilled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check,
          size: 16,
          color: fulfilled ? Color(0xFF22C55E) : Color(0xFFD2D5DB),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: fulfilled ? Color(0xFF22C55E) : Color(0xFF4D5461),
          ),
        ),
      ],
    );
  }
}
