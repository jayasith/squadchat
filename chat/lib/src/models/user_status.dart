import 'package:flutter/foundation.dart';

class UserStatus{
  final String userId;
  String name;
  String statusUrl;
  DateTime time;
  String _id;
 

  UserStatus(
  { @required this.userId,
    @required this.name,
    @required this.statusUrl,
    @required this.time 
  });
  String get id => _id;

toJson() => {
  'user_id':userId,
  'name' : name,
  'statusUrl' : statusUrl,
  'time' : time
};
factory UserStatus.fromJson(Map<String, dynamic> json){
  final userStatus = UserStatus(
    userId: json['userId'],
    name: json['name'],
    statusUrl: json['statusUrl'],
    time: json['time']);
    
  userStatus._id = json['id'];
  return userStatus; 
  
}

}