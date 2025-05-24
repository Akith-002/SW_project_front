import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class iconButtonWidget extends StatelessWidget {
  final Color color;
  final IconData iconName;
  final VoidCallback onPressed;
  const iconButtonWidget({
    super.key,
    required this.color,
    required this.iconName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color? iconColor;
    final Color? borderColor;
    final Color? backgroundColor;

    if (color == colors(context).colorBlack) {
      iconColor = colors(context).colorBlack;
      borderColor = colors(context).colorGrey9;
      backgroundColor = colors(context).colorWhite;
    } else if (color == colors(context).colorGrey8) {
      iconColor = colors(context).colorGrey8;
      borderColor = colors(context).colorGrey9;
      backgroundColor = colors(context).colorWhite;
    } else if (color == colors(context).colorPrimary6) {
      iconColor = colors(context).colorPrimary6;
      borderColor = colors(context).colorPrimary1;
      backgroundColor = colors(context).colorPrimary9;
    } 
    
    else {
      iconColor = colors(context).colorBlack;
      borderColor = colors(context).colorGrey9;
      backgroundColor = colors(context).colorWhite;
    }

    //

    return IconButton(
      onPressed: onPressed,
      icon: PhosphorIcon(
        iconName,
        color: iconColor,
        size: 24,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor?? Colors.red,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
