import 'package:land_asset_valuation/application/core/utils/enums.dart';

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
}
