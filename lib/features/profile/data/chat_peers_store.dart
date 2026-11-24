import 'package:volt/core/network/local/cache_helper.dart';

/// Locally-tracked list of customers the admin has opened chats with.
/// The backend has no thread-list endpoint, so this is how the admin
/// inbox knows his own conversations without scanning every user.
/// Stored as newline-joined "nationalId|name" rows in shared prefs.
class ChatPeersStore {
  static const _key = 'admin_chat_peers';

  static List<({String nationalId, String name})> getPeers() {
    final raw = CacheHelper.getData(key: _key);
    if (raw is! String || raw.isEmpty) return [];
    final peers = <({String nationalId, String name})>[];
    for (final line in raw.split('\n')) {
      final parts = line.split('|');
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        peers.add((
          nationalId: parts[0],
          name: parts.length > 1 ? parts[1] : '',
        ));
      }
    }
    return peers;
  }

  static Future<void> addPeer(String nationalId, String? name) async {
    if (nationalId.isEmpty) return;
    final cleanName = (name ?? '').replaceAll('|', ' ').replaceAll('\n', ' ');
    final peers = getPeers();
    peers.removeWhere((p) => p.nationalId == nationalId);
    peers.insert(0, (nationalId: nationalId, name: cleanName));
    final raw = peers.map((p) => '${p.nationalId}|${p.name}').join('\n');
    await CacheHelper.saveData(key: _key, value: raw);
  }
}
