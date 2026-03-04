import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/pages/createPassword/cubit/create_password_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/createPasswordForm/create_password_form.dart';
import 'package:land_asset_valuation/injection.dart';

class CreatePasswordView extends BasePage {
  final String email;
  final String otp;
  const CreatePasswordView({super.key, required this.email, required this.otp});

  @override
  State<CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends BasePageState<CreatePasswordView> {
  late final CreatePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CreatePasswordCubit(authRepository: injection());
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
              child: CreatePasswordForm(email: widget.email, otp: widget.otp),
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
