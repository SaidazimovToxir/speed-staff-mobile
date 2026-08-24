import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

abstract class ApplicationsRepository {
  Future<Either<Failure, PaginatedApplications>> getVacancyApplications(
    String vacancyId, {
    String? status,
    int page = 1,
    int limit = 50,
  });

  Future<Either<Failure, ApplicationDetailEntity>> getApplicationDetail(
    String applicationId,
  );

  Future<Either<Failure, ApplicationDetailEntity>> updateApplicationStatus(
    String applicationId,
    String status, {
    String? employerNote,
  });
}
