import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel_core.dart';
import 'package:volt/core/network/barrel_network.dart';

class OnboardingCubit extends Cubit<OnBoardingStates> {
  OnboardingCubit() : super(OnBoardingInitState());
  static OnboardingCubit get(context) => BlocProvider.of(context);
  bool isPageLast = false;
  int screenIndex = 0;
  void pageChangeLast(index) {
    isPageLast = true;
    screenIndex = index;
    emit(PageLast());
  }

  void pageNotLast(index) {
    isPageLast = false;
    screenIndex = index;
    emit(NotPageLast());
  }

  void printLast() {
    print(isPageLast);
  }

  void submit(context) {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    });
  }
}
