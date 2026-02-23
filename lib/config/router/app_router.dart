part of 'route_part.dart';

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return CupertinoPageRoute(builder: (context) => const HomeScreen());
      case RouteNames.searchScreen:
        return CupertinoPageRoute(builder: (context) => const SearchScreen());
      // case RouteNames.myListScreen:
      //   return CupertinoPageRoute(builder: (context) => const MyListScreen());
      // case RouteNames.profile:
      //   return CupertinoPageRoute(builder: (context) => const ProfileScreen());
      case RouteNames.tabBox:
        return CupertinoPageRoute(builder: (context) => const TabBox());

      // case RouteNames.login:
      //   return CupertinoPageRoute(
      //     builder: (context) => const LoginPage(),
      //   );
      // case RouteNames.otp:
      //   return CupertinoPageRoute(
      //     builder: (context) => const OtpPage(),
      //   );
      // case RouteNames.splash:
      //   return CupertinoPageRoute(
      //     builder: (context) => const SplashPage(),
      //   );
      default:
        return CupertinoPageRoute(builder: (context) => _buildUnknownRoutePage());
    }
  }

  static Widget _buildUnknownRoutePage() {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.white, statusBarIconBrightness: Brightness.dark),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "Route not available!",
              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
