import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/entities/user.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatus {
  final AuthRepository repository;

  CheckAuthStatus(this.repository);

  Stream<User?> watch() {
    return repository.authStateChanges();
  }

  Future<Either<Failure, User?>> checkInitial() async {
    return await repository.checkInitialStatus();
  }
}
