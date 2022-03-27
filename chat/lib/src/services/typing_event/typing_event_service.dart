import 'dart:async';

import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing_event/typing_event_service_contract.dart';
import 'package:flutter/foundation.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class TypingEventService implements ITypingEventService {
  final Rethinkdb _rethinkdb;
  final Connection _connection;

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription _changefeed;

  TypingEventService(this._rethinkdb, this._connection);

  @override
  Future<bool> send({@required TypingEvent event, User to}) async {
    if (!to.active) return false;

    Map record = await _rethinkdb
        .table('typing_events')
        .insert(event.toJson(), {'conflict': 'update'}).run(_connection);

    return record['inserted'] == 1;
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
    _rethinkdb
        .table('typing_events')
        .get(event.id)
        .delete({'return_changes': false}).run(_connection);
  }
}
