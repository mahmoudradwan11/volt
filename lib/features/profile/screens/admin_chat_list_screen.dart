import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/profile/controllers/admin_chat_cubit.dart';
import 'package:volt/features/profile/controllers/admin_chat_states.dart';
import 'package:volt/features/profile/models/admin_chat_thread.dart';
import 'package:volt/features/profile/screens/support_chat_screen.dart';

/// The admin's support inbox: users who have exchanged at least one
/// message with the support account. Only reachable when the logged-in
/// nationalId is the support id (Settings shows "Support Inbox" instead
/// of "Contact Us" for that account).
class AdminChatListScreen extends StatelessWidget {
  /// False when embedded as a tab of the admin home (no back arrow).
  final bool showBack;
  const AdminChatListScreen({super.key, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminChatCubit()..loadThreads(),
      child: _AdminChatListView(showBack: showBack),
    );
  }
}

class _AdminChatListView extends StatelessWidget {
  final bool showBack;
  const _AdminChatListView({required this.showBack});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminChatCubit, AdminChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AdminChatCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackColor,
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: showBack
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textColor, size: 20),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: Text(
              'Support Inbox',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh_rounded,
                    color: AppColors.subTextColor),
                onPressed: () => cubit.loadThreads(),
              ),
            ],
          ),
          body: state is AdminChatLoadingState
              ? const Center(child: CircularProgressIndicator())
              : state is AdminChatErrorState && cubit.threads.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: AppColors.subTextColor, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Something went wrong loading chats',
                            style: TextStyle(
                                color: AppColors.subTextColor, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          MaterialButton(
                            color: AppColors.defaultColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () => cubit.loadThreads(),
                            child: Text(
                              'Retry',
                              style: TextStyle(color: AppColors.textColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                          onRefresh: () => cubit.loadThreads(),
                          child: Column(
                            children: [
                              if (cubit.scanning)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 8, 16, 0),
                                  child: Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: cubit.totalUsers == 0
                                            ? null
                                            : cubit.scanned /
                                                cubit.totalUsers,
                                        backgroundColor:
                                            AppColors.p2Color,
                                        color: AppColors.p3Color,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Scanning users ${cubit.scanned}/${cubit.totalUsers}',
                                        style: TextStyle(
                                          color: AppColors.subTextColor,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Expanded(
                                child: cubit.threads.isEmpty
                                    ? ListView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          const SizedBox(height: 120),
                                          Center(
                                            child: Text(
                                              cubit.scanning
                                                  ? 'Looking for customer chats...'
                                                  : 'No customer messages yet',
                                              style: TextStyle(
                                                color:
                                                    AppColors.subTextColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding:
                                            const EdgeInsets.fromLTRB(
                                                16, 8, 16, 24),
                                        itemCount: cubit.threads.length,
                                        itemBuilder: (context, index) =>
                                            _ThreadRow(
                                                thread: cubit
                                                    .threads[index]),
                                      ),
                              ),
                              if (!cubit.scanning && cubit.canScanMore)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 4, 16, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Scanned the newest ${cubit.scanned} of ${cubit.totalUsers} users',
                                          style: TextStyle(
                                            color: AppColors.subTextColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => cubit.scanMore(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                            'Scan more',
                                            style: TextStyle(
                                              color: AppColors.p3Color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
        );
      },
    );
  }
}

class _ThreadRow extends StatelessWidget {
  final AdminChatThread thread;

  const _ThreadRow({required this.thread});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        thread.profileImage != null && thread.profileImage!.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SupportChatScreen(
              peerNationalId: thread.nationalId,
              peerName: thread.name ?? thread.nationalId,
              peerImageUrl: thread.profileImage,
            ),
          ),
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.defaultColor,
          backgroundImage:
              hasImage ? NetworkImage(thread.profileImage!) : null,
          child: hasImage
              ? null
              : Icon(Icons.person_outline_rounded,
                  color: AppColors.subTextColor, size: 20),
        ),
        title: Text(
          thread.name ?? 'Customer',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          thread.lastMessage ?? thread.nationalId,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.subTextColor, fontSize: 11),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.p3Color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${thread.messageCount}',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ),
    );
  }
}
