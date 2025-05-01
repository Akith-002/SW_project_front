import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

final appThemeProvider =
    StateProvider<AppThemeMode>((ref) => AppThemeMode.light);
