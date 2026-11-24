/// One row in the admin's support inbox: a user who has exchanged at
/// least one chat message with the support account.
class AdminChatThread {
  String nationalId;
  String? name;
  String? profileImage;
  String? lastMessage;
  DateTime? lastTime;
  int messageCount;

  AdminChatThread({
    required this.nationalId,
    this.name,
    this.profileImage,
    this.lastMessage,
    this.lastTime,
    this.messageCount = 0,
  });
}
