import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel_core.dart';
import 'package:volt/users/models/onBoarding_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnBoardingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var pageController = PageController();
        var cubit = OnboardingCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackGroundColor,
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
                              ? AppColors.scaffoldBackGroundColor
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
    );
  }
}

class TriangleImages extends StatelessWidget {
  final List<String> images;
  final OnBoardingModel models;
  final PageController pageController;
  final int pageIndex;

  const TriangleImages({
    super.key,
    required this.images,
    required this.pageController,
    required this.models,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnBoardingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = OnboardingCubit.get(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight / 1.25;

            const imageSize = 120.0;

            final positions = [
              // Screen 1
              [
                Offset(width / 2 - imageSize / 2, 60),
                Offset(40, height - 220),
                Offset(width - imageSize - 40, height - 220),
              ],

              // Screen 2
              [
                Offset(width - imageSize - 40, height - 220),
                Offset(width / 2 - imageSize / 2, 60),
                Offset(40, height - 220),
              ],

              // Screen 3
              [
                Offset(40, height - 220),
                Offset(width - imageSize - 40, height - 220),
                Offset(width / 2 - imageSize / 2, 60),
              ],
            ];

            final currentPositions = positions[pageIndex];

            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: List.generate(onBoardingImages.length, (index) {
                      final position = currentPositions[index];

                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOutCubic,
                        left: position.dx,
                        top: position.dy,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 700),
                          scale: 1,
                          curve: Curves.easeInOutCubic,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              images[index],
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Text(
                  models.title!,
                  style: TextStyle(color: AppColors.defaultColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(models.body!, textAlign: TextAlign.center),
                ),
                cubit.isPageLast
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: DefaultButton(
                          buttonWidget: Text(
                            'GetStarted',
                            style: TextStyle(
                              color: AppColors.scaffoldBackGroundColor,
                            ),
                          ),
                          function: () {
                            cubit.submit(context);
                          },
                          backgroundColor: AppColors.defaultColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: DefaultButton(
                          buttonWidget: Text(
                            'Next',
                            style: TextStyle(
                              color: AppColors.scaffoldBackGroundColor,
                            ),
                          ),
                          function: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                          backgroundColor: AppColors.defaultColor,
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
