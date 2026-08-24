import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/datasources/vacancies_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancies_repository.dart';

class VacanciesRepositoryImpl implements VacanciesRepository {
  final VacanciesRemoteDataSource remoteDataSource;

  VacanciesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Vacancy>>> getMyVacancies({int page = 1, int limit = 50}) async {
    try {
      final vacancies = await remoteDataSource.getMyVacancies(page: page, limit: limit);
      return Right(vacancies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vacancy>> createVacancy(Map<String, dynamic> data) async {
    try {
      final vacancy = await remoteDataSource.createVacancy(data);
      return Right(vacancy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vacancy>> updateVacancy(String id, Map<String, dynamic> data) async {
    try {
      final vacancy = await remoteDataSource.updateVacancy(id, data);
      return Right(vacancy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeVacancyStatus(String id, String status) async {
    try {
      await remoteDataSource.changeVacancyStatus(id, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVacancy(String id) async {
    try {
      await remoteDataSource.deleteVacancy(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
