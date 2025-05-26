import 'package:shared_preferences/shared_preferences.dart';

const String accessToken = "accessToken";
const String PUSH_TOKEN = 'FCMPUSHIDNAME';

class AppSharedData {
  late SharedPreferences secureStorage;

  AppSharedData(SharedPreferences preferences) {
    secureStorage = preferences;
  }

  setData(String key, String value) {
    secureStorage.setString(key, value);
  }

  String getData(String key) {
    if (secureStorage.containsKey(key)) {
      return secureStorage.getString(key)!;
    } else {
      return "";
    }
  }

  bool hasData(String key) {
    return secureStorage.containsKey(key);
  }

  clearData(String key) {
    secureStorage.remove(key);
  }


  setDataBool(String key, bool value) {
    secureStorage.setBool(key, value);
  }

  bool getDataBool(String key) {
    if (secureStorage.containsKey(key)) {
      return secureStorage.getBool(key)!;
    } else {
      return false;
    }
  }



}
