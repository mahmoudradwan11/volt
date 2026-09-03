import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/features/onboarding/controllers/onboarding_cubit.dart';
import 'package:volt/features/onboarding/controllers/onboarding_states.dart';
import 'package:volt/features/onboarding/widgets/build_onboarding_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnBoardingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var pageController = PageController();
          var cubit = OnboardingCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: AppValuesForWAndH.width6),
                      Text(
                        AppStrings.appTitle,
                        style: TextStyle(
                          color: AppColors.defaultColor,
                          fontSize: AppFontsSize.fontSize50,
                          fontFamily: 'Bursh',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          cubit.submit(context);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: cubit.isPageLast
                                ? AppColors.whiteColor
                                : AppColors.defaultColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: onBoardingImages.length,
                    onPageChanged: (index) {
                      if (index == onBoardingImages.length - 1) {
                        cubit.pageChangeLast(index);
                        cubit.printLast();
                      } else {
                        cubit.pageNotLast(index);
                        cubit.printLast();
                      }
                    },
                    itemBuilder: (context, index) {
                      return TriangleImages(
                        pageController: pageController,
                        models: onBoardingModel[index],
                        images: onBoardingImages[index],
                        pageIndex: cubit.screenIndex,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoardingImages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: cubit.screenIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: cubit.screenIndex == index
                              ? Colors.black
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
