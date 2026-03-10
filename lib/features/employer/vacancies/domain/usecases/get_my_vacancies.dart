import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancies_repository.dart';

class GetMyVacancies {
  final VacanciesRepository repository;

  GetMyVacancies(this.repository);

  Future<Either<Failure, List<VacancyEntity>>> call() {
    return repository.getMyVacancies();
  }
}
