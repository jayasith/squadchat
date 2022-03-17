import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helper.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  UserService userService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    userService = UserService(rethinkdb, connection);
  });

  tearDown(() async {
    await cleanDb(rethinkdb, connection);
  });

  test('create a new user', (() async {
    final user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );

    await userService.connect(user);

    final users = await userService.online();
    expect(users.length,1);
  }));
}
