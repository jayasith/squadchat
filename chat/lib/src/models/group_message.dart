import 'package:flutter/foundation.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class GroupMessage {
  String name;
  String createdBy;
  List<String> members;
  String _id;

  String get id => _id;

  GroupMessage(
      {@required this.createdBy, @required this.name, @required this.members});

  toJson() => {
        'created_by': this.createdBy,
        'name': this.name,
        'members': this.members
      };

  factory GroupMessage.fromJson(Map<String, dynamic> json) {
    var group = GroupMessage(
        createdBy: json['created_by'],
        name: json['name'],
        members: List<String>.from(json['members']));
    group._id = json['id'];
    return group;
  }

}
