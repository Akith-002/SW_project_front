import 'package:flutter/material.dart';

class AppStyling {
  static const TextStyle boldTextSize20 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  static const TextStyle boldTextSize22 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );

  static const TextStyle boldTextSize24 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );

  static const TextStyle boldTextSize18 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );

  static const TextStyle boldTextSize16 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const TextStyle boldTextSize14 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const TextStyle boldTextSize12 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const TextStyle semiBoldTextSize20 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );

  static const TextStyle semiBoldTextSize18 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const TextStyle semiBoldTextSize16 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static const TextStyle semiBoldTextSize14 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const TextStyle semiBoldTextSize12 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  static const TextStyle semiBoldTextSize10 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10,
  );

  static const TextStyle regularTextSize20 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  static const TextStyle regularTextSize18 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle regularTextSize16 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const TextStyle regularTextSize14 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static const TextStyle regularTextSize12 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static const TextStyle normalTextSize20 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static const TextStyle normalTextSize18 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );

  static const TextStyle normalTextSize16 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const TextStyle normalTextSize15 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

  static const TextStyle normalTextSize14 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const TextStyle normalTextSize12 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static const TextStyle buttonText = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const TextStyle mediumTextSize14 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static const TextStyle mediumTextSize16 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const TextStyle mediumTextSize18 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static var appBarStyle;
}

Color hexToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
