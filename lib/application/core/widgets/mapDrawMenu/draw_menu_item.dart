import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/floatingIcon/floating_icon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DrawMenuItem extends StatelessWidget {
  final PhosphorFlatIconData icon;
  final Color? iconColor;
  final String? menuText;
  final double? size;
  final VoidCallback onPressed;

  const DrawMenuItem(
      {super.key,
      required this.icon,
      this.iconColor,
      required this.onPressed,
      this.menuText,
      this.size});

  @override
  Widget build(BuildContext context) {
    final colorName = iconColor ?? colors(context).colorBlack;

    final size = this.size ?? 24.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (menuText != null)
          GestureDetector(
            onTap: onPressed,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100),
              height: 50,
              decoration: BoxDecoration(
                color: colors(context).colorWhite,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colors(context).colorGrey3!,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Text(
                menuText!,
                style: TextStyle(
                  fontSize: 14,
                  color: colors(context).colorBlack,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        SizedBox(
          width: 8,
        ),
        FloatingIcon(
          onPressed: onPressed,
          icon: icon,
          size: size,
          colorName: colorName,
        ),
      ],
    );
  }
}
