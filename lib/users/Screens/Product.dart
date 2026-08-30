import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/controllers/ui/home/user_home_cubit/user_home_cubit.dart';
import 'package:volt/core/controllers/ui/home/user_home_cubit/user_home_states.dart';
import 'package:volt/core/lists/home.dart';
import 'package:volt/core/mangers/colors.dart';
import 'package:volt/core/mangers/icon_broken.dart';
import 'package:volt/core/mangers/images.dart';
import 'package:volt/core/mangers/strings.dart';
import 'package:volt/users/custom_widgets/build_user_home_cate_item.dart';

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
      body: SingleChildScrollView(
        child:Column(
          children: [
            BlocConsumer<UserHomeCubit,UserHomeStates>(
              listener: (BuildContext context, UserHomeStates state) {  },
              builder: (BuildContext context, UserHomeStates state) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 90,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCateItem(
                              userHomeCateModel[index], index, context),
                      separatorBuilder: (context, index) =>
                      const SizedBox(
                        width: 1,
                      ),
                      itemCount: userHomeCateModel.length,
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
