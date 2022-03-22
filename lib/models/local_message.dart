import 'package:chat/chat.dart';

class LocalMessage {
  String _id;
  String chatId;
  Message message;
  ReceiptStatus receipt;

  LocalMessage(this.chatId, this.message, this.receipt);

  String get id => _id;

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'id': message.id,
        ...message.toJson(),
        'receipt': receipt.value(),
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['from'],
        to: json['to'],
        contents: json['contents'],
        timestamp: DateTime.parse(json['timestamp']));

    final localMessage =
        LocalMessage(json['chat_id'], message, json['receipt']);
    localMessage._id = json['id'];

    return localMessage;
  }
}
