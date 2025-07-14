import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';

class MultiSelectDecisionDialog extends StatefulWidget {
  final VoidCallback? onCancel;
  final Function(String)? onSubmit;

  const MultiSelectDecisionDialog({
    super.key,
    this.onCancel,
    this.onSubmit,
  });

  static Future<void> showMultiSelectDecisionDialog(
    BuildContext context, {
    VoidCallback? onCancel,
    Function(String)? onSubmit,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MultiSelectDecisionDialog(
          onCancel: onCancel,
          onSubmit: onSubmit,
        );
      },
    );
  }

  @override
  State<MultiSelectDecisionDialog> createState() => _MultiSelectDecisionDialogState();
}

class _MultiSelectDecisionDialogState extends State<MultiSelectDecisionDialog> {
  String? selectedOption;

  final List<String> decisionOptions = [
    'Create Rating Cards',
    'Approve All',
    'Reject All',
    'Mark as Reviewed',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: colors(context).colorWhite,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Multi-Select Decision',
              style: AppStyling.semiBoldTextSize18.copyWith(
                color: colors(context).colorBlack,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select an action to apply to all selected assets:',
              style: AppStyling.regularTextSize14.copyWith(
                color: colors(context).colorGrey2,
              ),
            ),
            const SizedBox(height: 20),
            
            // Radio button list for decision options
            Column(
              children: decisionOptions.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option,
                    style: AppStyling.regularTextSize14,
                  ),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                  activeColor: colors(context).colorPrimary6,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: AppString.cancel.l10n(context)!,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onCancel?.call();
                  },
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: AppString.submit.l10n(context)!,
                  onPressed: selectedOption != null
                      ? () {
                          Navigator.of(context).pop();
                          widget.onSubmit?.call(selectedOption!);
                        }
                      : null,
                  backgroundColor: selectedOption != null 
                      ? colors(context).colorPrimary5!
                      : colors(context).colorGrey5!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}