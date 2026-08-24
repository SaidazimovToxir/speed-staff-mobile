import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/shared/upload/domain/repositories/upload_repository.dart';

class UploadLogo implements UseCase<String, UploadLogoParams> {
  final UploadRepository repository;

  UploadLogo(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadLogoParams params) async {
    return await repository.uploadLogo(params.filePath);
  }
}

class UploadLogoParams {
  final String filePath;

  UploadLogoParams({required this.filePath});
}
