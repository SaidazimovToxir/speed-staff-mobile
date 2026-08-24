import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/upload/data/datasources/upload_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/upload/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;

  UploadRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadLogo(String filePath) async {
    try {
      final result = await remoteDataSource.uploadLogo(filePath);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
