import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:workly_flutter/core/network/api_service.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  ApiService get apiService => ApiService();
}
