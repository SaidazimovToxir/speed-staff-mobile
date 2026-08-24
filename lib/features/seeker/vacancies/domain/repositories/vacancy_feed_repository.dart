import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/paginated_vacancies.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';

abstract class VacancyFeedRepository {
  Future<Either<Failure, PaginatedVacancies>> getVacancyFeed({
    String? position,
    String? city,
    String? workType,
    int? salaryMin,
    int? salaryMax,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, PaginatedVacancies>> searchVacancies({
    String? q,
    String? position,
    String? city,
    String? workType,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, Vacancy>> getVacancyDetail(String vacancyId);

  Future<Either<Failure, String>> saveVacancy(String vacancyId);
  Future<Either<Failure, String>> removeSavedVacancy(String vacancyId);
  Future<Either<Failure, PaginatedVacancies>> getSavedVacancies({int page = 1, int limit = 50});
}
