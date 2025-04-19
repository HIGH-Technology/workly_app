import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:workly_flutter/core/network/api_service.dart';
import 'package:workly_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workly_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:workly_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Registrar serviços
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Registrar repositórios
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiService>()),
  );

  // Registrar casos de uso
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  // Registrar blocs
  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt<LoginUseCase>()));
}
