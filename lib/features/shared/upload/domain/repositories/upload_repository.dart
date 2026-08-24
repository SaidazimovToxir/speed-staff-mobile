import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';

abstract class UploadRepository {
  Future<Either<Failure, String>> uploadLogo(String filePath);
}
