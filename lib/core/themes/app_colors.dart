import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

/// App palette, dark/light mode aware. Screens read these getters at build
/// time; ThemeCubit flips [isDark] and rebuilds the app, so the switch is
/// immediate and app-wide. Accent colors are identical in both modes.
class AppColors {
  /// Current mode. Set from CacheHelper in main() and by ThemeCubit.
  static bool isDark = true;

  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color primaryColor = Colors.indigo;
  static const Color greyColor = Colors.grey;

  /// Accent purple - same in both modes.
  static Color get p3Color => HexColor('#603FF8');

  /// Secondary accent purple used on buttons/gradients - same in both modes.
  static Color get accentColor => HexColor('#7040FF');

  /// Lime accent - same in both modes.
  static Color get limeColor => HexColor('#C8DE22');

  /// Scaffold background.
  static Color get scaffoldBackColor =>
      isDark ? HexColor('#010610') : HexColor('#F4F6FB');

  /// Card / raised surface.
  static Color get p2Color =>
      isDark ? HexColor('#0E172E') : HexColor('#FFFFFF');

  /// Deep surface (filled inputs, selected rows).
  static Color get defaultColor =>
      isDark ? HexColor('#090C36') : HexColor('#E9ECF6');

  static Color get circleAvatarBackHomeColor =>
      isDark ? HexColor('#151721') : HexColor('#E2E5F0');

  /// Primary text on scaffold/card surfaces.
  static Color get textColor =>
      isDark ? HexColor('#FFFFFF') : HexColor('#0B1030');

  /// Secondary text / icons on scaffold/card surfaces.
  static Color get subTextColor => isDark
      ? HexColor('#FFFFFF').withOpacity(0.55)
      : HexColor('#0B1030').withOpacity(0.6);

  /// Card borders and dividers.
  static Color get borderColor =>
      isDark ? HexColor('#172541') : HexColor('#E3E6F0');
}
