/// One support-chat message, as returned by the backend chat API
/// (GET/POST /chat on the Elwekala API).
class ChatMessageModel {
  String? id;
  String? senderNationalId;
  String? receiverNationalId;
  String? content;
  DateTime? timestamp;

  ChatMessageModel({
    this.id,
    this.senderNationalId,
    this.receiverNationalId,
    this.content,
    this.timestamp,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    senderNationalId = json['senderNationalId'];
    receiverNationalId = json['receiverNationalId'];
    content = json['content'];
    if (json['timestamp'] != null) {
      timestamp = DateTime.tryParse(json['timestamp'].toString());
    }
  }
}
