import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/features/home/controllers/user_home_cubit.dart';
import 'package:volt/features/orders/controllers/orders_cubit.dart';
import 'package:volt/features/cart/controllers/cart_cubit.dart';
import 'package:volt/features/category/controllers/category_cubit.dart';
import 'package:volt/features/favorites/controllers/favorite_cubit.dart';
import 'package:volt/features/profile/controllers/profile_cubit.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/core/themes/light/light.dart';
import 'package:volt/core/themes/theme_cubit.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'core/barrel/barrel_core.dart';
import 'core/utils/observer.dart';
import 'core/barrel/barrel_network.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await DioHelperStore.init();
  await DioHelperPayment.initDio();
  nationalId = CacheHelper.getData(key: 'userId');
  print(nationalId);
  // Restore the saved dark/light choice before the first frame.
  final savedIsDark = CacheHelper.getData(key: 'isDark');
  AppColors.isDark = savedIsDark is bool ? savedIsDark : true;

  Bloc.observer = MyBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context)=>UserHomeCubit(),
        lazy: true,
        ),
        BlocProvider(create:(context)=>ProductCubit()..getProducts('Laptops'),
          lazy: true,
        ),
        BlocProvider(create:(context)=>OrdersCubit(),
          lazy: true,
        ),
        BlocProvider(create:(context)=>CartCubit(),
          lazy: true,
        ),
        BlocProvider(create:(context)=>CategoryCubit(),
          lazy: true,
        ),
        BlocProvider(create:(context)=>FavoriteCubit()..getFavorites(),
          lazy: true,
        ),
        BlocProvider(create:(context)=>ProfileCubit()..getProfile(),
          lazy: true,
        ),
        BlocProvider(create:(context)=>ThemeCubit()..loadTheme(),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) => MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.generateRoutes,
          title: AppStrings.appTitle,
          theme: appTheme,
        ),
      ),
    );
  }
}
