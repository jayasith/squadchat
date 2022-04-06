import 'dart:async';

import 'package:chat/chat.dart';
import 'package:chat/src/models/group_message.dart';
import 'package:flutter/foundation.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

abstract class GroupService {
  Future<GroupMessage> create(GroupMessage groupMessage);

  Stream<GroupMessage> groups({@required User user});

  remove();

  dispose();
}

class GroupMessageService implements GroupService {
  final Rethinkdb rethinkdb;
  final Connection _connection;

  final _controller = StreamController<GroupMessage>.broadcast();
  StreamSubscription _changefeed;

  GroupMessageService(this.rethinkdb, this._connection);

  @override
  Future<GroupMessage> create(GroupMessage groupMessage) async {
    Map records = await rethinkdb.table('group_message').insert(
        groupMessage.toJson(), {'return_changes': true}).run(_connection);

    return GroupMessage.fromJson(records['changes'].first['new_val']);
  }

  @override
  Stream<GroupMessage> groups({User user}) {
    _receivingGroupMessages(user);
    return _controller.stream;
  }

  @override
  dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  @override
  remove() {}

  _receivingGroupMessages(User user) {
    _changefeed = rethinkdb
        .table('group_message')
        .filter(
          (group) => group('members')
              .contains(user.id)
              .and(group('created_by').ne(user.id))
              .and(group
                  .hasFields('received_by')
                  .not()
                  .or(group('received_by'))
                  .contains(user.id)
                  .not()),
        )
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((element) {
                if (element['new_val'] == null) return;

                final group = _groupFromFeed(element);
                _controller.sink.add(group);
                _updateGroupCreation(group, user);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  GroupMessage _groupFromFeed(element) {
    var data = element['new_val'];
    return GroupMessage.fromJson(data);
  }

  _updateGroupCreation(GroupMessage group, User user) async {
    Map updatedRecords =
        await rethinkdb.table('group_message').get(group.id).update(
            (group) => rethinkdb.branch(group.hasFields('received_by'), {
                  'received_by': group('received_by').append(user.id)
                }, {
                  'received_by': [user.id]
                }),
            {'return_changes': 'always'}).run(_connection);
    _removeChatGroup(updatedRecords['changes'][0]);
  }

  _removeChatGroup(Map map) {
    final List members = map['new_val']['members'];
    final List alreadyReceived = map['new_val']['received_by'];
    final String id = map['new_val']['id'];

    if (members.length > alreadyReceived.length) return;

    rethinkdb
        .table('group_message')
        .get(id)
        .delete({'return_changes': false}).run(_connection);
  }
}
