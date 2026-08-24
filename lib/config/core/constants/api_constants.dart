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

  // Employer Profile & Dashboard
  static const String employerProfile = 'api/employer/profile';
  static const String employerDashboard = 'api/employer/dashboard';
  static const String employerReviews = 'api/employer/reviews';

  // Seeker Profile
  static const String seekerProfile = 'api/seeker/profile';
  static const String seekerSkills = 'api/seeker/skills';
  static const String seekerExperiences = 'api/seeker/experiences';
  static const String seekerDocuments = 'api/seeker/documents';
  static const String seekerSavedVacancies = 'api/seeker/saved-vacancies';

  // Vacancies
  static const String vacancies = 'api/vacancies';

  // Search
  static const String searchVacancies = 'api/search/vacancies';

  // Applications
  static const String applications = 'api/applications';

  // Helper & Upload Endpoints
  static const String locationsRegions = 'api/locations/regions';
  static const String searchSkills = 'api/search/skills';
  static const String uploadLogo = 'api/upload/logo';
  static const String uploadAvatar = 'api/upload/avatar';
  static const String uploadResume = 'api/upload/resume';
  static const String uploadDocument = 'api/upload/document';
}
