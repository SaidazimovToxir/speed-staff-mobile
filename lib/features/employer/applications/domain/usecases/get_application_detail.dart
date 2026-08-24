import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class GetApplicationDetail implements UseCase<ApplicationDetailEntity, String> {
  final ApplicationsRepository repository;
  GetApplicationDetail(this.repository);

  @override
  Future<Either<Failure, ApplicationDetailEntity>> call(String applicationId) {
    return repository.getApplicationDetail(applicationId);
  }
}
