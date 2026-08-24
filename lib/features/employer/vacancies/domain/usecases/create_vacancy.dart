import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancies_repository.dart';

class CreateVacancy {
  final VacanciesRepository repository;

  CreateVacancy(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> vacancyData) {
    return repository.createVacancy(vacancyData);
  }
}
