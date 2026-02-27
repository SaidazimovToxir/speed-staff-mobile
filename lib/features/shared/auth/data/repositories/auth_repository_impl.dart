import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/entities/user.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/datasources/auth_local_datasource.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/datasources/auth_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/models/user_model.dart';

/// Implementation of [AuthRepository] that coordinates data from local and remote sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final _authController = StreamController<User?>.broadcast();

  AuthRepositoryImpl({required this.localDataSource, required this.remoteDataSource}) {
    _initAuth();
  }

  Future<void> _initAuth() async {
    final status = await checkInitialStatus();
    status.fold((failure) => _authController.add(null), (user) => _authController.add(user));
  }

  @override
  Future<Either<Failure, User?>> checkInitialStatus() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Right(null);
      }

      final user = await localDataSource.getLastUser();
      if (user != null) {
        return Right(user);
      }

      return const Right(UserModel(isAuthenticated: true));
    } on CacheException {
      return const Right(null);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Stream<User?> authStateChanges() => _authController.stream;

  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    try {
      final requestId = await remoteDataSource.sendOtp(phoneNumber);
      return Right(requestId);
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(user);
      _authController.add(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({required String telephoneNumber, required String confirmCode}) async {
    try {
      final responseData = await remoteDataSource.verifyOtp(telephoneNumber: telephoneNumber, confirmCode: confirmCode);

      // Check if action_required == 'finalize_registration'
      if (responseData['action_required'] == 'finalize_registration') {
        final profileNeedsUpdateUser = const UserModel(isAuthenticated: false, needsProfileUpdate: true);
        return Right(profileNeedsUpdateUser);
      }

      final tokens = responseData['tokens'];
      if (tokens?['access_token'] != null) {
        await localDataSource.cacheToken(tokens['access_token']);
      }
      if (tokens?['refresh_token'] != null) {
        await localDataSource.cacheRefreshToken(tokens['refresh_token']);
      }

      // Try parsing user right away
      if (responseData['user'] != null) {
        final userModel = UserModel.fromJson(responseData['user']);
        await localDataSource.cacheUser(userModel);
        _authController.add(userModel);
        return Right(userModel);
      }

      return const Right(UserModel(isAuthenticated: true));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> finalizeRegistration({
    required String phone,
    required String code,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? restaurantName,
  }) async {
    try {
      final responseData = await remoteDataSource.finalizeRegistration(
        phone: phone,
        code: code,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
        restaurantName: restaurantName,
      );

      final tokens = responseData['tokens'];
      if (tokens?['access_token'] != null) {
        await localDataSource.cacheToken(tokens['access_token']);
      }
      if (tokens?['refresh_token'] != null) {
        await localDataSource.cacheRefreshToken(tokens['refresh_token']);
      }

      if (responseData['user'] != null) {
        final userModel = UserModel.fromJson(responseData['user']);
        await localDataSource.cacheUser(userModel);
        _authController.add(userModel);
        return Right(userModel);
      }
      return const Right(UserModel(isAuthenticated: true));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, User>> signInWithGoogle() async {
  //   try {
  //     final token = await remoteDataSource.signInWithGoogle();
  //     await localDataSource.cacheToken(token);

  //     final minimalUser = const UserModel(isAuthenticated: true);
  //     _authController.add(minimalUser);

  //     try {
  //       final userModel = await remoteDataSource.getCurrentUser();
  //       await localDataSource.cacheUser(userModel);
  //       _authController.add(userModel);
  //       return Right(userModel);
  //     } catch (e) {
  //       return Right(minimalUser);
  //     }
  //   } on AuthException catch (e) {
  //     return Left(AuthenticationFailure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      try {
        await remoteDataSource.logout();
      } catch (e) {
        // Continue with local logout
      }
      await localDataSource.clearAuthData();
      _authController.add(null);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> autoLogout() async {
    try {
      await localDataSource.clearAuthData();
      _authController.add(null);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserDetails({
    required String email,
    required String telephoneNumber,
    required String fullName,
    required String avatar,
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateUserDetails(email: email, telephoneNumber: telephoneNumber, fullName: fullName, avatar: avatar);

      await localDataSource.cacheUser(updatedUser);
      _authController.add(updatedUser);
      return Right(updatedUser);
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  void dispose() {
    _authController.close();
  }

  // @override
  // Future<Either<Failure, User>> signInWithApple() async {
  //   try {
  //     final response = await remoteDataSource.signInWithApple();
  //     final token = response['token'];

  //     await localDataSource.cacheToken(token);
  //     final minimalUser = const UserModel(isAuthenticated: true);
  //     _authController.add(minimalUser);

  //     try {
  //       final userModel = await remoteDataSource.getCurrentUser();
  //       await localDataSource.cacheUser(userModel);
  //       _authController.add(userModel);
  //       return Right(userModel);
  //     } catch (e) {
  //       return Right(minimalUser);
  //     }
  //   } on AuthException catch (e) {
  //     return Left(AuthenticationFailure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      try {
        await remoteDataSource.deleteAccount();
      } catch (e) {
        return Left(AuthenticationFailure(e.toString()));
      }
      await localDataSource.clearAuthData();
      _authController.add(null);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
