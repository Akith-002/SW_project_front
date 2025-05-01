import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppColors colors(BuildContext context) {
  return Theme.of(context).extension<AppColors>()!;
}

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        colorPrimary1: !isDarkTheme
            ? LightColorList.lightPrimary500
            : LightColorList.lightPrimary500,
        colorPrimary2: !isDarkTheme
            ? LightColorList.lightPrimary900
            : LightColorList.lightPrimary900,
        colorPrimary3: !isDarkTheme
            ? LightColorList.lightPrimary900
            : LightColorList.lightPrimary900,
        colorPrimary4: !isDarkTheme
            ? LightColorList.lightPrimary800
            : LightColorList.lightPrimary800,
        colorPrimary5: !isDarkTheme
            ? LightColorList.lightPrimary700
            : LightColorList.lightPrimary700,
        colorPrimary6: !isDarkTheme
            ? LightColorList.lightPrimary600
            : LightColorList.lightPrimary600,
        colorPrimary7: !isDarkTheme
            ? LightColorList.lightPrimary50
            : LightColorList.lightPrimary50,
        colorPrimary8: !isDarkTheme
            ? LightColorList.lightPrimary200
            : LightColorList.lightPrimary200,
        colorPrimary9: !isDarkTheme
            ? LightColorList.lightPrimary100
            : LightColorList.lightPrimary100,
            
        colorGrey1: !isDarkTheme
            ? LightColorList.lightGrey50
            : LightColorList.lightGrey50,
        colorGrey2: !isDarkTheme
            ? LightColorList.lightGrey700
            : LightColorList.lightGrey700,
        colorGrey3: !isDarkTheme
            ? LightColorList.lightGrey400
            : LightColorList.lightGrey400,
        colorGrey4: !isDarkTheme
            ? LightColorList.lightGrey500
            : LightColorList.lightGrey500,
        colorGrey5: !isDarkTheme
            ? LightColorList.lightGrey200
            : LightColorList.lightGrey200,
        colorGrey6: !isDarkTheme
            ? LightColorList.lightGrey800
            : LightColorList.lightGrey800,
        colorGrey7: !isDarkTheme
            ? LightColorList.lightGrey900
            : LightColorList.lightGrey900,
        colorGrey8: !isDarkTheme
            ? LightColorList.lightGrey600
            : LightColorList.lightGrey600,
        colorGrey9: !isDarkTheme
            ? LightColorList.lightGrey100
            : LightColorList.lightGrey100,
        colorGrey10: !isDarkTheme
            ? LightColorList.lightGrey600
            : LightColorList.lightGrey600,
        colorGrey11: !isDarkTheme
            ? LightColorList.lightGrey300
            : LightColorList.lightGrey300,
        colorNeutral5: isDarkTheme
            ? LightColorList.lightNeutral700
            : LightColorList.lightNeutral700,
        colorNeutral6: isDarkTheme
            ? LightColorList.lightNeutral600
            : LightColorList.lightNeutral600,
        colorNeutral7: isDarkTheme
            ? LightColorList.lightNeutral150
            : LightColorList.lightNeutral150,
        colorNeutral8: isDarkTheme
            ? LightColorList.lightNeutral50
            : LightColorList.lightNeutral50,
        colorInformative1: isDarkTheme
            ? LightColorList.lightInformative500
            : LightColorList.lightInformative500,
        colorInformative2: !isDarkTheme
            ? LightColorList.lightInformative950
            : LightColorList.lightInformative950,
        colorInformative3: !isDarkTheme
            ? LightColorList.lightInformative900
            : LightColorList.lightInformative900,
        colorInformative4: !isDarkTheme
            ? LightColorList.lightInformative800
            : LightColorList.lightInformative800,
        colorInformative5: !isDarkTheme
            ? LightColorList.lightInformative700
            : LightColorList.lightInformative700,
        colorInformative6: isDarkTheme
            ? LightColorList.lightInformative600
            : LightColorList.lightInformative600,
        colorPositive1: !isDarkTheme
            ? LightColorList.positive600
            : LightColorList.positive600,
        colorPositive2: !isDarkTheme
            ? LightColorList.positive50
            : LightColorList.positive900,
        colorPositive3: !isDarkTheme
            ? LightColorList.positive100
            : LightColorList.positive100,
        colorPositive4: !isDarkTheme
            ? LightColorList.positive200
            : LightColorList.positive200,
        colorPositive5: !isDarkTheme
            ? LightColorList.positive300
            : LightColorList.positive300,
        colorPositive6: isDarkTheme
            ? LightColorList.positive400
            : LightColorList.positive400,
        colorPositive7: isDarkTheme
            ? LightColorList.positive700
            : LightColorList.positive700,
        colorNotice1:
            !isDarkTheme ? LightColorList.notice500 : LightColorList.notice500,
        colorNotice2:
            !isDarkTheme ? LightColorList.notice50 : LightColorList.notice50,
        colorNotice3:
            !isDarkTheme ? LightColorList.notice100 : LightColorList.notice100,
        colorNotice4:
            !isDarkTheme ? LightColorList.notice200 : LightColorList.notice200,
        colorNotice5:
            !isDarkTheme ? LightColorList.notice300 : LightColorList.notice300,
        colorNotice6:
            !isDarkTheme ? LightColorList.notice400 : LightColorList.notice400,
        colorNotice7:
            !isDarkTheme ? LightColorList.notice600 : LightColorList.notice600,
        colorNegative1: !isDarkTheme
            ? LightColorList.lightNegative500
            : LightColorList.lightNegative500,
        colorNegative2: !isDarkTheme
            ? LightColorList.lightNegative900
            : LightColorList.lightNegative900,
        colorNegative3: !isDarkTheme
            ? LightColorList.lightNegative900
            : LightColorList.lightNegative900,
        colorNegative4: !isDarkTheme
            ? LightColorList.lightNegative800
            : LightColorList.lightNegative800,
        colorNegative5: !isDarkTheme
            ? LightColorList.lightNegative700
            : LightColorList.lightNegative700,
        colorNegative6: !isDarkTheme
            ? LightColorList.lightNegative600
            : LightColorList.lightNegative600,
        colorWhite: isDarkTheme
            ? LightColorList.lightColorWhite
            : LightColorList.lightColorWhite,
        colorTextFieldBg: isDarkTheme
            ? LightColorList.lightNeutral100
            : LightColorList.lightNeutral100,
        colorBlack: isDarkTheme
            ? LightColorList.lightColorBlack
            : LightColorList.lightColorBlack,
        colorCarousel: !isDarkTheme
            ? LightColorList.lightNeutral600
            : LightColorList.lightNeutral600,
        colorBorderColor: !isDarkTheme
            ? LightColorList.lightNeutral400
            : LightColorList.lightNeutral400,
        containerBorderColor: !isDarkTheme
            ? LightColorList.lightNeutral200
            : LightColorList.lightNeutral200,
        containerBGColor: !isDarkTheme
            ? LightColorList.lightContainerBG
            : LightColorList.lightContainerBG,
        successGreenColor: !isDarkTheme
            ? LightColorList.lightSuccessGreenColor
            : LightColorList.lightSuccessGreenColor,
        errorRedColor: !isDarkTheme
            ? LightColorList.lightErrorRedColor
            : LightColorList.lightErrorRedColor,
        grayColor: !isDarkTheme
            ? LightColorList.lightGrayColor
            : LightColorList.lightGrayColor,
        emptyViewSubtextColor: !isDarkTheme
            ? LightColorList.lightTextColor
            : LightColorList.lightTextColor,
        readMoreTextColor: !isDarkTheme
            ? LightColorList.lightBlueColor
            : LightColorList.lightBlueColor,
        errorColor: !isDarkTheme
            ? LightColorList.lightErrorColor
            : LightColorList.lightErrorColor,
        grayTextColor: !isDarkTheme
            ? LightColorList.lightGrey500
            : LightColorList.lightGrey500,
        errorBoderColor: !isDarkTheme
            ? LightColorList.lightErrorBorderColor
            : LightColorList.lightErrorBorderColor,
        dropDownBorderColor: !isDarkTheme
            ? LightColorList.lightDropDownBorderColor
            : LightColorList.lightDropDownBorderColor,
        dropDownBGColor: !isDarkTheme
            ? LightColorList.lightDropDownBGColor
            : LightColorList.lightDropDownBGColor,
        labelTextColor: !isDarkTheme
            ? LightColorList.lightLabelColor
            : LightColorList.lightLabelColor,
        checkBoxColor: !isDarkTheme
            ? LightColorList.lightCheckBoxColor
            : LightColorList.lightCheckBoxColor,
        searchButtonColor: !isDarkTheme
            ? LightColorList.lightSearchButton
            : LightColorList.lightSearchButton,
        bottomSheetTitleColor: !isDarkTheme
            ? LightColorList.lightBottomTitleColor
            : LightColorList.lightBottomTitleColor,
        greenTextColor: !isDarkTheme
            ? LightColorList.lightGreenColor
            : LightColorList.lightGreenColor,
        tabColor: !isDarkTheme
            ? LightColorList.lightTabColor
            : LightColorList.lightTabColor,
        textGrey: !isDarkTheme
            ? LightColorList.lightTextGrey
            : LightColorList.lightTextGrey,
        textPrimary: !isDarkTheme
            ? LightColorList.lightTextPrimary
            : LightColorList.lightTextPrimary,
        splash1: !isDarkTheme
            ? LightColorList.lightSplashColor1
            : LightColorList.lightSplashColor1,
        splash2: !isDarkTheme
            ? LightColorList.lightSplashColor2
            : LightColorList.lightSplashColor2,
        brownTextColor: !isDarkTheme
            ? LightColorList.lightBrownTextColor
            : LightColorList.lightBrownTextColor,
        errorBoxColor: !isDarkTheme
            ? LightColorList.lightErrorBoxColor
            : LightColorList.lightErrorBoxColor,
        claimMessageBlueColor: !isDarkTheme
            ? LightColorList.lightClimBlueColor
            : LightColorList.lightClimBlueColor,
        claimMessageBlueBorderColor: !isDarkTheme
            ? LightColorList.lightClimBlueBorderColor
            : LightColorList.lightClimBlueBorderColor,
        profileBGColor: !isDarkTheme
            ? LightColorList.lightProfileBgColor
            : LightColorList.lightProfileBgColor,
        colorIconBlack: !isDarkTheme
            ? LightColorList.lightIconBlack
            : LightColorList.lightIconBlack,
        colorIconDefault: !isDarkTheme
            ? LightColorList.lightIconDefault
            : LightColorList.lightIconDefault,
      ),
    ],
    fontFamily: "Roboto",
    textTheme: GoogleFonts.figtreeTextTheme(),
    scaffoldBackgroundColor: isDarkTheme
        ? LightColorList.lightColorWhite
        : LightColorList.lightColorWhite,
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? colorPrimary1;
  final Color? colorPrimary2;
  final Color? colorPrimary3;
  final Color? colorPrimary4;
  final Color? colorPrimary5;
  final Color? colorPrimary6;
  final Color? colorPrimary7;
  final Color? colorPrimary8;
  final Color? colorPrimary9;

  final Color? colorGrey1;
  final Color? colorGrey2;
  final Color? colorGrey3;
  final Color? colorGrey4;
  final Color? colorGrey5;
  final Color? colorGrey6;
  final Color? colorGrey7;
  final Color? colorGrey8;
  final Color? colorGrey9;
  final Color? colorGrey10;
  final Color? colorGrey11;

  final Color? colorNeutral5;
  final Color? colorNeutral6;
  final Color? colorNeutral7;
  final Color? colorNeutral8;

  final Color? colorInformative1;
  final Color? colorInformative2;
  final Color? colorInformative3;
  final Color? colorInformative4;
  final Color? colorInformative5;
  final Color? colorInformative6;

  final Color? colorPositive1;
  final Color? colorPositive2;
  final Color? colorPositive3;
  final Color? colorPositive4;
  final Color? colorPositive5;
  final Color? colorPositive6;
  final Color? colorPositive7;

  final Color? colorNotice1;
  final Color? colorNotice2;
  final Color? colorNotice3;
  final Color? colorNotice4;
  final Color? colorNotice5;
  final Color? colorNotice6;
  final Color? colorNotice7;

  final Color? colorNegative1;
  final Color? colorNegative2;
  final Color? colorNegative3;
  final Color? colorNegative4;
  final Color? colorNegative5;
  final Color? colorNegative6;

  final Color? colorWhite;
  final Color? colorTextFieldBg;
  final Color? colorBlack;
  final Color? colorCarousel;
  final Color? colorBorderColor;
  final Color? containerBorderColor;
  final Color? containerBGColor;

  final Color? successGreenColor;
  final Color? errorRedColor;
  final Color? grayColor;
  final Color? emptyViewSubtextColor;
  final Color? readMoreTextColor;
  final Color? errorColor;
  final Color? grayTextColor;
  final Color? errorBoderColor;
  final Color? dropDownBorderColor;
  final Color? dropDownBGColor;
  final Color? labelTextColor;
  final Color? checkBoxColor;
  final Color? searchButtonColor;
  final Color? bottomSheetTitleColor;
  final Color? greenTextColor;
  final Color? tabColor;
  final Color? textGrey;
  final Color? textPrimary;
  final Color? splash1;
  final Color? splash2;
  final Color? brownTextColor;
  final Color? errorBoxColor;
  final Color? claimMessageBlueColor;
  final Color? claimMessageBlueBorderColor;
  final Color? profileBGColor;

  final Color? colorIconBlack;
  final Color? colorIconDefault;

  const AppColors({
    required this.colorPrimary1,
    required this.colorPrimary2,
    required this.colorPrimary3,
    required this.colorPrimary4,
    required this.colorPrimary5,
    required this.colorPrimary6,
    required this.colorPrimary7,
    required this.colorPrimary8,
    required this.colorPrimary9,
    required this.colorGrey1,
    required this.colorGrey2,
    required this.colorGrey3,
    required this.colorGrey4,
    required this.colorGrey5,
    required this.colorGrey6,
    required this.colorGrey7,
    required this.colorGrey8,
    required this.colorGrey9,
    required this.colorGrey10,
    required this.colorGrey11,
    required this.colorNeutral5,
    required this.colorNeutral6,
    required this.colorNeutral7,
    required this.colorNeutral8,
    required this.colorInformative1,
    required this.colorInformative2,
    required this.colorInformative3,
    required this.colorInformative4,
    required this.colorInformative5,
    required this.colorInformative6,
    required this.colorPositive1,
    required this.colorPositive2,
    required this.colorPositive3,
    required this.colorPositive4,
    required this.colorPositive5,
    required this.colorPositive6,
    required this.colorPositive7,
    required this.colorNotice1,
    required this.colorNotice2,
    required this.colorNotice3,
    required this.colorNotice4,
    required this.colorNotice5,
    required this.colorNotice6,
    required this.colorNotice7,
    required this.colorNegative1,
    required this.colorNegative2,
    required this.colorNegative3,
    required this.colorNegative4,
    required this.colorNegative5,
    required this.colorNegative6,
    required this.colorWhite,
    required this.colorTextFieldBg,
    required this.colorBlack,
    required this.colorCarousel,
    required this.colorBorderColor,
    required this.containerBorderColor,
    required this.containerBGColor,
    required this.successGreenColor,
    required this.errorRedColor,
    required this.grayColor,
    required this.emptyViewSubtextColor,
    required this.readMoreTextColor,
    required this.errorColor,
    required this.grayTextColor,
    required this.errorBoderColor,
    required this.dropDownBorderColor,
    required this.dropDownBGColor,
    required this.labelTextColor,
    required this.checkBoxColor,
    required this.searchButtonColor,
    required this.bottomSheetTitleColor,
    required this.greenTextColor,
    required this.tabColor,
    required this.textGrey,
    required this.textPrimary,
    required this.splash1,
    required this.splash2,
    required this.brownTextColor,
    required this.errorBoxColor,
    required this.claimMessageBlueColor,
    required this.claimMessageBlueBorderColor,
    required this.profileBGColor,
    required this.colorIconBlack,
    required this.colorIconDefault,
  });

  @override
  AppColors copyWith(
      {Color? colorPrimary1,
      Color? colorPrimary2,
      Color? colorPrimary3,
      Color? colorPrimary4,
      Color? colorPrimary5,
      Color? colorPrimary6,
      Color? colorPrimary7,
      Color? colorPrimary8,
      Color? colorPrimary9,
      Color? colorGrey1,
      Color? colorGrey2,
      Color? colorGrey3,
      Color? colorGrey4,
      Color? colorGrey5,
      Color? colorGrey6,
      Color? colorGrey7,
      Color? colorGrey8,
      Color? colorGrey9,
      Color? colorGrey10,
      Color? colorGrey11,
      Color? colorNeutral5,
      Color? colorNeutral6,
      Color? colorNeutral7,
      Color? colorNeutral8,
      Color? colorInformative1,
      Color? colorInformative2,
      Color? colorInformative3,
      Color? colorInformative4,
      Color? colorInformative5,
      Color? colorInformative6,
      Color? colorPositive1,
      Color? colorPositive2,
      Color? colorPositive3,
      Color? colorPositive4,
      Color? colorPositive5,
      Color? colorPositive6,
      Color? colorPositive7,
      Color? colorNotice1,
      Color? colorNotice2,
      Color? colorNotice3,
      Color? colorNotice4,
      Color? colorNotice5,
      Color? colorNotice6,
      Color? colorNotice7,
      Color? colorNegative1,
      Color? colorNegative2,
      Color? colorNegative3,
      Color? colorNegative4,
      Color? colorNegative5,
      Color? colorNegative6,
      Color? colorWhite,
      Color? colorTextFieldBg,
      Color? colorBlack,
      Color? colorCarousel,
      Color? colorBorderColor,
      Color? containerBorderColor,
      Color? containerBGColor,
      Color? successGreenColor,
      Color? errorRedColor,
      Color? grayColor,
      Color? emptyViewSubtextColor,
      Color? readMoreTextColor,
      Color? errorColor,
      Color? grayTextColor,
      Color? errorBoderColor,
      Color? dropDownBGColor,
      Color? labelTextColor,
      Color? checkBoxColor,
      Color? searchButtonColor,
      Color? bottomSheetTitleColor,
      Color? greenTextColor,
      Color? tabColor,
      Color? textGrey,
      Color? textPrimary,
      Color? splash1,
      Color? splash2,
      Color? brownTextColor,
      Color? errorBoxColor,
      Color? claimMessageBlueColor,
      Color? claimMessageBlueBorderColor,
      Color? profileBGColor,
      Color? colorIconBlack,
      Color? colorIconDefault}) {
    return AppColors(
        colorPrimary1: colorPrimary1 ?? this.colorPrimary1,
        colorPrimary2: colorPrimary2 ?? this.colorPrimary2,
        colorPrimary3: colorPrimary3 ?? this.colorPrimary3,
        colorPrimary4: colorPrimary4 ?? this.colorPrimary4,
        colorPrimary5: colorPrimary5 ?? this.colorPrimary5,
        colorPrimary6: colorPrimary6 ?? this.colorPrimary6,
        colorPrimary7: colorPrimary7 ?? this.colorPrimary7,
        colorPrimary8: colorPrimary8 ?? this.colorPrimary8,
        colorPrimary9: colorPrimary9 ?? this.colorPrimary9,
        colorGrey1: colorGrey1 ?? this.colorGrey1,
        colorGrey2: colorGrey2 ?? this.colorGrey2,
        colorGrey3: colorGrey3 ?? this.colorGrey3,
        colorGrey4: colorGrey4 ?? this.colorGrey4,
        colorGrey5: colorGrey5 ?? this.colorGrey5,
        colorGrey6: colorGrey6 ?? this.colorGrey6,
        colorGrey7: colorGrey7 ?? this.colorGrey7,
        colorGrey8: colorGrey8 ?? this.colorGrey8,
        colorGrey9: colorGrey9 ?? this.colorGrey9,
        colorGrey10: colorGrey10 ?? this.colorGrey10,
        colorGrey11: colorGrey11 ?? this.colorGrey11,
        colorNeutral5: colorNeutral5 ?? this.colorNeutral5,
        colorNeutral6: colorNeutral6 ?? this.colorNeutral6,
        colorNeutral7: colorNeutral7 ?? this.colorNeutral7,
        colorNeutral8: colorNeutral8 ?? this.colorNeutral8,
        colorInformative1: colorInformative1 ?? this.colorInformative1,
        colorInformative2: colorInformative2 ?? this.colorInformative2,
        colorInformative3: colorInformative3 ?? this.colorInformative3,
        colorInformative4: colorInformative4 ?? this.colorInformative4,
        colorInformative5: colorInformative5 ?? this.colorInformative5,
        colorInformative6: colorInformative6 ?? this.colorInformative6,
        colorPositive1: colorPositive1 ?? this.colorPositive1,
        colorPositive2: colorPositive2 ?? this.colorPositive2,
        colorPositive3: colorPositive3 ?? this.colorPositive3,
        colorPositive4: colorPositive4 ?? this.colorPositive4,
        colorPositive5: colorPositive5 ?? this.colorPositive5,
        colorPositive6: colorPositive6 ?? this.colorPositive6,
        colorPositive7: colorPositive7 ?? this.colorPositive7,
        colorNotice1: colorNotice1 ?? this.colorNotice1,
        colorNotice2: colorNotice2 ?? this.colorNotice2,
        colorNotice3: colorNotice3 ?? this.colorNotice3,
        colorNotice4: colorNotice4 ?? this.colorNotice4,
        colorNotice5: colorNotice5 ?? this.colorNotice5,
        colorNotice6: colorNotice6 ?? this.colorNotice6,
        colorNotice7: colorNotice7 ?? this.colorNotice7,
        colorNegative1: colorNegative1 ?? this.colorNegative1,
        colorNegative2: colorNegative2 ?? this.colorNegative2,
        colorNegative3: colorNegative3 ?? this.colorNegative3,
        colorNegative4: colorNegative4 ?? this.colorNegative4,
        colorNegative5: colorNegative5 ?? this.colorNegative5,
        colorNegative6: colorNegative6 ?? this.colorNegative6,
        colorWhite: colorWhite ?? this.colorWhite,
        colorTextFieldBg: colorTextFieldBg ?? this.colorTextFieldBg,
        colorBlack: colorBlack ?? this.colorBlack,
        colorCarousel: colorCarousel ?? this.colorCarousel,
        colorBorderColor: colorBorderColor ?? this.colorBorderColor,
        containerBorderColor: containerBorderColor ?? this.containerBorderColor,
        containerBGColor: containerBGColor ?? this.containerBGColor,
        successGreenColor: successGreenColor ?? this.successGreenColor,
        errorRedColor: errorRedColor ?? this.errorRedColor,
        grayColor: grayColor ?? this.grayColor,
        emptyViewSubtextColor:
            emptyViewSubtextColor ?? this.emptyViewSubtextColor,
        readMoreTextColor: readMoreTextColor ?? this.readMoreTextColor,
        errorColor: errorColor ?? this.errorColor,
        grayTextColor: grayTextColor ?? this.grayTextColor,
        errorBoderColor: errorBoderColor ?? this.errorBoderColor,
        dropDownBorderColor: dropDownBorderColor ?? dropDownBorderColor,
        dropDownBGColor: dropDownBGColor ?? this.dropDownBGColor,
        labelTextColor: labelTextColor ?? this.labelTextColor,
        checkBoxColor: checkBoxColor ?? this.checkBoxColor,
        searchButtonColor: searchButtonColor ?? this.searchButtonColor,
        bottomSheetTitleColor:
            bottomSheetTitleColor ?? this.bottomSheetTitleColor,
        greenTextColor: greenTextColor ?? this.greenTextColor,
        tabColor: tabColor ?? this.tabColor,
        textGrey: textGrey ?? this.textGrey,
        textPrimary: textPrimary ?? this.textPrimary,
        splash1: splash1 ?? this.splash1,
        splash2: splash2 ?? this.splash2,
        brownTextColor: brownTextColor ?? this.brownTextColor,
        errorBoxColor: errorBoxColor ?? this.errorBoxColor,
        claimMessageBlueColor:
            claimMessageBlueColor ?? this.claimMessageBlueColor,
        claimMessageBlueBorderColor:
            claimMessageBlueBorderColor ?? this.claimMessageBlueBorderColor,
        profileBGColor: profileBGColor ?? this.profileBGColor,
        colorIconBlack: colorIconBlack ?? this.colorIconBlack,
        colorIconDefault: colorIconDefault ?? this.colorIconDefault);
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
        colorPrimary1: Color.lerp(colorPrimary1, other.colorPrimary1, t),
        colorPrimary2: Color.lerp(colorPrimary2, other.colorPrimary2, t),
        colorPrimary3: Color.lerp(colorPrimary3, other.colorPrimary3, t),
        colorPrimary4: Color.lerp(colorPrimary4, other.colorPrimary4, t),
        colorPrimary5: Color.lerp(colorPrimary5, other.colorPrimary5, t),
        colorPrimary6: Color.lerp(colorPrimary6, other.colorPrimary6, t),
        colorPrimary7: Color.lerp(colorPrimary7, other.colorPrimary7, t),
        colorPrimary8: Color.lerp(colorPrimary8, other.colorPrimary8, t),
        colorPrimary9: Color.lerp(colorPrimary9, other.colorPrimary9, t),
        colorGrey1: Color.lerp(colorGrey1, other.colorGrey1, t),
        colorGrey2: Color.lerp(colorGrey2, other.colorGrey2, t),
        colorGrey3: Color.lerp(colorGrey3, other.colorGrey3, t),
        colorGrey4: Color.lerp(colorGrey4, other.colorGrey4, t),
        colorGrey5: Color.lerp(colorGrey5, other.colorGrey5, t),
        colorGrey6: Color.lerp(colorGrey6, other.colorGrey6, t),
        colorGrey7: Color.lerp(colorGrey7, other.colorGrey7, t),
        colorGrey8: Color.lerp(colorGrey8, other.colorGrey8, t),
        colorGrey9: Color.lerp(colorGrey9, other.colorGrey9, t),
        colorGrey10: Color.lerp(colorGrey10, other.colorGrey10, t),
        colorGrey11: Color.lerp(colorGrey11, other.colorGrey11, t),
        colorNeutral5: Color.lerp(colorNeutral5, other.colorNeutral5, t),
        colorNeutral6: Color.lerp(colorNeutral6, other.colorNeutral6, t),
        colorNeutral7: Color.lerp(colorNeutral7, other.colorNeutral7, t),
        colorNeutral8: Color.lerp(colorNeutral8, other.colorNeutral8, t),
        colorInformative1:
            Color.lerp(colorInformative1, other.colorInformative1, t),
        colorInformative2:
            Color.lerp(colorInformative2, other.colorInformative2, t),
        colorInformative3:
            Color.lerp(colorInformative3, other.colorInformative3, t),
        colorInformative4:
            Color.lerp(colorInformative4, other.colorInformative4, t),
        colorInformative5:
            Color.lerp(colorInformative5, other.colorInformative5, t),
        colorInformative6:
            Color.lerp(colorInformative6, other.colorInformative6, t),
        colorPositive1: Color.lerp(colorPositive1, other.colorPositive1, t),
        colorPositive2: Color.lerp(colorPositive2, other.colorPositive2, t),
        colorPositive3: Color.lerp(colorPositive3, other.colorPositive3, t),
        colorPositive4: Color.lerp(colorPositive4, other.colorPositive4, t),
        colorPositive5: Color.lerp(colorPositive5, other.colorPositive5, t),
        colorPositive6: Color.lerp(colorPositive6, other.colorPositive6, t),
        colorPositive7: Color.lerp(colorPositive7, other.colorPositive7, t),
        colorNotice1: Color.lerp(colorNotice1, other.colorNotice1, t),
        colorNotice2: Color.lerp(colorNotice2, other.colorNotice2, t),
        colorNotice3: Color.lerp(colorNotice3, other.colorNotice3, t),
        colorNotice4: Color.lerp(colorNotice4, other.colorNotice4, t),
        colorNotice5: Color.lerp(colorNotice5, other.colorNotice5, t),
        colorNotice6: Color.lerp(colorNotice6, other.colorNotice6, t),
        colorNotice7: Color.lerp(colorNotice7, other.colorNotice7, t),
        colorNegative1: Color.lerp(colorNegative1, other.colorNegative1, t),
        colorNegative2: Color.lerp(colorNegative2, other.colorNegative2, t),
        colorNegative3: Color.lerp(colorNegative3, other.colorNegative3, t),
        colorNegative4: Color.lerp(colorNegative4, other.colorNegative4, t),
        colorNegative5: Color.lerp(colorNegative5, other.colorNegative5, t),
        colorNegative6: Color.lerp(colorNegative6, other.colorNegative6, t),
        colorWhite: Color.lerp(colorWhite, other.colorWhite, t),
        colorTextFieldBg:
            Color.lerp(colorTextFieldBg, other.colorTextFieldBg, t),
        colorBlack: Color.lerp(colorBlack, other.colorBlack, t),
        colorCarousel: Color.lerp(colorCarousel, other.colorCarousel, t),
        colorBorderColor:
            Color.lerp(colorBorderColor, other.colorBorderColor, t),
        containerBorderColor:
            Color.lerp(containerBorderColor, other.containerBorderColor, t),
        containerBGColor:
            Color.lerp(containerBGColor, other.containerBGColor, t),
        successGreenColor:
            Color.lerp(successGreenColor, other.successGreenColor, t),
        errorRedColor: Color.lerp(errorRedColor, other.errorRedColor, t),
        grayColor: Color.lerp(grayColor, other.grayColor, t),
        emptyViewSubtextColor:
            Color.lerp(emptyViewSubtextColor, other.emptyViewSubtextColor, t),
        readMoreTextColor:
            Color.lerp(readMoreTextColor, other.readMoreTextColor, t),
        errorColor: Color.lerp(errorColor, other.errorColor, t),
        grayTextColor: Color.lerp(grayTextColor, other.grayTextColor, t),
        errorBoderColor: Color.lerp(errorBoderColor, other.errorBoderColor, t),
        dropDownBorderColor:
            Color.lerp(dropDownBorderColor, other.dropDownBorderColor, t),
        dropDownBGColor: Color.lerp(dropDownBGColor, other.dropDownBGColor, t),
        labelTextColor: Color.lerp(labelTextColor, other.labelTextColor, t),
        checkBoxColor: Color.lerp(checkBoxColor, other.checkBoxColor, t),
        searchButtonColor:
            Color.lerp(searchButtonColor, other.searchButtonColor, t),
        bottomSheetTitleColor:
            Color.lerp(bottomSheetTitleColor, other.bottomSheetTitleColor, t),
        greenTextColor: Color.lerp(greenTextColor, other.greenTextColor, t),
        tabColor: Color.lerp(tabColor, other.tabColor, t),
        textGrey: Color.lerp(textGrey, other.textGrey, t),
        textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
        splash1: Color.lerp(splash1, other.splash1, t),
        splash2: Color.lerp(splash2, other.splash2, t),
        brownTextColor: Color.lerp(brownTextColor, other.brownTextColor, t),
        errorBoxColor: Color.lerp(errorBoxColor, other.errorBoxColor, t),
        claimMessageBlueColor:
            Color.lerp(claimMessageBlueColor, other.claimMessageBlueColor, t),
        claimMessageBlueBorderColor: Color.lerp(
            claimMessageBlueBorderColor, other.claimMessageBlueBorderColor, t),
        profileBGColor: Color.lerp(profileBGColor, other.profileBGColor, t),
        colorIconBlack: Color.lerp(colorIconBlack, other.colorIconBlack, t),
        colorIconDefault:
            Color.lerp(colorIconDefault, other.colorIconDefault, t));
  }
}
