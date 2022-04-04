import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class ITypingEventService {
  Future<bool> send({@required List<TypingEvent> event});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
