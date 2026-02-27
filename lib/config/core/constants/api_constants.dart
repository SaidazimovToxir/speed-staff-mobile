class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://api.speed-staff.uz/';

  // Auth Endpoints
  static const String sendOtp = 'api/auth/send-otp';
  static const String verifyOtp = 'api/auth/verify-otp';
  static const String refreshToken = 'api/auth/refresh';
  static const String registerFinalize = 'api/auth/register/finalize';
  static const String getMe = 'api/auth/me';
  static const String logout = 'api/auth/logout';
  static const String deleteAccount = 'api/auth/delete';
  static const String googleAuthMobile = 'api/auth/google';
  static const String appleAuthMobile = 'api/auth/apple';

  // Profile
  static const String profileUpdate = 'api/profile/update';
  static const String seekerAvatar = 'api/seeker/profile/avatar';
  static const String employerAvatar = 'api/employer/profile/avatar';
}
