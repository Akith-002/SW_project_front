import 'package:dio/dio.dart';
import 'package:land_asset_valuation/data/datasource/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Get the token from secure storage
    final String? token = await secureStorage.read('token');

    if (token != null && token.isNotEmpty) {
      // Add Bearer token to authorization header
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    handler.next(options);
  }
}
