import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/secure_storage.dart';
import 'package:land_asset_valuation/data/datasource/remote/password_reset_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/auth/login_request.dart';
import 'package:land_asset_valuation/data/models/auth/login_response.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'dart:convert'; // Added for jsonDecode

abstract class AuthRepository {
  Future<Either<Exception, LoginResponse>> login(LoginRequest request);
  Future<Either<Exception, bool>> logout(String username);
  Future<Either<Exception, bool>> forgotPassword(String username);
  // Password reset flow
  Future<Either<Exception, bool>> requestPasswordReset(String email);
  Future<Either<Exception, bool>> verifyOtp(String email, String otp);
  Future<Either<Exception, bool>> resetPassword(
      String email, String otp, String newPassword);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;
  final PasswordResetRemoteDataSource _passwordResetRemoteDataSource;

  AuthRepositoryImpl(this._dio, this._secureStorage)
      : _passwordResetRemoteDataSource = PasswordResetRemoteDataSource(
          dioClient: DioClient(_dio),
        );

  @override
  Future<Either<Exception, LoginResponse>> login(LoginRequest request) async {
    try {
      if (kDebugMode) {
        print('Base URL: ${_dio.options.baseUrl}');
        print('Full URL: ${_dio.options.baseUrl}Auth/login');
        print('Request data: ${request.toJson()}');
      }

      final response = await _dio.post(
        'Auth/login',
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Store the token securely
        await _secureStorage.write('token', loginResponse.token);
        await _secureStorage.write('username', loginResponse.username);
        await _secureStorage.write('empName', loginResponse.empName);
        await _secureStorage.write('empEmail', loginResponse.empEmail);
        await _secureStorage.write('empId', loginResponse.empId);
        await _secureStorage.write('id', loginResponse.id.toString());
        await _secureStorage.write('position', loginResponse.position);
        await _secureStorage.write('division', loginResponse.division);

        return Right(loginResponse);
      } else {
        final message = response.data['message'] ?? 'Login failed';
        if (kDebugMode) {
          print('Login failed with message: $message');
        }
        return Left(ServerException(message: message));
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioError type: ${e.type}');
        print('DioError message: ${e.message}');
        print('DioError response: ${e.response}');
        print('DioError error: ${e.error}');
      }

      String? errorMessage;
      // Try to extract error message from backend
      if (e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else if (e.response?.data is String) {
          try {
            final decoded = jsonDecode(e.response?.data);
            if (decoded is Map && decoded['message'] != null) {
              errorMessage = decoded['message'];
            }
          } catch (_) {}
        }
      }
      if (errorMessage != null) {
        if (kDebugMode) {
          print('Server error message: $errorMessage');
        }
        return Left(DioErrorException(message: errorMessage));
      }

      errorMessage = 'Network error occurred. Please check your connection.';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timeout. Please try again.';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Send timeout. Please try again.';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Receive timeout. Please try again.';
          break;
        case DioExceptionType.badResponse:
          errorMessage =
              'Server error (${e.response?.statusCode}). Please try again.';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request cancelled.';
          break;
        case DioExceptionType.connectionError:
          errorMessage =
              'Connection error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Network error occurred. Please try again.';
      }

      if (kDebugMode) {
        print('Final error message: $errorMessage');
      }
      return Left(DioErrorException(message: errorMessage));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> logout(String username) async {
    try {
      final response = await _dio.post(
        'Auth/logout',
        data: {'username': username},
      );

      if (response.statusCode == 200) {
        // Clear all secure storage data
        await _secureStorage.deleteAll();
        return const Right(true);
      } else {
        final message = response.data['message'] ?? 'Logout failed';
        return Left(ServerException(message: message));
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['message'] != null) {
        return Left(DioErrorException(message: e.response?.data['message']));
      }
      return Left(DioErrorException(
          message: 'Network error occurred. Please check your connection.'));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> forgotPassword(String username) async {
    try {
      final response = await _dio.post(
        'Auth/forgot-password',
        data: {'username': username},
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final message =
            response.data['message'] ?? 'Password reset request failed';
        return Left(ServerException(message: message));
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['message'] != null) {
        return Left(DioErrorException(message: e.response?.data['message']));
      }
      return Left(DioErrorException(
          message: 'Network error occurred. Please check your connection.'));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> requestPasswordReset(String email) async {
    try {
      await _passwordResetRemoteDataSource.requestPasswordReset(email);
      return const Right(true);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> verifyOtp(String email, String otp) async {
    try {
      await _passwordResetRemoteDataSource.verifyOtp(email, otp);
      return const Right(true);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      await _passwordResetRemoteDataSource.resetPassword(
          email, otp, newPassword);
      return const Right(true);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
