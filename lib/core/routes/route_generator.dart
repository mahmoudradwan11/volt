import 'package:flutter/material.dart';
import 'package:volt/core/routes/app_routes.dart' show AppRoutes;
import 'package:volt/core/screens/splash.dart';
import 'package:volt/main.dart';
import 'package:volt/users/Screens/onBoarding.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MyHomePage(title: 'Go With Flow'),
        );
      case AppRoutes.onBoarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('NotFound')),
        body: const Center(child: Text('No Page')),
      ),
    );
  }
}
