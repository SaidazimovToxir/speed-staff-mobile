import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class GetCandidateDetails {
  final ApplicationsRepository repository;

  GetCandidateDetails(this.repository);

  Future<Either<Failure, CandidateEntity>> call(String candidateId) {
    return repository.getCandidateDetails(candidateId);
  }
}
