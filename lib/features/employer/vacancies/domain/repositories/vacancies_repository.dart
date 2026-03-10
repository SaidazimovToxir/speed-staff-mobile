import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';

abstract class VacanciesRepository {
  Future<Either<Failure, List<VacancyEntity>>> getMyVacancies();
  Future<Either<Failure, void>> createVacancy(Map<String, dynamic> vacancyData);
}
