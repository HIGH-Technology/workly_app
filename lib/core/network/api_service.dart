import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workly_flutter/core/constants/api_constants.dart';
import 'package:workly_flutter/core/network/api_clients/auth_api_client.dart';
import 'package:workly_flutter/core/network/api_clients/employee_api_client.dart';
import 'package:workly_flutter/core/network/api_clients/user_api_client.dart';

class ApiService {
  late final Dio _dio;
  late final AuthApiClient _authClient;
  late final UserApiClient _userClient;
  late final EmployeeApiClient _employeeClient;

  ApiService() {
    _dio = _createDio();
    _authClient = AuthApiClient(_dio);
    _userClient = UserApiClient(_dio);
    _employeeClient = EmployeeApiClient(_dio);
  }

  Dio _createDio() {
    final dio = Dio();

    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

    if (baseUrl.isEmpty) {
      if (Platform.isAndroid) {
        baseUrl = ApiConstants.emulatorUrl;
      } else if (Platform.isIOS) {
        baseUrl = ApiConstants.iosEmulatorUrl;
      } else {
        baseUrl = 'http://localhost:3001/api';
      }
    }

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  AuthApiClient get authClient => _authClient;
  UserApiClient get userClient => _userClient;
  EmployeeApiClient get employeeClient => _employeeClient;
}
