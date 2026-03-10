import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_profile_repository.dart';

class GetEmployerProfile {
  final EmployerProfileRepository repository;

  GetEmployerProfile(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return repository.getEmployerProfile();
  }
}
