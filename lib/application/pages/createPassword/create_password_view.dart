import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/pages/createPassword/cubit/create_password_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/createPasswordForm/create_password_form.dart';

class CreatePasswordView extends BasePage {
  const CreatePasswordView({Key? key}) : super(key: key);

  @override
  State<CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends BasePageState<CreatePasswordView> {
  final _cubit = CreatePasswordCubit();

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
              child: CreatePasswordForm(),
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
