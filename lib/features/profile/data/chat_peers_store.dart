import 'package:volt/core/network/local/cache_helper.dart';

/// Locally-tracked list of customers the admin has opened chats with.
/// The backend has no thread-list endpoint, so this is how the admin
/// inbox knows his own conversations without scanning every user.
/// Stored as newline-joined "nationalId|name|image" rows in shared
/// prefs (the image column is optional; older two-column rows parse).
class ChatPeersStore {
  static const _key = 'admin_chat_peers';

  static List<({String nationalId, String name, String image})> getPeers() {
    final raw = CacheHelper.getData(key: _key);
    if (raw is! String || raw.isEmpty) return [];
    final peers = <({String nationalId, String name, String image})>[];
    for (final line in raw.split('\n')) {
      final parts = line.split('|');
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        peers.add((
          nationalId: parts[0],
          name: parts.length > 1 ? parts[1] : '',
          image: parts.length > 2 ? parts[2] : '',
        ));
      }
    }
    return peers;
  }

  static Future<void> addPeer(String nationalId, String? name,
      {String? image}) async {
    if (nationalId.isEmpty) return;
    String clean(String? s) =>
        (s ?? '').replaceAll('|', ' ').replaceAll('\n', ' ');
    final peers = getPeers();
    peers.removeWhere((p) => p.nationalId == nationalId);
    peers.insert(
        0, (nationalId: nationalId, name: clean(name), image: clean(image)));
    final raw =
        peers.map((p) => '${p.nationalId}|${p.name}|${p.image}').join('\n');
    await CacheHelper.saveData(key: _key, value: raw);
  }
}
