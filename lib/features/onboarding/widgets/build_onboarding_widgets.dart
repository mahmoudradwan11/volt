import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/features/onboarding/data/onBoarding_list.dart';
import 'package:volt/core/mangers/colors.dart';
import 'package:volt/core/themes/Widgets/button.dart';
import 'package:volt/features/onboarding/controllers/onboarding_cubit/onboarding_cubit.dart';
import 'package:volt/features/onboarding/controllers/onboarding_cubit/onboarding_states.dart';
import 'package:volt/features/onboarding/models/onBoarding_model.dart';

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
                        color: AppColors.whiteColor,
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
                        color: AppColors.whiteColor,
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
