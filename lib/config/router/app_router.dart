part of 'route_part.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: RouteNames.onboardingScreen, builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: RouteNames.roleSelectionScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return RoleSelectionScreen(phone: args['phone'] ?? '', code: args['code'] ?? '');
        },
      ),
      GoRoute(
        path: RouteNames.phoneInputScreen,
        builder: (context, state) {
          return const PhoneInputScreen();
        },
      ),
      GoRoute(
        path: RouteNames.otpVerificationScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return OtpVerificationScreen(phoneNumber: args['phone'] ?? '');
        },
      ),
      GoRoute(path: RouteNames.signInScreen, builder: (context, state) => const SignInScreen()),
      GoRoute(
        path: RouteNames.registerWorkerScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return RegisterWorkerScreen(phone: args['phone'] ?? '', code: args['code'] ?? '');
        },
      ),
      GoRoute(
        path: RouteNames.registerRestaurantScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return RegisterRestaurantScreen(phone: args['phone'] ?? '', code: args['code'] ?? '');
        },
      ),
      GoRoute(path: RouteNames.forgotPasswordScreen, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: RouteNames.successScreen, builder: (context, state) => const SuccessScreen()),

      GoRoute(path: RouteNames.main, builder: (context, state) => const TabBox()),
      GoRoute(
        path: '${RouteNames.restaurantDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RestaurantDetailScreen(restaurantId: id);
        },
      ),
      GoRoute(path: RouteNames.notifications, builder: (context, state) => const NotificationsScreen()),
      GoRoute(
        path: RouteNames.createVacancy,
        builder: (context, state) => const CreateVacancyScreen(),
      ),
      GoRoute(
        path: RouteNames.phoneInputScreen,
        builder: (context, state) {
          return const PhoneInputScreen();
        },
      ),
      GoRoute(
        path: RouteNames.employerDashboard,
        builder: (context, state) {
          return const EmployerHomeScreen();
        },
      ),
      GoRoute(
        path: RouteNames.myVacancies,
        builder: (context, state) {
          return const MyVacanciesScreen();
        },
      ),
      GoRoute(
        path: RouteNames.applications,
        builder: (context, state) {
          final id = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => sl<ApplicationsBloc>(),
            child: ApplicationsScreen(vacancyId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.applicationDetail,
        builder: (context, state) {
          final id = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => sl<ApplicationsBloc>(),
            child: ApplicationDetailScreen(applicationId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.candidateProfile,
        builder: (context, state) {
          final id = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => sl<ApplicationsBloc>(),
            child: CandidateProfileScreen(candidateId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.restaurantProfile,
        builder: (context, state) {
          return const EmployerProfileScreen();
        },
      ),
      GoRoute(
        path: RouteNames.editRestaurantProfile,
        builder: (context, state) {
          return const EditEmployerProfileScreen(); 
        },
      ),
      GoRoute(
        path: RouteNames.seekerSearch,
        builder: (context, state) => const SeekerSearchScreen(),
      ),
      GoRoute(
        path: RouteNames.vacancyDetail,
        builder: (context, state) {
          final vacancy = state.extra as Vacancy;
          return VacancyDetailScreen(vacancy: vacancy);
        },
      ),
      GoRoute(
        path: RouteNames.applyVacancy,
        builder: (context, state) {
          final vacancy = state.extra as Vacancy;
          return ApplyVacancyScreen(vacancy: vacancy);
        },
      ),
      GoRoute(
        path: RouteNames.savedVacancies,
        builder: (context, state) => const SavedVacanciesScreen(),
      ),
      GoRoute(
        path: RouteNames.seekerProfile,
        builder: (context, state) => const SeekerProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editSeekerProfile,
        builder: (context, state) => const EditSeekerProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.seekerDocuments,
        builder: (context, state) => const SeekerDocumentsScreen(),
      ),
      GoRoute(
        path: RouteNames.editSeekerExperience,
        builder: (context, state) {
          final experience = state.extra as SeekerExperience?;
          return AddExperienceScreen(experience: experience);
        },
      ),
      GoRoute(
        path: RouteNames.addExperience,
        builder: (context, state) {
          final experience = state.extra as SeekerExperience?;
          return AddExperienceScreen(experience: experience);
        },
      ),
      GoRoute(
        path: RouteNames.seekerSkills,
        builder: (context, state) => const SkillSelectionScreen(),
      ),
    ],
  );
}
