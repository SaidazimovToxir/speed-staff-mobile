import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? fullName;
  final String? email;
  final DateTime? birthDate;
  final String? telephoneNumber;
  final String? gender;
  final String? avatar;
  final String? role;
  final bool isAuthenticated;
  final bool needsProfileUpdate;
  const User({
    this.id,
    this.fullName,
    this.email,
    this.birthDate,
    this.telephoneNumber,
    this.gender,
    this.avatar,
    this.role,
    this.isAuthenticated = false,
    this.needsProfileUpdate = false,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    DateTime? birthDate,
    String? telephoneNumber,
    String? gender,
    String? avatar,
    String? role,
    bool? isAuthenticated,
    bool? needsProfileUpdate,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      telephoneNumber: telephoneNumber ?? this.telephoneNumber,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      needsProfileUpdate: needsProfileUpdate ?? this.needsProfileUpdate,
    );
  }

  const User.empty()
    : this(
        id: null,
        fullName: null,
        email: null,
        birthDate: null,
        telephoneNumber: null,
        gender: null,
        avatar: null,
        role: null,
        isAuthenticated: false,
        needsProfileUpdate: false,
      );

  @override
  List<Object?> get props {
    return [id, fullName, email, birthDate, telephoneNumber, gender, avatar, role, isAuthenticated, needsProfileUpdate];
  }
}
