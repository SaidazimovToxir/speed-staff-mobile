import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

abstract class ApplicationsRepository {
  Future<Either<Failure, List<CandidateEntity>>> getVacancyApplications();
  Future<Either<Failure, CandidateEntity>> getCandidateDetails(String candidateId);
  Future<Either<Failure, String>> updateApplicationStatus(String newStatus);
}
