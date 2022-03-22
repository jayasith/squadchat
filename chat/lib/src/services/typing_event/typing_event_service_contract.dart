import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class ITypingEventService {
  Future<bool> send({@required TypingEvent event, @required User to});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
