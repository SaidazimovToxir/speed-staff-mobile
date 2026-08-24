import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';

abstract class VacanciesRepository {
  Future<Either<Failure, List<Vacancy>>> getMyVacancies({int page = 1, int limit = 50});
  Future<Either<Failure, Vacancy>> createVacancy(Map<String, dynamic> data);
  Future<Either<Failure, Vacancy>> updateVacancy(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> changeVacancyStatus(String id, String status);
  Future<Either<Failure, void>> deleteVacancy(String id);
}
