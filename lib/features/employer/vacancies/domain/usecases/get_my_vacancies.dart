import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancies_repository.dart';

class GetMyVacancies {
  final VacanciesRepository repository;

  GetMyVacancies(this.repository);

  Future<Either<Failure, List<Vacancy>>> call({int page = 1, int limit = 50}) {
    return repository.getMyVacancies(page: page, limit: limit);
  }
}
