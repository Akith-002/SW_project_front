import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/services/platform_services.dart';
import 'package:land_asset_valuation/application/core/utils/enums.dart';

class SecurityFailureView extends StatelessWidget {
  final SecurityFailureType securityFailureType;

  const SecurityFailureView({super.key, required this.securityFailureType});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(color: Colors.cyan),
        child: Stack(
          children: [
            Center(
              child: Text(
                getSecurityFailureMessage(),
                style:
                    const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            securityFailureType == SecurityFailureType.ADB
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: ElevatedButton(
                          child: const Text('Disable USB Debugging'),
                          onPressed: () {
                            PlatformServices.disableADB();
                          },
                        ) 
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      )),
    );
  }

  String getSecurityFailureMessage() {
     switch (securityFailureType) {
      case SecurityFailureType.ADB:
        return "Please Disable USB Debugging and \nRestart the Application";
      case SecurityFailureType.ROOT:
        return "Device is Rooted";
        case SecurityFailureType.JAILBROKEN:
        return "Device is Jail Broken";
      case SecurityFailureType.EMU:
        return "App is running on an Emulator";
      case SecurityFailureType.SECURE:
        return "";
      case SecurityFailureType.SOURCE:
        return "Source Verification Failed";
      case SecurityFailureType.HOOK:
        return "Hooking detected";
      case SecurityFailureType.DEBUGGER:
        return "Debugger detected";
      case SecurityFailureType.OBFUSCATION:
        return "Obfuscation detected";
      case SecurityFailureType.BINDING:
        return "Binding detected";
    }
  }
}
