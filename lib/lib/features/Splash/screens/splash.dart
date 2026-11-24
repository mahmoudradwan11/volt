import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/constants/app_images.dart';
import 'package:volt/core/routes/app_routes.dart';
import 'package:volt/features/Splash/controller/splash_cubit.dart';
import 'package:volt/features/Splash/controller/splash_states.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..checkUser(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToHome) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            );
          }

          if (state is SplashNavigateToLogin) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.login,
            );
          }

          if (state is SplashNavigateToOnboarding) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.onBoarding,
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Image.asset(
              AppImages.splash,
            ),
          ),
        ),
      ),
    );
  }
}