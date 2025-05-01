import 'dart:typed_data';

const kFontFamily = 'Roboto';

const String kPNGImagePath = 'images/pngs/';
const String kSVGImagePath = 'images/svgs/';
const String kAnimImagePath = 'images/animations/';

const String kSVGType = '.svg';
const String kPngType = '.png';
const String kAniType = '.json';

const String kLocaleEN = 'en';
const String kLocaleSI = 'si';
const String kLocaleTA = 'ta';

const double kLeftRightMarginOnBoarding = 16;
const double kTopMarginOnBoarding = 32;
const double kBottomMargin = 20;
const double kTextFieldBottomBorderHeight = 2;
const double kOnBoardingMarginBetweenFields = 25;
int currentIndex = 0;

class AppConstants {
  static const String DEVICE_TYPE_ANDROID = "ANDROID";
  static const String DEVICE_TYPE_HUAWEI = "HUAWEI";

  static const String VENDOR_ANDROID = 'com.android.vending';
  static const String VENDOR_HUAWEI = 'com.huawei.appmarket';
  static const String VENDOR_IOS = 'com.apple.AppStore';
  static const String TESTFLIGHT_IOS = 'com.apple.TestFlight';

  static bool IS_USER_LOGGED = false;
  static late DateTime TOKEN_EXPIRE_TIME;

  static int HUAWEI_ANDROID_VERSION = 12;
  static String language = "ENG";
  static const String FONT_SIZE = "FONT_SIZE";
  static String userSignUpComplete = "userSignUpComplete";
  static String userAllReadyLogin = "userAllReadyLogin";
  static String biometricData = "biometricData";
  static String idUser = "userID";
  static bool isNICAdded = false;

  // static double Medium = 0.86;
  // static double Large = 1;
  // static double Small = 0.5;
  static double fontSize = 0.86;

  static String accessToken = "";

  static String profileImg = '';
  static Uint8List? proImage;

  static String? phoneOrNic;
  static int? accountLockedTimer;

  static const routeSplash = "/splash";

  static String deviceID = 'DEVICE_ID';

  static int? userId;
  static String localCurrency = "LKR ";
  static String currency = "Rs. ";

  static String userName = "";
  static String userLastName = "";
  static String mobileNumber = "";

  static String isEnableBiometric = "IS_ENABLED_BIOMETRIC";

  static bool biometric = false;

  static String? pushID;
  static String latitude = "";
  static String longitude = "";
}

//AppMarkets
const List<String> appMarkets = [
  "com.android.vending",
  "com.amazon.venezia",
  "com.sec.android.app.samsungapps",
  "com.huawei.appmarket",
  "com.apple.AppStore",
  "com.apple.TestFlight",
  "com.apple.CoreSimulator"
];
