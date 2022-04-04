import 'dart:async';

import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing_event/typing_event_service_contract.dart';
import 'package:chat/src/services/user/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class TypingEventService implements ITypingEventService {
  final Rethinkdb _rethinkdb;
  final Connection _connection;
  final UserService _userService;

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription _changefeed;

  TypingEventService(this._rethinkdb, this._connection, this._userService);

  @override
  Future<bool> send({@required List<TypingEvent> event}) async {
    final receivers = await _userService.fetch(event.map((e) => e.to).toList());

    if (receivers.isEmpty) return false;
    event.retainWhere(
        (element) => receivers.map((e) => e.id).contains(element.to));
    final data = event.map((e) => e.toJson()).toList();
    Map record = await _rethinkdb
        .table('typing_events')
        .insert(data, {'conflict': 'update'}).run(_connection);

    return record['inserted'] >= 1;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingTypingEvents(user, userIds);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  void _startReceivingTypingEvents(User user, List<String> userIds) {
    _changefeed = _rethinkdb
        .table('typing_events')
        .filter((event) {
          return event('to')
              .eq(user.id)
              .and(_rethinkdb.expr(userIds).contains(event('from')));
        })
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;

                final typing = _eventFromFeed(feedData);
                _controller.sink.add(typing);
                _removeEvent(typing);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  TypingEvent _eventFromFeed(feedData) {
    return TypingEvent.fromJson(feedData['new_val']);
  }

  void _removeEvent(TypingEvent event) {
    _rethinkdb.table('typing_events').filter({'chat_id': event.chatId}).delete(
        {'return_changes': false}).run(_connection);
  }
}
