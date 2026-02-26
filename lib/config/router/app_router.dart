part of 'route_part.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.main,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelectionScreen,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.phoneInputScreen,
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: RouteNames.otpVerificationScreen,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.signInScreen,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouteNames.registerWorkerScreen,
        builder: (context, state) => const RegisterWorkerScreen(),
      ),
      GoRoute(
        path: RouteNames.registerRestaurantScreen,
        builder: (context, state) => const RegisterRestaurantScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordScreen,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.successScreen,
        builder: (context, state) => const SuccessScreen(),
      ),
      
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RestaurantDetailScreen(restaurantId: id);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
