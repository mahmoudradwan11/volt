import 'package:flutter/material.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/profile/data/support_alert.dart';
import 'package:volt/features/profile/screens/support_chat_screen.dart';

/// In-app notifications list (the home bell opens this). The backend has
/// no notification center, so the only live entry today is a new support
/// message, driven by SupportAlert's poll of the user's chat thread.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: SupportAlert.instance.unread,
        builder: (context, count, _) {
          if (count <= 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(IconBroken.Notification,
                      color: AppColors.subTextColor, size: 42),
                  const SizedBox(height: 10),
                  Text(
                    'No new notifications',
                    style:
                        TextStyle(color: AppColors.subTextColor, fontSize: 14),
                  ),
                ],
              ),
            );
          }
          final preview = SupportAlert.instance.preview.value;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.p2Color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: ListTile(
                  onTap: () {
                    SupportAlert.instance.markRead();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SupportChatScreen(),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.p2Color,
                    backgroundImage: const AssetImage(AppImages.splash),
                  ),
                  title: Text(
                    'Support',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    preview == null || preview.isEmpty
                        ? 'New message from Support'
                        : preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.subTextColor,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Icon(Icons.chat_bubble_outline_rounded,
                      color: AppColors.p3Color, size: 18),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
