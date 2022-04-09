import 'package:flutter/foundation.dart';

class UserStatus {
  String _id;
  String username;
  String statusUrl;
  DateTime time;

  UserStatus(
      {@required this.username, @required this.statusUrl, @required this.time});

  String get id => _id;

  toJson() => {'username': username, 'statusUrl': statusUrl, 'time': time};

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    final userStatus = UserStatus(
        username: json['username'],
        statusUrl: json['statusUrl'],
        time: json['time']);

    userStatus._id = json['id'];
    return userStatus;
  }
}
