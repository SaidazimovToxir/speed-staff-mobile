import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/datasources/employer_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_repository.dart';

class EmployerRepositoryImpl implements EmployerRepository {
  final EmployerRemoteDataSource remoteDataSource;

  EmployerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EmployerProfile>> createProfile(Map<String, dynamic> data) async {
    try {
      final profile = await remoteDataSource.createProfile(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployerProfile>> getOwnProfile() async {
    try {
      final profile = await remoteDataSource.getOwnProfile();
      return Right(profile);
    } on ServerException catch (e) {
      if (e.message == 'PROFILE_NOT_FOUND') {
        return const Left(ServerFailure('PROFILE_NOT_FOUND'));
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployerProfile>> updateProfile(Map<String, dynamic> data) async {
    try {
      final profile = await remoteDataSource.updateProfile(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployerProfile>> getEmployerProfile(String employerId) async {
    try {
      final profile = await remoteDataSource.getEmployerProfile(employerId);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
