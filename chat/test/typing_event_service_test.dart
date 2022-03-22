import 'helper.dart';
import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing_event/typing_event_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  TypingEventService typingEventService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    typingEventService = TypingEventService(rethinkdb, connection);
  });

  tearDown(() async {
    typingEventService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  final user1 = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  final user2 = User.fromJson({
    'id': '4567',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  test('typing event sent successfully', () async {
    TypingEvent typingEvent =
        TypingEvent(from: user2.id, to: user1.id, event: Typing.start);

    final res = await typingEventService.send(event: typingEvent, to: user1);
    expect(res, true);
  });

  test('subscribe and receive typing events successfully', () async {
    typingEventService
        .subscribe(user2, [user1.id]).listen(expectAsync1((event) {
      expect(event.from, user1.id);
    }, count: 2));

    TypingEvent typing = TypingEvent(
      to: user2.id,
      from: user1.id,
      event: Typing.start,
    );

    TypingEvent stopTyping = TypingEvent(
      to: user2.id,
      from: user1.id,
      event: Typing.stop,
    );

    await typingEventService.send(event: typing, to: user2);
    await typingEventService.send(event: stopTyping, to: user2);
  });
}
