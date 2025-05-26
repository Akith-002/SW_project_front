import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installer_info/installer_info.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/router/services/router_services.dart';
import 'package:land_asset_valuation/application/core/services/platform_services.dart';
import 'package:land_asset_valuation/application/core/utils/app_constants.dart';
import 'package:land_asset_valuation/application/core/utils/device_info.dart';
import 'package:land_asset_valuation/application/core/utils/enums.dart';
import 'package:land_asset_valuation/application/pages/security/security_failure_view.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';
import 'package:land_asset_valuation/flavors/flavor_banner.dart';
import 'package:land_asset_valuation/injection.dart';

import 'dart:developer' as dev;

abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<Page extends BasePage> extends State<Page> {
  bool isRealDevice = true,
      isRealDevice2 = true,
      isJailBroken = false,
      isRoot = false,
      isRoot2 = false,
      isADBEnabled = false;

  SecurityFailureType _securityFailureType = SecurityFailureType.SECURE;
  final RouterServices routerServices = injection<RouterServices>();

  final bool _isProgressShow = false;
  int? isDoNotify;

  Widget buildView(BuildContext context);

  BaseCubit<BaseState<dynamic>> getCubit();

  int? existMessage = 0;

  final appShared = injection<AppSharedData>();
  InstallerInfo? installerInfo;

  @override
  void initState() {
    _initSecurityState();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        behavior: HitTestBehavior.translucent,
        child: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Future.delayed(Duration.zero, () async {});
            return FlavorBanner(
                child: BlocProvider<BaseCubit>(
              create: (_) => getCubit(),
              child: BlocListener<BaseCubit, BaseState>(
                listener: (context, state) {
                  if (state is APILoadingState) {
                  } else if (state is SessionExpireState) {
                  } else if (state is ConnectionFailureState) {
                  } else {}
                },
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Platform.isIOS ? 5 : 0),
                      child: _securityFailureType == SecurityFailureType.SECURE
                          ? buildView(context)
                          : SecurityFailureView(
                              securityFailureType: _securityFailureType),
                    ),
                  ),
                ),
              ),
            ));
          },
        ));
  }

  logout() async {}

  Future<void> _initSecurityState() async {
    if (AppConfig.isSourceVerificationAvailable) {
      installerInfo = await getInstallerInfo();
      if (installerInfo != null) {
        if (!(appMarkets.contains(installerInfo!.installerName))) {
          setState(() {
            _securityFailureType = SecurityFailureType.SOURCE;
          });
        }
      } else {
        setState(() {
          _securityFailureType = SecurityFailureType.SOURCE;
        });
      }
    }

    if (Platform.isAndroid) {
      if (AppConfig.isADBCheckAvailable) {
        isADBEnabled = await PlatformServices.getADBStatus;
        if (isADBEnabled) {
          dev.log("Debugging checked using native call");
          setState(() {
            _securityFailureType = SecurityFailureType.ADB;
          });
        }
      }
      if (AppConfig.isEmulatorCheckAvailable) {
        var deviceInfo = DeviceInfo();
        await deviceInfo.initDeviceInfo();
        if (deviceInfo.isRealDevice == false) {
          dev.log("Emulator");
          setState(() {
            _securityFailureType = SecurityFailureType.EMU;
          });
        }
      }
      if (AppConfig.isEmulatorCheckAvailable) {
        isRealDevice = await PlatformServices.isEmu;
        if (isRealDevice) {
          dev.log("Emlatr check 1st method!");
          setState(() {
            _securityFailureType = SecurityFailureType.EMU;
          });
        }
      }

      if (AppConfig.isEmulatorCheckAvailable) {
        isRealDevice2 = await PlatformServices.isRealDevice;
        if (isRealDevice2) {
          dev.log("Emlatr check 2nd method!");
          setState(() {
            _securityFailureType = SecurityFailureType.EMU;
          });
        }
      }

      if (AppConfig.isRootCheckAvailable) {
        isRoot = await PlatformServices.isRooted;
        if (isRoot) {
          dev.log("Rooted!");
          setState(() {
            _securityFailureType = SecurityFailureType.ROOT;
          });
        }
      }
      if (AppConfig.isRootCheckAvailable) {
        isRoot2 = await PlatformServices.isRoot;
        if (isRoot2) {
          dev.log("Rooted new!");
          setState(() {
            _securityFailureType = SecurityFailureType.ROOT;
          });
        }
      }
    } else if (Platform.isIOS) {
      if (AppConfig.isSimulatorCheckAvailable) {
        var deviceInfo = DeviceInfo();
        await deviceInfo.initDeviceInfo();
        if (deviceInfo.isRealDevice == false) {
          dev.log("Simulator");
          setState(() {
            _securityFailureType = SecurityFailureType.EMU;
          });
        }
      }
      if (AppConfig.isCheckJailBroken) {
        isJailBroken = await PlatformServices.isJailBroken;
        if (isJailBroken) {
          dev.log("Jail Broken!");
          setState(() {
            _securityFailureType = SecurityFailureType.JAILBROKEN;
          });
        }
      }
    }
    // _requestPermission();

    if (!mounted) return;
  }

  showAppDialog(){}

  void showProgress() {}

  hideProgressBar() {}
}
