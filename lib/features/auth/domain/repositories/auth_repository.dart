import 'package:dartz/dartz.dart';
import 'package:workly_flutter/core/error/failures.dart';
import 'package:workly_flutter/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<Either<Failure, User>> getCurrentUser();
}
