import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _username;

  String? get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}
