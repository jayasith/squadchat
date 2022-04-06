import 'package:flutter/foundation.dart';

class Message {
  String _id;
  final String from;
  final String to;
  final DateTime timestamp;
  final String contents;
  final String groupId;

  Message(
      {@required this.from,
      @required this.to,
      @required this.timestamp,
      @required this.contents,
      this.groupId});

  String get id => _id;

  toJson() => {
        'from': from,
        'to': to,
        'timestamp': timestamp,
        'contents': contents,
        'group_id': groupId
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    final message = Message(
        from: json['from'],
        to: json['to'],
        timestamp: json['timestamp'],
        contents: json['contents'],
        groupId: json['group_id']);

    message._id = json['id'];
    return message;
  }
}
