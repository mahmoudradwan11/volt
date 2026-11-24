import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/profile/controllers/chat_cubit.dart';
import 'package:volt/features/profile/controllers/chat_states.dart';
import 'package:volt/features/profile/data/chat_peers_store.dart';
import 'package:volt/features/profile/models/chat_message_model.dart';

/// Contact Us: the customer's support chat with the app. One thread per
/// user (customer nationalId <-> support nationalId), backed by the
/// backend chat API (GET/POST /chat).
class SupportChatScreen extends StatelessWidget {
  /// Admin reuse: passing [peerNationalId]/[peerName] turns this into the
  /// admin's view of one customer's thread - the admin is logged in with
  /// the support id, so sends go from the support id to that customer.
  final String? peerNationalId;
  final String? peerName;

  const SupportChatScreen({super.key, this.peerNationalId, this.peerName});

  @override
  Widget build(BuildContext context) {
    // Admin thread view: remember this customer so the Support Inbox can
    // list the admin's own conversations without scanning all users.
    if (peerNationalId != null) {
      ChatPeersStore.addPeer(peerNationalId!, peerName);
    }
    return BlocProvider(
      create: (_) =>
          ChatCubit(peerNationalId: peerNationalId)..getMessages(),
      child: _ChatView(peerName: peerName),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String? peerName;

  const _ChatView({this.peerName});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {
        if (state is ChatSuccessState) _scrollToBottom();
      },
      builder: (context, state) {
        final cubit = ChatCubit.get(context);
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
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.p2Color,
                  child: Icon(
                    widget.peerName == null
                        ? Icons.support_agent_rounded
                        : Icons.person_outline_rounded,
                    color: AppColors.subTextColor,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.peerName ?? 'Support',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh_rounded, color: AppColors.subTextColor),
                onPressed: () => cubit.getMessages(),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: state is ChatLoadingState && cubit.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : cubit.messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet.\nSend us a message and we will reply here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.subTextColor, fontSize: 13),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => cubit.getMessages(),
                            child: ListView.builder(
                              controller: _scrollController,
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                  16, 8, 16, 12),
                              itemCount: cubit.messages.length,
                              itemBuilder: (context, index) {
                                final message = cubit.messages[index];
                                return _MessageBubble(
                                  message: message,
                                  isMine: message.senderNationalId ==
                                      cubit.myNationalId,
                                );
                              },
                            ),
                          ),
              ),
              _Composer(
                controller: _controller,
                sending: cubit.sending,
                onSend: () {
                  cubit.sendMessage(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMine;

  const _MessageBubble({required this.message, required this.isMine});

  String _timeLabel() {
    final t = message.timestamp;
    if (t == null) return '';
    final local = t.toLocal();
    final h = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final m = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.p3Color : AppColors.p2Color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMine ? 14 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 14),
          ),
          border: isMine ? null : Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content ?? '',
              style: TextStyle(
                color: isMine ? Colors.white : AppColors.textColor,
                fontSize: 13,
              ),
            ),
            if (message.timestamp != null) ...[
              const SizedBox(height: 3),
              Text(
                _timeLabel(),
                style: TextStyle(
                  color: isMine ? Colors.white60 : AppColors.subTextColor,
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(color: AppColors.textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle:
                      TextStyle(color: AppColors.subTextColor, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.p2Color,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.p3Color),
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: sending ? null : onSend,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.p3Color,
                child: sending
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
