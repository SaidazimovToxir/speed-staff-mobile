import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/data/datasources/vacancy_feed_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/paginated_vacancies.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/repositories/vacancy_feed_repository.dart';

class VacancyFeedRepositoryImpl implements VacancyFeedRepository {
  final VacancyFeedRemoteDataSource _dataSource;

  VacancyFeedRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PaginatedVacancies>> getVacancyFeed({
    String? position, String? city, String? workType,
    int? salaryMin, int? salaryMax, int page = 1, int limit = 20,
  }) async {
    try {
      final result = await _dataSource.getVacancyFeed(
        position: position, city: city, workType: workType,
        salaryMin: salaryMin, salaryMax: salaryMax, page: page, limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PaginatedVacancies>> searchVacancies({
    String? q, String? position, String? city, String? workType,
    int page = 1, int limit = 20,
  }) async {
    try {
      final result = await _dataSource.searchVacancies(q: q, position: position, city: city, workType: workType, page: page, limit: limit);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Vacancy>> getVacancyDetail(String vacancyId) async {
    try {
      final result = await _dataSource.getVacancyDetail(vacancyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveVacancy(String vacancyId) async {
    try {
      final result = await _dataSource.saveVacancy(vacancyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeSavedVacancy(String vacancyId) async {
    try {
      final result = await _dataSource.removeSavedVacancy(vacancyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PaginatedVacancies>> getSavedVacancies({int page = 1, int limit = 50}) async {
    try {
      final result = await _dataSource.getSavedVacancies(page: page, limit: limit);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
