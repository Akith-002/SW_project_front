import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/pages/verifyOtp/cubit/verify_otp_cubit.dart';
import 'package:land_asset_valuation/application/pages/verifyOtp/cubit/verify_otp_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class VerifyOtpForm extends StatefulWidget {
  final String email;
  const VerifyOtpForm({super.key, required this.email});

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final TextEditingController otpController = TextEditingController();
  bool _obscureOtp = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          context.go(
            Pages.routeCreatePassword.toPath(),
            extra: {'email': widget.email, 'otp': otpController.text},
          );
        } else if (state is VerifyOtpError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          // );
        }
      },
      builder: (context, state) {
        final isLoading = state is VerifyOtpLoading;
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
                      : () => context.go(Pages.routeResetPassword.toPath()),
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                ),
                Expanded(
                  child: Text(
                    AppString.verifyOtp.localize(context) ?? 'Verify OTP',
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
                AppString.verifyOtpDescription.localize(context) ??
                    'Please input the OTP code that was sent to your email.',
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
            // OTP input
            SizedBox(
              width: 440,
              height: 48,
              child: TextFormField(
                controller: otpController,
                obscureText: _obscureOtp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText:
                      AppString.otpPlaceholder.localize(context) ?? '000000',
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
                    icon: Icon(Icons.more_horiz,
                        color: colors(context).colorGrey4),
                    onPressed: () {
                      setState(() {
                        _obscureOtp = !_obscureOtp;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(height: 32),
            // Verify button
            CustomButton(
              text: AppString.verify.localize(context) ?? 'Verify',
              onPressed: isLoading
                  ? null
                  : () {
                      context
                          .read<VerifyOtpCubit>()
                          .verifyOtp(widget.email, otpController.text);
                    },
              width: 440,
              height: 56,
              backgroundColor: colors(context).colorPrimary5!,
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            // Resend Code button
            CustomButton(
              text: AppString.resendCode.localize(context) ?? 'Resend Code',
              onPressed: isLoading ? null : () {},
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
