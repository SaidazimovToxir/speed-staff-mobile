import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  Future<Either<Failure, User?>> checkInitialStatus();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, String>> sendOtp(String telephoneNumber);
  Future<Either<Failure, User>> verifyOtp({required String telephoneNumber, required String confirmCode});
  Future<Either<Failure, User>> finalizeRegistration({
    required String phone,
    required String code,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? restaurantName,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> autoLogout();
  Future<Either<Failure, User>> updateUserDetails({
    required String email,
    required String telephoneNumber,
    required String fullName,
    // required DateTime birthDate,
    // required String gender,
    required String avatar,
  });

  /// Sign in with Google account
  // Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with Apple account
  // Future<Either<Failure, User>> signInWithApple();

  /// Deletes user account and clears local data
  /// Returns [AuthenticationFailure] if delete fails
  Future<Either<Failure, void>> deleteAccount();
}
