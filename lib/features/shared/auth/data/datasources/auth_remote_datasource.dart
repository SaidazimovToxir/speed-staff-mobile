import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/models/user_model.dart';

// Assuming DeviceInfoService exists in your project somewhere. If not, it will need to be provided.
// import '../../../../config/core/services/device_info_service.dart';

/// Interface for remote data operations related to authentication
abstract class AuthRemoteDataSource {
  /// Get current user using token
  /// Throws [AuthException] if get fails
  Future<UserModel> getCurrentUser();

  /// Sends OTP to the provided phone number
  /// Throws [AuthException] if request fails
  Future<String> sendOtp(String telephoneNumber);

  /// Verifies OTP and returns authentication token or finalize registration action
  /// Throws [AuthException] if verification fails
  Future<Map<String, dynamic>> verifyOtp({required String telephoneNumber, required String confirmCode});

  /// Finalize registration for missing profiles
  Future<Map<String, dynamic>> finalizeRegistration({
    required String phone,
    required String code,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? restaurantName,
  });

  /// Sign in with Google and returns authentication token
  /// Throws [AuthException] if sign in fails
  // Future<String> signInWithGoogle();

  /// Logs out the current user
  /// Throws [AuthException] if request fails
  Future<void> logout();

  /// Updates user details
  /// Throws [AuthException] if update fails
  Future<UserModel> updateUserDetails({required String email, required String telephoneNumber, required String fullName, required String avatar});

  /// Sign in with Apple and returns authentication token
  /// Throws [AuthException] if sign in fails
  // Future<Map<String, dynamic>> signInWithApple();

  /// Deletes user account
  /// Throws [AuthException] if delete fails
  Future<void> deleteAccount();
}

/// Implementation of [AuthRemoteDataSource] using DioClient
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  // final DeviceInfoService _deviceInfoService;
  // final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._dioClient);

  String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return e.message ?? e.toString();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.get(ApiConstants.getMe);

      // Check for error response
      if (response.data['status'] == 'error') {
        throw AuthException(response.data['message'] ?? 'unknown_error'.tr());
      }

      return UserModel.fromJson(response.data['data'] ?? response.data['user']);
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $s');
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> sendOtp(String telephoneNumber) async {
    try {
      final response = await _dioClient.post(ApiConstants.sendOtp, data: {'phone': telephoneNumber});

      // Assuming the response contains a request ID or similar
      return response.data['id']?.toString() ?? 'OTP_SENT_SUCCESS';
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e, s) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $s');
      throw AuthException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String telephoneNumber, required String confirmCode}) async {
    try {
      final response = await _dioClient.post(ApiConstants.verifyOtp, data: {'phone': telephoneNumber, 'code': confirmCode});

      if (response.data['status'] == 'error' || response.data['success'] == false) {
        throw AuthException(response.data['message'] ?? 'verification_failed'.tr());
      }

      // Could be final login OR request to finalize registration
      return response.data;
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> finalizeRegistration({
    required String phone,
    required String code,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? restaurantName,
  }) async {
    try {
      final Map<String, dynamic> reqData = {'phone': phone, 'code': code, 'password': password, 'role': role};

      if (role == 'seeker') {
        reqData['first_name'] = firstName;
        reqData['last_name'] = lastName;
      } else if (role == 'employer') {
        reqData['restaurant_name'] = restaurantName;
      }

      final response = await _dioClient.post(ApiConstants.registerFinalize, data: reqData);

      if (response.data['status'] == 'error' || response.data['success'] == false) {
        throw AuthException(response.data['message'] ?? 'registration_failed'.tr());
      }

      return response.data;
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  // @override
  // Future<String> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       throw AuthException("Google bilan ro'yxatdan o'tish qaytarildi yoki muaffaqiyatsiz.");
  //     }

  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final String accessToken = googleAuth.accessToken ?? '';

  //     if (accessToken.isEmpty) {
  //       throw AuthException("Token bilan muammo bo'ldi qayta urinib ko'ring.");
  //     }

  //     final response = await _dioClient.post(
  //       ApiConstants.googleAuthMobile,
  //       data: {'access_token': accessToken},
  //       options: Options(headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}),
  //     );

  //     if (response.data['message'] != null && response.data['message'].toString().contains('xatolik')) {
  //       throw AuthException(response.data['message'] ?? 'unknown_error'.tr());
  //     }

  //     if (response.data['token'] == null) {
  //       throw AuthException("Token bilan muammo bo'ldi qayta urinib ko'ring.");
  //     }

  //     return response.data['token'];
  //   } on DioException catch (e, s) {
  //     debugPrint('DioException: $e');
  //     if (e.response?.data != null && e.response?.data['message'] != null) {
  //       throw AuthException(e.response?.data['message']);
  //     }
  //     throw AuthException(e.toString());
  //   } catch (e) {
  //     throw AuthException(e.toString());
  //   }
  // }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiConstants.logout);
      // await _googleSignIn.signOut();
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserDetails({required String email, required String telephoneNumber, required String fullName, required String avatar}) async {
    try {
      final formData = FormData.fromMap({'email': email, 'telephone_number': telephoneNumber, 'full_name': fullName});

      if (avatar.isNotEmpty) {
        formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar)));
      }

      final response = await _dioClient.post(
        ApiConstants.profileUpdate,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      if (response.data['data'] == null) {
        throw AuthException("User malumotlarini olishda xatolik bo'ldi.");
      }

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  // @override
  // Future<Map<String, dynamic>> signInWithApple() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);

  //     if (credential.identityToken == null) {
  //       throw AuthException('missing_identity_token'.tr());
  //     }

  //     final response = await _dioClient.post(
  //       ApiConstants.appleAuthMobile,
  //       data: {'identity_token': credential.identityToken},
  //       options: Options(headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}),
  //     );

  //     if (response.data['message'] != null && response.data['message'].toString().contains('xatolik')) {
  //       throw AuthException(response.data['message'] ?? 'unknown_error'.tr());
  //     }

  //     if (response.data['token'] == null) {
  //       throw AuthException('missing_token'.tr());
  //     }

  //     return {'token': response.data['token'], 'message': response.data['message'] ?? 'Apple orqali muvaffaqiyatli kirdingiz'};
  //   } on SignInWithAppleException catch (e) {
  //     throw AuthException(e.toString());
  //   } on DioException catch (e, s) {
  //     if (e.response?.data != null && e.response?.data['message'] != null) {
  //       throw AuthException(e.response?.data['message']);
  //     }
  //     throw AuthException(e.toString());
  //   } catch (e) {
  //     throw AuthException(e.toString());
  //   }
  // }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dioClient.delete(ApiConstants.deleteAccount);
    } on DioException catch (e) {
      throw AuthException(_extractErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}
