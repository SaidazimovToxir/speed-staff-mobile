import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/datasources/vacancies_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancies_repository.dart';

class VacanciesRepositoryImpl implements VacanciesRepository {
  final VacanciesRemoteDataSource remoteDataSource;

  VacanciesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VacancyEntity>>> getMyVacancies() async {
    try {
      final vacancies = await remoteDataSource.getMyVacancies();
      return Right(vacancies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createVacancy(Map<String, dynamic> vacancyData) async {
    try {
      await remoteDataSource.createVacancy(vacancyData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
