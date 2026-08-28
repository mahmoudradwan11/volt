import 'package:volt/core/barrel_core.dart';
import 'package:volt/users/models/onBoarding_model.dart';

final List<List<String>> onBoardingImages = [
  [
    AppImages.laptopOnBoarding,
    AppImages.phoneOnBoarding,
    AppImages.smartWatchOnBoarding,
  ],
  [
    AppImages.laptopOnBoarding,
    AppImages.phoneOnBoarding,
    AppImages.smartWatchOnBoarding,
  ],
  [
    AppImages.laptopOnBoarding,
    AppImages.phoneOnBoarding,
    AppImages.smartWatchOnBoarding,
  ],
];
final List<OnBoardingModel> onBoardingModel = [
  OnBoardingModel(
    title: AppStrings.onBoardingTitle,
    body: 'We Have all you need Choose Your product from our Volt shop.',
  ),
  OnBoardingModel(
    title: AppStrings.onBoardingTitle,
    body:
        'You ll find the perfect laptop that meets your needs without any hassle',
  ),
  OnBoardingModel(
    title: AppStrings.onBoardingTitle,
    body:
        'Transform your entertainment experience with a smart TV that offers endless options for streaming, gaming, and more',
  ),
];
