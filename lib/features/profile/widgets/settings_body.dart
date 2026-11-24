import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/routes/app_routes.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/core/themes/theme_cubit.dart';
import 'package:volt/features/profile/controllers/profile_cubit.dart';
import 'package:volt/features/profile/screens/admin_chat_list_screen.dart';
import 'package:volt/features/profile/screens/language_country_screen.dart';
import 'package:volt/features/profile/screens/profile_settings_screen.dart';
import 'package:volt/features/profile/screens/support_chat_screen.dart';

/// The "Settings" tab body: the General rows, Contact Us and Sign out.
class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ProfileCubit.get(context).profile;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const _SectionLabel('General'),
        const SizedBox(height: 8),
        const _DarkModeRow(),
        _SettingsRow(
          icon: Icons.language_rounded,
          title: 'Language & Country',
          subtitle: 'English (United States)',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageCountryScreen()),
          ),
        ),
        _SettingsRow(
          icon: Icons.person_outline_rounded,
          title: 'Profile Settings',
          subtitle: profile?.name ?? 'Your profile',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: ProfileCubit.get(context),
                child: const ProfileSettingsScreen(),
              ),
            ),
          ),
        ),
        _SettingsRow(
          icon: Icons.notifications_none_rounded,
          title: 'Notification',
          subtitle: 'Email, Newsletter etc',
          onTap: () {},
        ),
        _SettingsRow(
          icon: Icons.lock_outline_rounded,
          title: 'Privacy',
          subtitle: 'Terms, Privacy',
          onTap: () {},
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(builder: (context) {
              // The support account gets the admin inbox; everyone else
              // gets their own support chat.
              final myId =
                  (CacheHelper.getData(key: 'userId') ?? nationalId)
                      ?.toString();
              final isSupport = myId == ApiConstants.supportNationalId;
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isSupport
                        ? const AdminChatListScreen()
                        : const SupportChatScreen(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    isSupport ? 'Support Inbox' : 'Contact Us',
                    style: TextStyle(
                      color: AppColors.subTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
            InkWell(
              onTap: () => _showSignOutDialog(context),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.p2Color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          'Are you sure you want to Sign out?',
          style: TextStyle(color: AppColors.textColor, fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.p3Color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(90, 40),
            ),
            onPressed: () async {
              // Best effort: invalidate the token server-side, then clear
              // the saved token locally and return to the sign-in flow.
              final savedToken =
                  CacheHelper.getData(key: 'token') ?? token;
              if (savedToken != null) {
                try {
                  await DioHelperStore.postData(
                    url: ApiConstants.logoutApi,
                    data: {'token': savedToken},
                  );
                } catch (e) {
                  print(e.toString());
                }
              }
              await CacheHelper.removeData(key: 'token');
              await CacheHelper.removeData(key: 'userId');
              token = null;
              nationalId = null;
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            child: Text('Yes', style: TextStyle(color: Colors.white)),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.p3Color),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(90, 40),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('No', style: TextStyle(color: AppColors.p3Color)),
          ),
        ],
      ),
    );
  }
}

/// Dark/light mode switch. ThemeCubit flips AppColors and rebuilds the
/// MaterialApp, so the whole app changes immediately.
class _DarkModeRow extends StatelessWidget {
  const _DarkModeRow();

  @override
  Widget build(BuildContext context) {
    // Merge-safe: hidden if the root ThemeCubit is not registered.
    try {
      context.read<ThemeCubit>();
    } catch (_) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.p2Color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: ListTile(
          leading: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: AppColors.subTextColor,
            size: 20,
          ),
          title: Text(
            'Dark Mode',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            isDark ? 'On' : 'Off',
            style: TextStyle(color: AppColors.subTextColor, fontSize: 11),
          ),
          trailing: Switch(
            value: isDark,
            activeColor: AppColors.p3Color,
            onChanged: (value) =>
                ThemeCubit.get(context).toggleTheme(value),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.subTextColor, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.subTextColor, fontSize: 11),
        ),
        trailing: Icon(Icons.chevron_right_rounded,
            color: AppColors.subTextColor, size: 20),
      ),
    );
  }
}
