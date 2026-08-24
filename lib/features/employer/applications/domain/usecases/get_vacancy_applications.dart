import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class GetVacancyApplicationsParams {
  final String vacancyId;
  final String? status;
  final int page;
  final int limit;

  const GetVacancyApplicationsParams({
    required this.vacancyId,
    this.status,
    this.page = 1,
    this.limit = 50,
  });
}

class GetVacancyApplications implements UseCase<PaginatedApplications, GetVacancyApplicationsParams> {
  final ApplicationsRepository repository;
  GetVacancyApplications(this.repository);

  @override
  Future<Either<Failure, PaginatedApplications>> call(GetVacancyApplicationsParams params) {
    return repository.getVacancyApplications(
      params.vacancyId,
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}
