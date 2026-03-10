import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/repositories/employer_home_repository.dart';

class GetRecentApplications {
  final EmployerHomeRepository repository;

  GetRecentApplications(this.repository);

  Future<Either<Failure, List<ApplicationEntity>>> call() {
    return repository.getRecentApplications();
  }
}
