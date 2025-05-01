import 'package:land_asset_valuation/application/core/utils/enums.dart';
import 'package:flutter/material.dart';

class FlavorValues {
  FlavorValues();
}

class FlavorConfig {
  final Flavor? flavor;
  final String? name;
  final Color? color;
  final FlavorValues? flavorValues;
  static FlavorConfig? _instance;

  factory FlavorConfig(
      {required Flavor flavor,
      Color color = Colors.blue,
      required FlavorValues flavorValues}) {
    _instance ??= FlavorConfig._internal(
      flavor,
      flavor.name.toString(),
      color,
      flavorValues,
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.flavorValues);

  static FlavorConfig? get instance {
    return _instance;
  }

  static bool isLive() => _instance?.flavor == Flavor.LIVE;

  static bool isDevelopment() => _instance?.flavor == Flavor.DEV;

  static bool isQA() => _instance?.flavor == Flavor.QA;

  static bool isUAT() => _instance?.flavor == Flavor.UAT;
  static bool isSIT() => _instance?.flavor == Flavor.SIT;
}