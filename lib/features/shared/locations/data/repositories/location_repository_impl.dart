import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/datasources/location_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';
import 'package:speed_staff_mobile/features/shared/locations/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RegionModel>>> getRegions() async {
    try {
      final result = await remoteDataSource.getRegions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
