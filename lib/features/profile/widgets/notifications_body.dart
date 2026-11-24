import 'package:flutter/material.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/profile/controllers/profile_cubit.dart';

/// The "Notifications" tab body. There is no notification-preference API
/// on the backend, so toggles are persisted locally via CacheHelper
/// (ProfileCubit.notificationPrefs).
class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  static const _rows = [
    ('account', 'Your Account', 'Important Messages Alerts'),
    ('shipments', 'Your Shipments', 'Shipment Notifications'),
    ('recommendations', 'Your Recommendations', 'Personalized Notifications'),
    ('deals', 'Your Watched & Watchlisted Deals', 'Deal Notifications'),
    ('community', 'Your Wekala Community', 'Community Notifications'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = ProfileCubit.get(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'Notifications settings',
          style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
        ),
        const SizedBox(height: 8),
        for (final row in _rows)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.p2Color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.$2,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        row.$3,
                        style: TextStyle(
                          color: AppColors.subTextColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: cubit.notificationPrefs[row.$1] ?? false,
                  activeColor: AppColors.p3Color,
                  onChanged: (value) =>
                      cubit.toggleNotification(row.$1, value),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
