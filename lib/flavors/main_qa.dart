
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:land_asset_valuation/application/base_app.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/services/text_scale_factor.dart';
import 'package:land_asset_valuation/application/core/utils/enums.dart';
import 'package:land_asset_valuation/flavors/flavor_config.dart';
import 'package:land_asset_valuation/injection.dart' as di;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:provider/provider.dart' as provider;
import 'package:land_asset_valuation/application/pages/mapbox/mapbox_setup.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
//   dev.log(message?.notification?.body??"");
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp();
//   }
//   //If you want overide notifications in background and terminate state use this
//   //Only work if you send data messages from FCM
//   //If you send Data and Notification from FCM same time dont use this because it gets duplicate notification
//   // if (message?.notification == null) {
//   // await LocalPushManager.initialize();
//   // await LocalPushManager.instance?.showNotification(LocalNotification(
//   //         id: message.hashCode,
//   //         title: message?.data["title"] ?? "",
//   //         body:message?.data["body"] ?? ""));
//   // }

// }

// void _huaweiMessagingBackgroundHandler(
//     PushKit.RemoteMessage remoteMessage) async {
//   if (remoteMessage.notification != null) {
//     PushKit.Push.localNotification({
//       PushKit.HMSLocalNotificationAttr.TITLE: remoteMessage.notification!.title,
//       PushKit.HMSLocalNotificationAttr.MESSAGE: remoteMessage.notification!.body
//     });
//   }
// }
// late LocalPushManager localPushManager;

Future<void> main() async {
  // localPushManager = LocalPushManager.init();
  FlavorConfig(
      flavor: Flavor.QA,
      color: Colors.deepOrange,
      flavorValues: FlavorValues());

  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.deviceOS == DeviceOS.ANDROID) {
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // await _configureFirebaseNotification();
    //   await LocalPushManager.initialize();
    //   try {
    //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //   } catch (e) {
    //     dev.log('Firebase : ${e.toString()}');
    //   }
    // } else {
    //   PushKit.Push.registerBackgroundMessageHandler(
    //       _huaweiMessagingBackgroundHandler);
  }

  await di.init();
  // Call Mapbox setup
  await setupMapbox();


  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(provider.ChangeNotifierProvider<TextScaleFactorModel>(
    create: (_) => TextScaleFactorModel(),
    child: const ProviderScope(child: VD()),
  ));

  // runApp(const ProviderScope(child: DLB()));
  // configLoading();
}

// _configureFirebaseNotification() async {
//   //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   final isAndroid = Platform.isAndroid;
//   final isIOS = Platform.isIOS;
//   if (isAndroid) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.android,
//     );
//   } else if (isIOS) {
//     await Firebase.initializeApp(
//       name: "DLB_Sweep",
//       options: DefaultFirebaseOptions.ios,
//     );
//   }
//
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     if (message != null) {
//       _handleFCM(message);
//     }
//   });
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     _handleFCM(message);
//   });
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     _handleFCM(message);
//   });
// }
//
//
// _handleFCM(RemoteMessage message) async {
//   PrintInfo("Received Notification!");
//
//   String deviceType = await DeviceInfo().getMobileOS();
//
//   switch (deviceType) {
//     case "Android":
//       if (message.data != null) {
//         // FcmAndroidBodyModel fcm = FcmAndroidBodyModel.fromJson(jsonDecode(message.data["body"]));
//         FcmAndroidBodyModel fcm = FcmAndroidBodyModel();
//         fcm.title = message.notification!.title;
//         fcm.body = message.notification!.body;
//         fcm.imageUrl = message.notification!.android!.imageUrl;
//         fcm.routingPath = message.data['routingPath'];
//
//         localPushManager.showNotification(
//           LocalNotification(
//             title: fcm.title!,
//             body: fcm.body!,
//           ),
//         );
//       }
//       break;
//     case "Apple inc. IOS":
//       if (message.data != null) {
//         // FcmIosBodyModel fcm =
//         //     fcmIosBodyModelFromJson(jsonEncode(message.data));
//         // localPushManager.showNotification(
//         //   LocalNotification(
//         //     title: fcm.title!,
//         //     body: fcm.body!,
//         //   ),
//         // );
//       }
//       break;
//   }
// }

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.green
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.blue.withOpacity(0.3)
//     ..userInteractions = false
//     ..dismissOnTap = false;
// }
