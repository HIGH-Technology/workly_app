import 'package:equatable/equatable.dart';

enum UserRole { ADMIN, MANAGER, EMPLOYEE }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  @override
  List<Object> get props => [
    id,
    name,
    email,
    role,
    isActive,
    createdAt,
    updatedAt,
    token,
  ];
}
