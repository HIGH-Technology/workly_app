import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:workly_flutter/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final token = _extractToken(json);

    final role = _convertRole(json['role']);

    final createdAt = _parseDateTime(json['createdAt']);
    final updatedAt = _parseDateTime(json['updatedAt']);

    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: role,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      token: token,
    );
  }

  static String _extractToken(Map<String, dynamic> json) {
    return json['token']?.toString() ?? json['access_token']?.toString() ?? '';
  }

  static UserRole _convertRole(dynamic roleValue) {
    if (roleValue == null) return UserRole.EMPLOYEE;

    final roleStr = roleValue.toString().toLowerCase();
    if (roleStr.contains('admin')) return UserRole.ADMIN;
    if (roleStr == 'manager') return UserRole.MANAGER;
    return UserRole.EMPLOYEE;
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();

    try {
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    final tokenPreview =
        token.isEmpty
            ? "vazio"
            : "${token.substring(0, token.length > 10 ? 10 : token.length)}...";

    return 'UserModel(id: $id, nome: $name, email: $email, role: $role, token: $tokenPreview)';
  }
}
