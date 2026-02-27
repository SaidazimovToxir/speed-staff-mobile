import 'package:speed_staff_mobile/features/shared/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.id,
    super.fullName,
    super.email,
    super.birthDate,
    super.telephoneNumber,
    super.gender,
    super.avatar,
    super.role,
    super.isAuthenticated,
    super.needsProfileUpdate,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      birthDate: user.birthDate,
      telephoneNumber: user.telephoneNumber,
      gender: user.gender,
      avatar: user.avatar,
      role: user.role,
      isAuthenticated: user.isAuthenticated,
      needsProfileUpdate: user.needsProfileUpdate,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['full_name'] as String?;

    return UserModel(
      id: json['id'] as String?,
      fullName: fullName,
      email: json['email'] as String?,
      birthDate: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      telephoneNumber: json['telephone_number'] as String?,
      gender: json['gender'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      isAuthenticated: true,
      needsProfileUpdate: json['needs_profile_update'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'birthday': birthDate?.toIso8601String(),
      'telephone_number': telephoneNumber,
      'gender': gender,
      'avatar': avatar,
      'role': role,
      'needs_profile_update': needsProfileUpdate,
    };
  }
}
