import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

abstract class EmployerHomeRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats();
  Future<Either<Failure, List<ApplicationShortEntity>>> getRecentApplications();
}
