import 'package:flutter/material.dart';
import 'package:volt/core/themes/app_colors.dart';

/// Mode-aware app theme: built from AppColors getters, so a MaterialApp
/// rebuild after a theme toggle picks up the new palette.
ThemeData get appTheme => ThemeData(
      primarySwatch: Colors.indigo,
      brightness: AppColors.isDark ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        titleSpacing: 20.0,
        backgroundColor: AppColors.scaffoldBackColor,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 20.0,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.defaultColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.p3Color,
        elevation: 20.0,
        backgroundColor: AppColors.p2Color,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
          color: AppColors.textColor,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
          color: AppColors.textColor,
          height: 1.3,
        ),
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackColor,
    );
