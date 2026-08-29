import 'package:flutter/material.dart';
import 'package:volt/core/mangers/colors.dart';
import 'package:volt/core/mangers/icon_broken.dart';
import 'package:volt/core/mangers/images.dart';
import 'package:volt/core/mangers/strings.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(AppImages.splash),
            backgroundColor: Colors.transparent,
          ),
        ),
        title: Text(AppStrings.appTitle.toUpperCase()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.circleAvatarBackHomeColor,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border, color: AppColors.whiteColor),
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: AppColors.circleAvatarBackHomeColor,
            child: IconButton(
              onPressed: () {},
              icon: Icon(IconBroken.Buy, color: AppColors.whiteColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(AppImages.splash),
              backgroundColor: AppColors.circleAvatarBackHomeColor,
            ),
          ),
        ],
      ),
    );
  }
}
