import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/datasources/employer_profile_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_profile_repository.dart';

class EmployerProfileRepositoryImpl implements EmployerProfileRepository {
  final EmployerProfileRemoteDataSource remoteDataSource;

  EmployerProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEmployerProfile() async {
    try {
      final profile = await remoteDataSource.getEmployerProfile();
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployerProfile(Map<String, dynamic> data) async {
    try {
      await remoteDataSource.updateEmployerProfile(data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
