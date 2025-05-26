import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/password_text_field.dart';
import 'package:land_asset_valuation/application/pages/signIn/cubit/signin_cubit.dart';
import 'package:land_asset_valuation/application/pages/signIn/cubit/signin_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FormSection extends StatefulWidget {
  const FormSection({super.key});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, BaseState<SigninState>>(
      listener: (context, state) {
        if (state is SigninAuthenticated) {
          context.go(Pages.routeDashboard.toPath());
        } else if (state is SigninError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is ForgotPasswordEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email has been sent'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
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
                child: GestureDetector(
                  onTap: () {
                    if (_usernameController.text.isNotEmpty) {
                      context.read<SigninCubit>().forgotPassword(
                            _usernameController.text,
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your username'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    AppString.forgotPassword.localize(context)!,
                    style: AppStyling.mediumTextSize16.copyWith(
                      color: colors(context).colorPrimary5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Login Button
              CustomButton(
                text: AppString.login.localize(context)!,
                onPressed: state is SigninLoading
                    ? null
                    : () {
                        if (_usernameController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          context.read<SigninCubit>().login(
                                _usernameController.text,
                                _passwordController.text,
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter your username and password'),
                            ),
                          );
                        }
                      },
                backgroundColor: colors(context).colorPrimary5 ?? Colors.blue,
                height: 56,
                width: 440,
                isLoading: state is SigninLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
