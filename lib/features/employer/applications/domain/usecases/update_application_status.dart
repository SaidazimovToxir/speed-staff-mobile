import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';

class UpdateApplicationStatusParams {
  final String applicationId;
  final String status;
  final String? employerNote;

  const UpdateApplicationStatusParams({
    required this.applicationId,
    required this.status,
    this.employerNote,
  });
}

class UpdateApplicationStatus implements UseCase<ApplicationDetailEntity, UpdateApplicationStatusParams> {
  final ApplicationsRepository repository;
  UpdateApplicationStatus(this.repository);

  @override
  Future<Either<Failure, ApplicationDetailEntity>> call(UpdateApplicationStatusParams params) {
    return repository.updateApplicationStatus(
      params.applicationId,
      params.status,
      employerNote: params.employerNote,
    );
  }
}
