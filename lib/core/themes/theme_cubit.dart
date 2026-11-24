import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/network/local/cache_helper.dart';
import 'package:volt/core/themes/app_colors.dart';

/// Dark/light mode. The choice is persisted in CacheHelper ('isDark'),
/// applied to AppColors, and emitted so the MaterialApp rebuilds and the
/// whole app switches immediately.
class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(AppColors.isDark);

  static ThemeCubit get(context) => BlocProvider.of<ThemeCubit>(context);

  bool get isDark => state;

  void _applySystemBars(bool dark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void loadTheme() {
    final saved = CacheHelper.getData(key: 'isDark');
    final dark = saved is bool ? saved : true;
    AppColors.isDark = dark;
    _applySystemBars(dark);
    emit(dark);
  }

  void toggleTheme(bool dark) {
    AppColors.isDark = dark;
    CacheHelper.saveData(key: 'isDark', value: dark);
    _applySystemBars(dark);
    emit(dark);
  }
}
