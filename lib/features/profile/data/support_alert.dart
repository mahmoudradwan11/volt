import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';

/// User-side "new support message" alert. The backend has no push
/// notifications, so this polls the user's support thread (GET /chat
/// against the support id) on a light cadence and exposes an unread
/// count for the home bell badge plus a preview for the notifications
/// screen. In-app only - no phone push.
///
/// Cadence: one check when the home screen appears, then every
/// [_interval] while the app runs (a single GET /chat request per
/// cycle). Read state is a timestamp in shared prefs; opening the
/// support chat marks the thread read.
class SupportAlert {
  SupportAlert._();
  static final SupportAlert instance = SupportAlert._();

  static const _lastSeenKey = 'support_last_seen';
  static const _interval = Duration(seconds: 60);

  /// Unread support-message count, drives the bell badge.
  final ValueNotifier<int> unread = ValueNotifier(0);

  /// Preview of the newest unread support message.
  final ValueNotifier<String?> preview = ValueNotifier(null);

  Timer? _timer;
  bool _checking = false;

  String get _myId =>
      (CacheHelper.getData(key: 'userId') ?? nationalId)?.toString() ?? '';

  bool get _isAdmin => isAdminNationalId(_myId);

  /// Starts polling. Idempotent; no-op for the admin (he has the Support
  /// Inbox instead) and for logged-out users.
  void start() {
    if (_timer != null || _isAdmin || _myId.isEmpty) return;
    check();
    _timer = Timer.periodic(_interval, (_) => check());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// First launch after this feature lands starts clean - only messages
  /// arriving from then on light the badge.
  DateTime get _lastSeen {
    final raw = CacheHelper.getData(key: _lastSeenKey);
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    return DateTime.now();
  }

  /// One poll: count thread messages FROM the support id newer than
  /// last-seen. A failed poll just skips the cycle.
  Future<void> check() async {
    if (_checking || _isAdmin || _myId.isEmpty) return;
    _checking = true;
    try {
      final value = await DioHelperStore.getData(
        url: ApiConstants.chatApi,
        data: {
          'senderNationalId': _myId,
          'receiverNationalId': ApiConstants.supportNationalId,
        },
      ).timeout(const Duration(seconds: 15));
      final list = value.data['messages'];
      var count = 0;
      String? lastText;
      if (list is List) {
        for (final item in list) {
          if (item is! Map) continue;
          if (item['senderNationalId']?.toString() !=
              ApiConstants.supportNationalId) {
            continue;
          }
          final ts = DateTime.tryParse(item['timestamp']?.toString() ?? '');
          if (ts != null && ts.isAfter(_lastSeen)) {
            count++;
            lastText = item['content']?.toString();
          }
        }
      }
      unread.value = count;
      preview.value = lastText;
    } catch (_) {}
    _checking = false;
  }

  /// Marks the thread read (opening the chat) and clears the badge.
  Future<void> markRead() async {
    unread.value = 0;
    preview.value = null;
    await CacheHelper.saveData(
      key: _lastSeenKey,
      value: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
