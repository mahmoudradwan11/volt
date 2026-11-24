import 'package:volt/core/barrel/barrel_network.dart';

/// Resolves a product reviewer to their user record. The reviews endpoint
/// returns only the reviewer's name and profileImage - NOT their
/// nationalId (verified live against GET /review/allreviews/:productId) -
/// so the admin's "chat with reviewer" flow matches the reviewer against
/// the user list by exact name, with the profile image as a tiebreak when
/// names collide. Returns null when the match is missing or ambiguous.
class ReviewerResolver {
  static List<Map<String, dynamic>>? _cache;

  static Future<List<Map<String, dynamic>>> _users() async {
    if (_cache != null) return _cache!;
    final value = await DioHelperStore.postData(
      url: ApiConstants.getUsersApi,
      data: const {},
    ).timeout(const Duration(seconds: 15));
    final raw = value.data['user'];
    _cache =
        raw is List ? raw.whereType<Map<String, dynamic>>().toList() : [];
    return _cache!;
  }

  static Future<Map<String, dynamic>?> resolve({
    String? name,
    String? profileImage,
  }) async {
    if (name == null || name.trim().isEmpty) return null;
    try {
      final users = await _users();
      final matches =
          users.where((u) => u['name']?.toString() == name).toList();
      if (matches.length == 1) return matches.first;
      if (matches.length > 1 && profileImage != null) {
        final byImage = matches
            .where((u) => u['profileImage']?.toString() == profileImage)
            .toList();
        if (byImage.length == 1) return byImage.first;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
