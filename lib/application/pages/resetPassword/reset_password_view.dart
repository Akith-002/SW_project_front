import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/application/pages/resetPassword/cubit/reset_password_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/resetPasswordForm/reset_password_form.dart';
import 'package:land_asset_valuation/injection.dart';

class ResetPasswordView extends BasePage {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends BasePageState<ResetPasswordView> {
  late final ResetPasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ResetPasswordCubit(authRepository: injection());
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
              child: ResetPasswordForm(),
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
