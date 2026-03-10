import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class GetVacancyApplications {
  final ApplicationsRepository repository;

  GetVacancyApplications(this.repository);

  Future<Either<Failure, List<CandidateEntity>>> call() {
    return repository.getVacancyApplications();
  }
}
