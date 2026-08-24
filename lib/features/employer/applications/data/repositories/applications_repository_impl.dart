import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/datasources/applications_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  final ApplicationsRemoteDataSource _dataSource;

  ApplicationsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PaginatedApplications>> getVacancyApplications(
    String vacancyId, {
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final result = await _dataSource.getVacancyApplications(
        vacancyId,
        status: status,
        page: page,
        limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationDetailEntity>> getApplicationDetail(
    String applicationId,
  ) async {
    try {
      final result = await _dataSource.getApplicationDetail(applicationId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationDetailEntity>> updateApplicationStatus(
    String applicationId,
    String status, {
    String? employerNote,
  }) async {
    try {
      final result = await _dataSource.updateApplicationStatus(
        applicationId,
        status,
        employerNote: employerNote,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
