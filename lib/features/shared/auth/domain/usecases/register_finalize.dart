import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/entities/user.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/repositories/auth_repository.dart';

class RegisterFinalize implements UseCase<User, RegisterFinalizeParams> {
  final AuthRepository repository;

  RegisterFinalize(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterFinalizeParams params) async {
    return await repository.finalizeRegistration(
      phone: params.phone,
      code: params.code,
      password: params.password,
      role: params.role,
      firstName: params.firstName,
      lastName: params.lastName,
      restaurantName: params.restaurantName,
    );
  }
}

class RegisterFinalizeParams extends Equatable {
  final String phone;
  final String code;
  final String password;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? restaurantName;

  const RegisterFinalizeParams({
    required this.phone,
    required this.code,
    required this.password,
    required this.role,
    this.firstName,
    this.lastName,
    this.restaurantName,
  });

  @override
  List<Object?> get props => [phone, code, password, role, firstName, lastName, restaurantName];
}
