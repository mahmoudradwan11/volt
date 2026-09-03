import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/network/local/cache_helper.dart';
import 'package:volt/features/Splash/controller/splash_states.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkUser() async {
    emit(SplashLoading());

    await Future.delayed(
      const Duration(seconds: AppValuesConstant.timer),
    );

    final bool onboarding =
        CacheHelper.getData(key: 'onBoarding') ?? false;

    final String? token =
    CacheHelper.getData(key: 'token');

    if (!onboarding) {
      emit(SplashNavigateToOnboarding());
    } else if (token != null && token.isNotEmpty) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}