import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:volt/features/home/controllers/user_home_cubit.dart';
import 'package:volt/features/home/controllers/user_home_states.dart';
import 'package:volt/features/home/data/home_list.dart';
import 'package:volt/core/themes/app_colors.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserHomeCubit, UserHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = UserHomeCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackColor,
            body: screens[cubit.currentScreenIndex],
            bottomNavigationBar:Padding(
              padding: const EdgeInsets.only(left:10,right: 10,bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF151721),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:5,right: 5,bottom: 5,top:5),
                  child: GNav(
                    tabBorderRadius:20,
                    gap:5,
                    backgroundColor: Color(0xFF151721),
                    color: Color(0xFF8B8D9C),
                    activeColor:  Color(0xFF3F79EB),
                    tabBackgroundColor: AppColors.whiteColor,
                    onTabChange:(index)
                    {
                      cubit.changeScreenIndex(index);
                    },
                    padding:const EdgeInsets.all(10),
                    tabs:tabs
                  ),
                ),
              ),
            ),
          );
        });
          }
  }


