import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/pages/verifyOtp/cubit/verify_otp_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/verifyOtpForm/verify_otp_form.dart';
import 'package:land_asset_valuation/injection.dart';

class VerifyOtpView extends BasePage {
  final String email;
  const VerifyOtpView({super.key, required this.email});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends BasePageState<VerifyOtpView> {
  late final VerifyOtpCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VerifyOtpCubit(authRepository: injection());
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: VerifyOtpForm(email: widget.email),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            '© 2024 Valuation Department.\nPowered By Epic Technology Group.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 16 / 12,
              color: Color(0xFF6D717F),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  getCubit() => _cubit;
}
