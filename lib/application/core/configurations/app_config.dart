import 'package:land_asset_valuation/application/core/utils/enums.dart';
import 'package:flutter/foundation.dart';

const DeviceOS kDeviceOS = DeviceOS.ANDROID;

class AppConfig {
  static DeviceOS deviceOS = DeviceOS.ANDROID;

  ///Security Config
  static bool isRootCheckAvailable = false;
  static bool isCheckJailBroken = false;
  static bool isEmulatorCheckAvailable = false;
  static bool isSimulatorCheckAvailable = false;
  static bool isADBCheckAvailable = false;
  static bool isTamperDetection = false;

  static bool isSourceVerificationAvailable = false;

  static bool isEncryptionAvailable = true;
  static bool isSSLAvailable = false;

  ///UNSECURE CONNECTION WITHOUT SSL
  static bool isHttpOverride = false;

  // Base URL that works on both mobile devices and web
  static String get apiBaseUrl {
    // When running on an Android emulator, 10.0.2.2 redirects to the host machine's localhost
    // When running on iOS simulator, use 127.0.0.1
    // For physical devices, you need to use your computer's actual IP address

    if (kIsWeb) {
      // Web apps can use relative URLs or localhost
            return "http://127.0.0.1:5221/api/";

      // return "http://56.228.29.54:5000/api/";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emulator special IP that points to host machine
      return "http://10.0.2.2:5221/api/";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS simulator can use localhost
      return "http://127.0.0.1:5221/api/";
    } else {
      // For desktop or when platform can't be determined
      return "http://localhost:5221/api/";
    }

    // IMPORTANT: For physical devices, replace with your computer's IP address:
    // return "http://192.168.1.XXX:5221/api/";
  }
}
