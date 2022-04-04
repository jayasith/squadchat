import 'helper.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service.dart';
import 'package:chat/src/services/message/message_service.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  MessageService messageService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    final EncryptionService encryption =
        EncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(rethinkdb, connection);
    messageService =
        MessageService(rethinkdb, connection, encryptionService: encryption);
  });

  tearDown(() async {
    messageService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  final User user1 = User.fromJson({
    'id': "1234",
    'username': 'test',
    'photoUrl': 'url',
    'active': true,
    'lastseen': DateTime.now(),
  });

  final User user2 = User.fromJson({
    'id': "3456",
    'username': 'test',
    'photoUrl': 'url',
    'active': true,
    'lastseen': DateTime.now(),
  });
  test('message sent successfully', (() async {
    final Message message = Message(
      from: user1.id,
      to: '3456',
      timestamp: DateTime.now(),
      contents: 'test message',
    );

    final Message isSent = await messageService.send(message);
    expect(isSent, true);
  }));

  test('subscribe and receive messages successfully', () async {
    final contents = 'test message';

    messageService.messages(activeUser: user2).listen(expectAsync1((message) {
          expect(message.to, user2.id);
          expect(message.id, isNotEmpty);
          expect(message.contents, contents);
        }, count: 2));

    Message message1 = Message(
      from: user1.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: contents,
    );

    Message message2 = Message(
      from: user1.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: contents,
    );

    await messageService.send(message1);
    await messageService.send(message2);
  });

  test('subscribe and receive new messages successfully', () async {
    Message message1 = Message(
      from: user1.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: 'test message',
    );

    Message message2 = Message(
      from: user1.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: 'another test message',
    );

    await messageService.send(message1);
    await messageService.send(message2).whenComplete(
          () => messageService.messages(activeUser: user2).listen(
                expectAsync1((message) {
                  expect(message.to, user2.id);
                }, count: 2),
              ),
        );
  });
}
