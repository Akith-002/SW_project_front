import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';

class PasswordResetRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  PasswordResetRemoteDataSource({required this.dioClient});

  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await dioClient.post(
        '/Auth/request-password-reset',
        data: {'email': email},
      );
      _logger.d('RequestPasswordReset response: \\${response.data}');
      if (response.statusCode != 200) {
        throw Exception(
            response.data['message'] ?? 'Failed to request password reset');
      }
    } on DioException catch (e) {
      _logger.e('DioException: \\${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      _logger.e('Exception: \\${e.toString()}');
      throw Exception('Failed to request password reset');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await dioClient.post(
        '/Auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      _logger.d('VerifyOtp response: \\${response.data}');
      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Invalid or expired OTP');
      }
    } on DioException catch (e) {
      _logger.e('DioException: \\${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      _logger.e('Exception: \\${e.toString()}');
      throw Exception('Failed to verify OTP');
    }
  }

  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      final response = await dioClient.post(
        '/Auth/reset-password',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );
      _logger.d('ResetPassword response: \\${response.data}');
      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      _logger.e('DioException: \\${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      _logger.e('Exception: \\${e.toString()}');
      throw Exception('Failed to reset password');
    }
  }
}
