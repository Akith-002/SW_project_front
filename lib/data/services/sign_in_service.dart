import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class SignInService {
  final AppSharedData sharedData;

  SignInService({required this.sharedData});

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://10.0.2.2:5221/api/Auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Store token using your AppSharedData
      sharedData.setData("accessToken", data["token"]);

      // You can also store additional info if needed
      sharedData.setData("username", data["username"]);
      sharedData.setData("empName", data["empName"]);

      return true;
    } else {
      return false;
    }
  }
}
