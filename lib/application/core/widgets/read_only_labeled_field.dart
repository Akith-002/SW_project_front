import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class ReadOnlyLabeledField extends StatelessWidget {
  final String label;
  final String value;

  const ReadOnlyLabeledField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 484, // ✅ Matches the width of LabeledTextField
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Keeps label & value in the same row
            children: [
              Text(
                label,
                style: AppStyling.mediumTextSize14.copyWith(color: colors(context).labelTextColor),
              ),
              Text(
                value,
                style: AppStyling.normalTextSize14.copyWith(color: colors(context).colorBlack),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // ✅ Reduced Line Length to 484px (Matches LabeledTextField)
          Container(
            width: 484, // ✅ Now matches the width of LabeledTextField
            height: 1,
            color: colors(context).colorGrey5, // Thin separator line
          ),
        ],
      ),
    );
  }
}
