import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/core/themes/theme_cubit.dart';
import 'package:volt/features/admin/controllers/admin_analytics_cubit.dart';
import 'package:volt/features/admin/controllers/admin_products_cubit.dart';
import 'package:volt/features/admin/screens/admin_analytics_screen.dart';
import 'package:volt/features/admin/screens/admin_companies_screen.dart';
import 'package:volt/features/admin/screens/admin_products_screen.dart';
import 'package:volt/features/profile/screens/admin_chat_list_screen.dart';
import 'package:volt/features/profile/screens/settings_screen.dart';

/// Home of the admin version: Products, Companies, Chat, Analytics and
/// Settings. There are deliberately no orders, cart or favorites here.
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AdminProductsCubit()..loadProducts()),
        BlocProvider(create: (_) => AdminAnalyticsCubit()),
      ],
      // Rebuild on a theme toggle so the open tab picks up the new palette.
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) => Scaffold(
          backgroundColor: AppColors.scaffoldBackColor,
          body: IndexedStack(
            index: index,
            children: [
              const AdminProductsScreen(),
              const AdminCompaniesScreen(),
              const AdminChatListScreen(showBack: false),
              // Analytics reloads every time its tab opens.
              index == 3 ? const AdminAnalyticsScreen() : const SizedBox(),
              const SettingsScreen(),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.circleAvatarBackHomeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: GNav(
                  tabBorderRadius: 20,
                  gap: 5,
                  backgroundColor: AppColors.circleAvatarBackHomeColor,
                  color: const Color(0xFF8B8D9C),
                  activeColor: const Color(0xFF3F79EB),
                  tabBackgroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.all(10),
                  selectedIndex: index,
                  onTabChange: (i) => setState(() => index = i),
                  tabs: const [
                    GButton(icon: Icons.inventory_2_outlined, text: 'Products'),
                    GButton(icon: Icons.business_outlined, text: 'Companies'),
                    GButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      text: 'Chat',
                    ),
                    GButton(icon: Icons.bar_chart_rounded, text: 'Analytics'),
                    GButton(
                      icon: Icons.person_outline_rounded,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
