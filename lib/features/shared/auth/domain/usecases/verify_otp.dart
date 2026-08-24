import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/entities/user.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/repositories/auth_repository.dart';

class VerifyOtp implements UseCase<User, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(telephoneNumber: params.telephoneNumber, confirmCode: params.confirmCode);
  }
}

class VerifyOtpParams extends Equatable {
  final String telephoneNumber;
  final String confirmCode;

  const VerifyOtpParams({required this.telephoneNumber, required this.confirmCode});

  @override
  List<Object?> get props => [telephoneNumber, confirmCode];
}
