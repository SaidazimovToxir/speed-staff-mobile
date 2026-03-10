import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class UpdateApplicationStatus {
  final ApplicationsRepository repository;

  UpdateApplicationStatus(this.repository);

  Future<Either<Failure, String>> call(String newStatus) {
    return repository.updateApplicationStatus(newStatus);
  }
}
