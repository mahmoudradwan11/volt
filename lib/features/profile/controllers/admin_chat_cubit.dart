import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/features/profile/controllers/admin_chat_states.dart';
import 'package:volt/features/profile/data/chat_peers_store.dart';
import 'package:volt/features/profile/models/admin_chat_thread.dart';

/// The admin's support inbox. The backend has no thread-list endpoint, so
/// this enumerates users with POST /user/display and fetches each user's
/// thread with GET /chat, keeping only threads that have messages.
/// Only reachable when the logged-in nationalId is the support id - that
/// equality check is the ONLY admin check in the app.
///
/// Notes:
/// - /user/display ignores its request body (verified live: an empty body
///   returns the full user list); the isAdmin check in that route is dead
///   code. We send an empty body.
/// - Threads are fetched in concurrent batches with per-request timeouts,
///   newest-registered users first (Mongo ObjectIds are time-ordered), and
///   the list updates progressively as threads are found.
/// - The scan is CAPPED: this backend is shared (1400+ users), so a full
///   scan is slow and pointless - support chats come from recent users.
///   The inbox scans the newest [_scanCap] users and stops early once
///   [_enoughThreads] threads are found; "Scan more" continues with the
///   next chunk.
class AdminChatCubit extends Cubit<AdminChatStates> {
  AdminChatCubit() : super(AdminChatInitialState());

  static AdminChatCubit get(context) => BlocProvider.of(context);

  List<AdminChatThread> threads = [];

  /// Scan progress: [scanned] of [totalUsers] checked so far.
  /// totalUsers == 0 means the user list itself is still loading.
  int scanned = 0;
  int totalUsers = 0;

  bool scanning = false;

  /// True while there are more users beyond the scanned range.
  bool get canScanMore => totalUsers > 0 && scanned < totalUsers;

  static const int _batchSize = 12;

  /// Users scanned per loadThreads() / scanMore() call.
  static const int _scanCap = 100;

  /// Stop the current scan once this many threads have been found.
  static const int _enoughThreads = 5;

  static const Duration _requestTimeout = Duration(seconds: 15);

  List<Map<String, dynamic>> _users = [];

  Future<void> loadThreads() async {
    scanning = false;
    emit(AdminChatLoadingState());
    try {
      final value = await DioHelperStore.postData(
        url: ApiConstants.getUsersApi,
        data: const {},
      ).timeout(_requestTimeout);
      final raw = value.data['user'];
      if (raw is! List) {
        emit(AdminChatErrorState());
        return;
      }
      _users = raw.whereType<Map<String, dynamic>>().toList()
        ..sort((a, b) =>
            (b['_id']?.toString() ?? '').compareTo(a['_id']?.toString() ?? ''));

      threads = [];
      scanned = 0;
      totalUsers = _users.length;
      emit(AdminChatSuccessState());

      // Known conversations first: customers the admin has already opened
      // chats with (tracked locally, see ChatPeersStore) are fetched
      // directly by id pair - no scanning needed for his own threads.
      final peers = ChatPeersStore.getPeers();
      await Future.wait(peers.map(
        (p) => _loadThreadForId(
          p.nationalId,
          name: p.name,
          profileImage: p.image.isEmpty ? null : p.image,
        ),
      ));
      if (threads.isNotEmpty) {
        threads.sort((a, b) => (b.lastTime ?? DateTime(1970))
            .compareTo(a.lastTime ?? DateTime(1970)));
        emit(AdminChatSuccessState());
      }

      await _scanNextChunk();
    } catch (error) {
      print(error.toString());
      emit(AdminChatErrorState());
    }
  }

  /// Continues the scan with the next [_scanCap] users (the "Scan more"
  /// button). No-op while a scan is running or everything is scanned.
  Future<void> scanMore() async {
    if (scanning || !canScanMore || _users.isEmpty) return;
    await _scanNextChunk();
  }

  Future<void> _scanNextChunk() async {
    scanning = true;
    emit(AdminChatSuccessState());
    final end = min(scanned + _scanCap, _users.length);
    for (var i = scanned; i < end; i += _batchSize) {
      // Found enough threads - stop early; "Scan more" resumes here.
      if (threads.length >= _enoughThreads) break;
      final batch = _users.sublist(i, min(i + _batchSize, end));
      await Future.wait(batch.map(_loadThreadForUser));
      scanned = min(i + _batchSize, end);
      threads.sort((a, b) => (b.lastTime ?? DateTime(1970))
          .compareTo(a.lastTime ?? DateTime(1970)));
      emit(AdminChatSuccessState());
    }
    scanning = false;
    emit(AdminChatSuccessState());
  }

  Future<void> _loadThreadForUser(Map<String, dynamic> u) async {
    await _loadThreadForId(
      u['nationalId']?.toString() ?? '',
      name: u['name']?.toString(),
      profileImage: u['profileImage']?.toString(),
    );
  }

  Future<void> _loadThreadForId(
    String id, {
    String? name,
    String? profileImage,
  }) async {
    if (id.isEmpty || id == ApiConstants.supportNationalId) return;
    // Skip customers whose thread is already listed (known peers overlap
    // with the scanned range).
    if (threads.any((t) => t.nationalId == id)) return;
    try {
      final chat = await DioHelperStore.getData(
        url: ApiConstants.chatApi,
        data: {
          'senderNationalId': ApiConstants.supportNationalId,
          'receiverNationalId': id,
        },
      ).timeout(_requestTimeout);
      final msgs = chat.data['messages'];
      if (msgs is List && msgs.isNotEmpty) {
        final last = msgs.last;
        threads.add(AdminChatThread(
          nationalId: id,
          name: name,
          profileImage: profileImage,
          lastMessage: last is Map ? last['content']?.toString() : null,
          lastTime: last is Map
              ? DateTime.tryParse(last['timestamp']?.toString() ?? '')
              : null,
          messageCount: msgs.length,
        ));
      }
    } catch (e) {
      // A user whose thread fails to load is skipped, not fatal.
      print(e.toString());
    }
  }
}
