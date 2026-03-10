import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/data/datasources/employer_home_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/repositories/employer_home_repository.dart';

class EmployerHomeRepositoryImpl implements EmployerHomeRepository {
  final EmployerHomeRemoteDataSource remoteDataSource;

  EmployerHomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EmployerStatsEntity>> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getRecentApplications() async {
    try {
      final applications = await remoteDataSource.getRecentApplications();
      return Right(applications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
