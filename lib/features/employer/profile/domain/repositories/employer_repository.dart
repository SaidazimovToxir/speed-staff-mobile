import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile.dart';

abstract class EmployerRepository {
  Future<Either<Failure, EmployerProfile>> createProfile(Map<String, dynamic> data);
  Future<Either<Failure, EmployerProfile>> getOwnProfile();
  Future<Either<Failure, EmployerProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, EmployerProfile>> getEmployerProfile(String employerId);
  Future<Either<Failure, DashboardStats>> getDashboardStats();
}
