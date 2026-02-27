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
    ],
  );
}
