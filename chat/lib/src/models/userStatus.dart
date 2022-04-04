import 'package:flutter/foundation.dart';

class UserStatus{
  String name;
  String statusUrl;
  String _id;
  DateTime time;

  UserStatus(
    {@required String name,
    @required String statusUrl,
    @required DateTime time
  });
  String get id => _id;

toJson() => {
  'name' : name,
  'statusUrl' : statusUrl,
  'time' : time
};
factory UserStatus.fromJson(Map<String, dynamic> json){
  final userStatus = UserStatus(
    name: json['name'],
    statusUrl: json['statusUrl'],
    time: json['time']);
    
  userStatus._id = json['id'];
  return userStatus; 
  
}

}