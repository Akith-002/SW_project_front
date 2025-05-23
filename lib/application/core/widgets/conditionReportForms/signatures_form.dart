import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/signature_box.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_cubit.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';
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
          if (widget.onSubmitSuccess != null) {
            widget.onSubmitSuccess!();
          }
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

                // Signature Fields
                SignatureBox(
                  title: AppString.acquiringOfficer.localize(context)!,
                  onSignatureChanged: (Uint8List? signature) {
                    setState(() {
                      acquiringOfficerSignature = signature;
                    });
                  },
                ),
                const SizedBox(height: 16),

                SignatureBox(
                  title: AppString.gramaSeveka.localize(context)!,
                  onSignatureChanged: (Uint8List? signature) {
                    setState(() {
                      gramaSevekaSignature = signature;
                    });
                  },
                ),
                const SizedBox(height: 16),

                SignatureBox(
                  title:
                      AppString.chiefValuersRepresentative.localize(context)!,
                  onSignatureChanged: (Uint8List? signature) {
                    setState(() {
                      chiefValuersRepSignature = signature;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Divider Section
                Container(
                  width: formWidth,
                  height: 1.5,
                  color: colors(context).colorGrey5,
                ),

                const SizedBox(height: 16),

                // Save & Cancel Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: AppString.cancel.localize(context)!,
                        backgroundColor: colors(context).colorGrey1!,
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        width: 120,
                        height: 48,
                      ),
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: AppString.save.localize(context)!,
                              backgroundColor: colors(context).colorPrimary5!,
                              onPressed: _submitForm,
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
    // Get the form data service
    final formService = ConditionReportFormService();

    // Update signatures in the form data
    formService.updateSignatures(
      acquiringOfficerSignature:
          acquiringOfficerSignature != null ? 'Signature present' : '',
      gramasewakaSignature:
          gramaSevekaSignature != null ? 'Signature present' : '',
      chiefValuerRepresentativeSignature:
          chiefValuersRepSignature != null ? 'Signature present' : '',
    );

    // Debug print statements to see what data is being sent
    print('======= SENDING CONDITION REPORT DATA =======');
    print('Master File ID: 56249');
    print('Form Data Summary:');
    print(formService.formData.generateDetailedNotes());
    print(
        'Signatures collected: ${acquiringOfficerSignature != null ? "Yes" : "No"} (Acquiring Officer), '
        '${gramaSevekaSignature != null ? "Yes" : "No"} (Grama Seveka), '
        '${chiefValuersRepSignature != null ? "Yes" : "No"} (Chief Valuer\'s Rep)');
    print('===========================================');

    // Use the BLoC to submit the condition report
    final conditionReportCubit = context.read<ConditionReportCubit>();

    // Get the master file ID from the breadcrumb in ConditionReportView
    const masterFileId = "56249";

    // Send the report
    conditionReportCubit.sendConditionReport(masterFileId);
  }
}
