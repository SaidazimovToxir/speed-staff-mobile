import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/datasources/applications_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  final ApplicationsRemoteDataSource remoteDataSource;

  ApplicationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CandidateEntity>>> getVacancyApplications() async {
    try {
      final applications = await remoteDataSource.getVacancyApplications();
      return Right(applications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> getCandidateDetails(String candidateId) async {
    try {
      final candidate = await remoteDataSource.getCandidateDetails(candidateId);
      return Right(candidate);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateApplicationStatus(String newStatus) async {
    try {
      final status = await remoteDataSource.updateApplicationStatus(newStatus);
      return Right(status);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
