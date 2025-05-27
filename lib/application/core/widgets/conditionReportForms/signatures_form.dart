import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/signature_box.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_cubit.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';
import 'package:land_asset_valuation/application/core/validators/signature_form_validator.dart';
import 'dart:typed_data';

class SignaturesForm extends StatefulWidget {
  final Function? onSubmitSuccess;

  const SignaturesForm({
    super.key,
    this.onSubmitSuccess,
  });

  @override
  State<SignaturesForm> createState() => _SignaturesFormState();
}

class _SignaturesFormState extends State<SignaturesForm> {
  Uint8List? acquiringOfficerSignature;
  Uint8List? gramaSevekaSignature;
  Uint8List? chiefValuersRepSignature;
  bool _isSubmitting = false;

  String? acquiringOfficerError;
  String? gramaSevekaError;
  String? chiefValuersRepError;

  void _validateAndSubmitForm() {
    setState(() {
      acquiringOfficerError = SignatureFormValidator.validateSignature(
          acquiringOfficerSignature, "Acquiring Officer");
      gramaSevekaError = SignatureFormValidator.validateSignature(
          gramaSevekaSignature, "Gramasewa Niladhari");
      chiefValuersRepError = SignatureFormValidator.validateSignature(
          chiefValuersRepSignature, "Chief Valuer’s Representative");
    });

    if (acquiringOfficerError == null &&
        gramaSevekaError == null &&
        chiefValuersRepError == null) {
      _submitForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please provide all required signatures."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConditionReportCubit, BaseState<ConditionReportState>>(
      listener: (context, state) {
        if (state is ConditionReportSubmitSuccess) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Condition report submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSubmitSuccess?.call();
          context.go(Pages.routeMapScreen.toPath());
        } else if (state is ConditionReportSubmitFailure) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ConditionReportLoading) {
          setState(() {
            _isSubmitting = true;
          });
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double formWidth = constraints.maxWidth - 32;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                SignatureBox(
                  title: AppString.acquiringOfficer.localize(context)!,
                  onSignatureChanged: (Uint8List? signature) {
                    setState(() {
                      acquiringOfficerSignature = signature;
                      acquiringOfficerError = null;
                    });
                  },
                  errorMessage: acquiringOfficerError,
                ),
                const SizedBox(height: 16),
                SignatureBox(
                  title: AppString.gramaSeveka.localize(context)!,
                  onSignatureChanged: (Uint8List? signature) {
                    setState(() {
                      gramaSevekaSignature = signature;
                      gramaSevekaError = null;
                    });
                  },
                  errorMessage: gramaSevekaError,
                ),
                const SizedBox(height: 16),
                SignatureBox(
                  title:
                      AppString.chiefValuersRepresentative.localize(context)!,
                  onSignatureChanged: (Uint8List? signature) {
                    setState(() {
                      chiefValuersRepSignature = signature;
                      chiefValuersRepError = null;
                    });
                  },
                  errorMessage: chiefValuersRepError,
                ),
                const SizedBox(height: 24),
                Container(
                  width: formWidth,
                  height: 1.5,
                  color: colors(context).colorGrey5,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: AppString.cancel.localize(context)!,
                        backgroundColor: colors(context).colorGrey1!,
                        onPressed:
                            _isSubmitting ? null : () => Navigator.pop(context),
                        width: 120,
                        height: 48,
                      ),
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: AppString.save.localize(context)!,
                              backgroundColor: colors(context).colorPrimary5!,
                              onPressed: _validateAndSubmitForm,
                              width: 120,
                              height: 48,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    final formService = ConditionReportFormService();

    formService.updateSignatures(
      acquiringOfficerSignature:
          acquiringOfficerSignature != null ? 'Signature present' : '',
      gramasewakaSignature:
          gramaSevekaSignature != null ? 'Signature present' : '',
      chiefValuerRepresentativeSignature:
          chiefValuersRepSignature != null ? 'Signature present' : '',
    );

    print('======= SENDING CONDITION REPORT DATA =======');
    print('Master File ID: 56249');
    print('Form Data Summary:');
    print(formService.formData.generateDetailedNotes());
    print(
        'Signatures collected: ${acquiringOfficerSignature != null ? "Yes" : "No"} (Acquiring Officer), '
        '${gramaSevekaSignature != null ? "Yes" : "No"} (Grama Seveka), '
        '${chiefValuersRepSignature != null ? "Yes" : "No"} (Chief Valuer\'s Rep)');
    print('===========================================');

    final conditionReportCubit = context.read<ConditionReportCubit>();
    const masterFileId = "56249";
    conditionReportCubit.sendConditionReport(masterFileId);
  }
}
