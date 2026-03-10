import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';

abstract class EmployerProfileRepository {
  Future<Either<Failure, Map<String, dynamic>>> getEmployerProfile();
  Future<Either<Failure, void>> updateEmployerProfile(Map<String, dynamic> data);
}
