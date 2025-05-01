import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'app_constants.dart';
import 'enums.dart';


class DeviceInfo {
  var release, sdkInt, manufacturer, model;
  var systemName, version, name;
  bool isRealDevice = true;

  initDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      try {
        release = androidInfo.version.release;
        AppConstants.HUAWEI_ANDROID_VERSION =
            int.parse(release.toString().split('.')[0]);
      } on Exception {
        AppConstants.HUAWEI_ANDROID_VERSION = 12;
      }
      sdkInt = androidInfo.version.sdkInt;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      isRealDevice = androidInfo.isPhysicalDevice;
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      systemName = iosInfo.systemName;
      version = iosInfo.systemVersion;
      name = iosInfo.name;
      model = iosInfo.model;
      isRealDevice = iosInfo.isPhysicalDevice;
    }
  }

  String getMobileManufacture() {
    if (Platform.isAndroid) {
      return 'Android';
    } else {
      return 'Apple';
    }
  }

  Future<String> getMobileOS() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      log("Manufacture is : ${androidInfo.manufacturer}");

      if (androidInfo.manufacturer.toLowerCase() == "huawei") {
        return "HUAWEI";
      }
      return "Android";
    } else if (Platform.isIOS) {
      log("Manufacture is : Apple inc. IOS");
      return "Apple inc. IOS";
    } else {
      return "HUAWEI";
    }
  }

  String getModel() {
    return model;
  }

  String getDeviceType() {
    if (AppConfig.deviceOS == DeviceOS.HUAWEI) {
      return AppConstants.DEVICE_TYPE_HUAWEI;
    } else if (AppConfig.deviceOS == DeviceOS.ANDROID) {
      return AppConstants.DEVICE_TYPE_ANDROID;
    } else {
      return name;
    }
  }
}
