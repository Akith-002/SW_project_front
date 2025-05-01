import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class AppPermissionManager {
  static requestCameraPermission(
      BuildContext context, VoidCallback onGranted) async {
    if (await Permission.camera.request().isGranted) {
      onGranted();
    }
  }

  static requestExternalStoragePermission(
      BuildContext context, VoidCallback onGranted) async {
    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted) {
        onGranted();
      }
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (int.parse(androidInfo.version.release.toString()) >= 13) {
        onGranted();
      } else {
        if (await Permission.storage.request().isGranted) {
          onGranted();
        }
      }
    }
  }

  static requestGalleryPermission(
      BuildContext context, VoidCallback onGranted) async {
    if (await Permission.mediaLibrary.request().isGranted) {
      onGranted();
    }
  }

  static requestReadPhoneStatePermission(
      BuildContext context, VoidCallback onGranted) async {
    if (Platform.isIOS) {
      onGranted();
    } else if (await Permission.phone.request().isGranted) {
      onGranted();
    }
  }
}
