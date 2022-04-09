import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/user_status.dart';
import 'package:chat/src/services/user_status/user_status_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helper.dart';

void main(){
  Rethinkdb rk = Rethinkdb();
  Connection connection;
  UserStatusService userStatusService;

  setUp(()async{
    connection = await rk.connect(host: "127.0.0.1", port: 28015);
    await createDb(rk, connection);
    userStatusService = UserStatusService(rk, connection);
  });
   tearDown(() async {
    await cleanDb(rk, connection);
  });
  final user = User.fromJson({
      'id': '1234' ,
    'username':'test1',
      'lastseen': DateTime.now(),
  });

  final user2 = User.fromJson({
      'id': '124' ,
      'username':'test2',
      'lastseen': DateTime.now(),
  });

 test('Send a new Status Successfully', (() async {
    final userStatus = UserStatus(
      username: 'test2',
      statusUrl: 'url',
      time: DateTime.now(),
    );

    final bool isUpload = await userStatusService.send(userStatus);
    expect(isUpload, true);
  }));
}