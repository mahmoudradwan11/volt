import 'package:flutter/material.dart';
import 'package:volt/core/routes/app_routes.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/network/local/cache_helper.dart';
import 'package:volt/features/admin/screens/admin_home_screen.dart';
import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/features/products/screens/product_details.dart';
import 'package:volt/main.dart';
import 'package:volt/core/barrel/barrel_routes.dart';
import 'package:volt/features/home/screens/home.dart';
import 'package:volt/features/cart/screens/cart_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.home:
        // Role split: the admin account lands on the admin UI.
        if (isAdminNationalId(CacheHelper.getData(key: 'userId'))) {
          return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
        }
        return MaterialPageRoute(
          builder: (_) => UserHomeScreen());
      case AppRoutes.adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      case AppRoutes.onBoarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case AppRoutes.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRoutes.productDetails:
        final product = settings.arguments as Product;
        return MaterialPageRoute(builder: (_)=> ProductDetails(product:product,));
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
