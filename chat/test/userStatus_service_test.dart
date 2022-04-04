import 'package:chat/src/models/userStatus.dart';
import 'package:chat/src/services/status_encryption/status_encryption_service.dart';
import 'package:chat/src/services/user_status/userStatus_service.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helper.dart';

void main(){
  Rethinkdb rk = Rethinkdb();
  Connection connection;
  UserStatusService userStatusService;
  setUp(()async{
       connection = await rk.connect(host: "127.0.0.1", port: 28015);
    final StatusEncryptionService encryption =
        StatusEncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(rk, connection);
    userStatusService = UserStatusService(rk, connection, encryption);
  });
   tearDown(() async {
    userStatusService.dispose();
    await cleanDb(rk, connection);
  });
 test('Send a new Status Successfully', (() async {
    final userStatus = UserStatus(
      name: 'test',
      statusUrl: 'url',
      time: DateTime.now(),
    );

    final bool isSent = await userStatusService.send(userStatus);
    expect(isSent, true);
  }));
}