import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_profile_repository.dart';

class UpdateEmployerProfileUseCase {
  final EmployerProfileRepository repository;

  UpdateEmployerProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> data) {
    return repository.updateEmployerProfile(data);
  }
}
