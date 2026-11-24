import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/core/themes/theme_cubit.dart';
import 'package:volt/features/profile/controllers/profile_cubit.dart';
import 'package:volt/features/profile/controllers/profile_states.dart';
import 'package:volt/features/profile/models/profile_model.dart';
import 'package:volt/features/profile/widgets/notifications_body.dart';
import 'package:volt/features/profile/widgets/payment_body.dart';
import 'package:volt/features/profile/widgets/settings_body.dart';

/// The Profile tab: user header, the Settings / Payment / Notifications
/// segmented tabs and the body for the selected tab.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Merge-safe: use the root ProfileCubit when it is registered,
    // otherwise provide a local one so a partial merge cannot crash.
    ProfileCubit? root;
    try {
      root = context.read<ProfileCubit>();
    } catch (_) {
      root = null;
    }
    if (root != null) {
      return const _SettingsView();
    }
    return BlocProvider(
      create: (_) => ProfileCubit()..getProfile(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    final cubit = ProfileCubit.get(context);
    if (cubit.profile == null) cubit.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ProfileCubit.get(context);
        final profile = cubit.profile;
        // Rebuild this screen on a theme toggle: the MaterialApp rebuild
        // alone does not mark the already-open route dirty, so the visible
        // screen would keep the old palette until the next navigation.
        ThemeCubit? themeCubit;
        try {
          themeCubit = context.read<ThemeCubit>();
        } catch (_) {
          themeCubit = null;
        }
        if (themeCubit != null) {
          return BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) => _buildScaffold(context, profile),
          );
        }
        return _buildScaffold(context, profile);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, ProfileModel? profile) {
    return Builder(
      builder: (context) {
        final cubit = ProfileCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackColor,
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textColor, size: 20),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _UserHeader(profile: profile),
                const SizedBox(height: 16),
                _SegmentedTabs(
                  selected: selectedTab,
                  onSelect: (index) => setState(() => selectedTab = index),
                ),
                const SizedBox(height: 12),
                Expanded(
                  // Not const: identical const widgets would skip rebuilds
                  // when ProfileCubit emits (e.g. a toggle would not flip
                  // until the screen was re-entered).
                  child: selectedTab == 0
                      ? SettingsBody()
                      : selectedTab == 1
                          ? PaymentBody()
                          : NotificationsBody(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UserHeader extends StatelessWidget {
  final ProfileModel? profile;

  const _UserHeader({this.profile});

  @override
  Widget build(BuildContext context) {
    final image = profile?.profileImage;
    final hasImage = image != null && image.toString().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.p2Color,
            backgroundImage: hasImage ? NetworkImage(image.toString()) : null,
            child: hasImage
                ? null
                : Icon(Icons.person, color: AppColors.subTextColor, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? ' ',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile?.email ?? ' ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: AppColors.subTextColor),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;

  const _SegmentedTabs({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.settings_outlined, 'Settings'),
      (Icons.payment_rounded, 'Payment'),
      (Icons.notifications_none_rounded, 'Notifications'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  margin: EdgeInsets.only(right: i < items.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == i
                        ? AppColors.p3Color
                        : AppColors.p2Color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected == i
                          ? AppColors.p3Color
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i].$1,
                          color: selected == i
                              ? Colors.white
                              : AppColors.subTextColor,
                          size: 16),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          items[i].$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected == i
                                ? Colors.white
                                : AppColors.subTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
