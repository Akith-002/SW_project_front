

import 'package:flutter/cupertino.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

import '../../utils/app_constants.dart';

class RouterServices with ChangeNotifier{

  final AppSharedData appSharedData;
  RouterServices({ required this.appSharedData});
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLanguageSelected = false;
  bool get isLanguageSelected => appSharedData.getDataBool("LANG")??_isLanguageSelected;

  bool _isResetPin = false;
  bool get isResetPin => _isResetPin;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isPinSet= false;
  bool get isPinSet => appSharedData.getDataBool("PIN");



  // bool _isLoggedOut = false;
  // bool get isLoggedOut  =>  appSharedData.getData(AppConstants.userSignUpComplete)!="" ;

  bool _isAllReadyLogged = false;
  bool get isAllReadyLogged =>   appSharedData.getData(AppConstants.deviceID)!="" &&  appSharedData.getData(AppConstants.userSignUpComplete)!="" && appSharedData.getData(AppConstants.userAllReadyLogin)== "true";

  double _isChangeFont= 0.86;
  double get isChangeFont => _isChangeFont;

  // bool _isOTPComplete= false;
  // bool get isOTPComplete => _isOTPComplete;

  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  set isLanguageSelected(bool value) {
    _isLanguageSelected= value;
    appSharedData.setDataBool("LANG", value);
    notifyListeners();
  }

  set isResetPinSelected(bool value) {
    _isResetPin= value;
    notifyListeners();
  }

  set isSignedIn(bool value) {
    _isSignedIn = value;
    notifyListeners();
  }

  set isPinSet(bool value) {
    _isPinSet = value;
    appSharedData.setDataBool("PIN", value);
    notifyListeners();
  }


  set isAllReadyLogged(bool value) {
    _isAllReadyLogged = value;
    notifyListeners();
  }


  set isChangeFont(double value) {
  _isChangeFont = value;
    notifyListeners();
  }

  // set isPinComplete(bool value) {
  //   _isPinComplete = value;
  //   notifyListeners();
  // }

  // set isOTPComplete(bool value) {
  //   _isOTPComplete = value;
  //   notifyListeners();
  // }
}