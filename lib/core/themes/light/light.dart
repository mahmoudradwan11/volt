import 'package:flutter/material.dart';
import 'package:volt/core/mangers/colors.dart';
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  appBarTheme:  AppBarTheme(
    titleSpacing: 20.0,
    backgroundColor: AppColors.scaffoldBackColor,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: AppColors.whiteColor,
      fontSize: 20.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.defaultColor,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.black,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      color: Colors.black,
      height: 1.3,
    ),
  ),
  scaffoldBackgroundColor: AppColors.scaffoldBackColor,

);
