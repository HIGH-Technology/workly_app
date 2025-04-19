import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:workly_flutter/core/error/exceptions.dart';
import 'package:workly_flutter/core/error/failures.dart';
import 'package:workly_flutter/core/network/api_service.dart';
import 'package:workly_flutter/features/auth/data/models/user_model.dart';
import 'package:workly_flutter/features/auth/domain/entities/user.dart';
import 'package:workly_flutter/features/auth/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.authClient.login({
        'email': email,
        'password': password,
      });

      final responseData = response.data;

      if (!_isLoginSuccessful(
        response.response.statusCode ?? 0,
        responseData,
      )) {
        final message = _extractErrorMessage(responseData);
        return Left(ServerFailure(message: message));
      }

      final userData = _extractUserData(responseData);
      final user = UserModel.fromJson(userData);

      return Right(user);
    } on DioException catch (e) {
      return _handleDioException(e);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  bool _isLoginSuccessful(int statusCode, dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return false;
    }

    if (responseData.containsKey('success')) {
      return responseData['success'] == true;
    }

    final isStatusOk = statusCode >= 200 && statusCode < 300;
    final hasToken =
        responseData.containsKey('token') ||
        responseData.containsKey('access_token') ||
        (responseData['data'] is Map &&
            (responseData['data'] as Map).containsKey('access_token'));

    final hasSuccessMessage =
        responseData['message'] is String &&
        (responseData['message'] as String).toLowerCase().contains('sucesso');

    return isStatusOk || hasToken || hasSuccessMessage;
  }

  Map<String, dynamic> _extractUserData(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return {'token': ''};
    }

    final Map<String, dynamic> userData = {};

    if (responseData.containsKey('data') && responseData['data'] is Map) {
      final data = responseData['data'] as Map<String, dynamic>;

      if (data.containsKey('access_token') && data.containsKey('user')) {
        final accessToken = data['access_token'].toString();
        final userInfo = data['user'] as Map<String, dynamic>;

        userData.addAll(userInfo);
        userData['token'] = accessToken;
        return userData;
      }

      if (data.containsKey('access_token')) {
        userData['token'] = data['access_token'].toString();
      }

      userData.addAll(data);
      return userData;
    }

    if ((responseData.containsKey('token') ||
            responseData.containsKey('access_token')) &&
        responseData.containsKey('user')) {
      final token =
          responseData['token']?.toString() ??
          responseData['access_token']?.toString() ??
          '';
      final user = responseData['user'] as Map<String, dynamic>;

      userData.addAll(user);
      userData['token'] = token;
      return userData;
    }

    if (responseData.containsKey('token')) {
      userData['token'] = responseData['token'].toString();
    } else if (responseData.containsKey('access_token')) {
      userData['token'] = responseData['access_token'].toString();
    }

    userData.addAll(responseData);
    return userData;
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return 'Falha na autenticação';
    }

    return responseData['message']?.toString() ??
        responseData['error']?.toString() ??
        'Falha na autenticação';
  }

  Either<Failure, User> _handleDioException(DioException e) {
    if (e.error is SocketException) {
      return const Left(
        NetworkFailure(
          message:
              'Não foi possível conectar ao servidor. Verifique sua conexão.',
        ),
      );
    }

    if (e.response?.statusCode == 401) {
      return const Left(AuthFailure(message: 'Email ou senha incorretos'));
    }

    final message =
        e.response?.data is Map
            ? e.response?.data['message']?.toString()
            : null;

    return Left(
      ServerFailure(message: message ?? 'Erro na comunicação com o servidor'),
    );
  }

  @override
  Future<void> logout() async {
    // Implementação futura
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return const Left(ServerFailure(message: 'Não implementado'));
  }
}
