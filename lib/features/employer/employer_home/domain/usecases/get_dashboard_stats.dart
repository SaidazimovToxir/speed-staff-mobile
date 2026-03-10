import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/repositories/employer_home_repository.dart';

class GetDashboardStats {
  final EmployerHomeRepository repository;

  GetDashboardStats(this.repository);

  Future<Either<Failure, EmployerStatsEntity>> call() {
    return repository.getDashboardStats();
  }
}
