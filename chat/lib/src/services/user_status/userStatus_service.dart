import 'dart:async';
import 'package:chat/chat.dart';
import 'package:chat/src/models/userStatus.dart';
import 'package:chat/src/services/user_status/userStatus_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import '../status_encryption/status_encryption_service.dart';

class UserStatusService implements IUserStatusService{
  final Connection _connection;
  final Rethinkdb rk;
  final StatusEncryptionService _encryptionService;

  final _controller = StreamController<UserStatus>.broadcast();
  StreamSubscription _changefeed;

  UserStatusService(this.rk,this._connection,this._encryptionService);
   


  @override
  Future<bool> send(UserStatus userStatus) async {
    final data = userStatus.toJson();
    data['contents'] = _encryptionService.encrypt(data['contents']);
   Map record =
        await rk.table('userStatus').insert(data).run(_connection);
    return record['inserted'] == 1;
     }

  @override
  Stream<UserStatus> userStatus({User activeUser}) {
     _startReceivingStatus(activeUser);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }
  
  void _startReceivingStatus(User activeUser) {
    _changefeed = rk
        .table('userStatus')
        .filter({'to': activeUser.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final userStatus = statusFromFeed(feedData);
            _controller.sink.add(userStatus);
            _removeDeliveredStatus(userStatus);
          }).catchError((error) {
            print(error);
          }).onError((error, stackTrace) => print(error));
        });
  }

  UserStatus statusFromFeed(feedData) {
    final data = feedData['new_val'];
    data['contents'] = _encryptionService.decrypt(data['contents']);

    return UserStatus.fromJson(data);
  }

  void _removeDeliveredStatus(UserStatus userStatus) {
    rk
        .table('userStatus')
        .get(userStatus.id)
        .delete({'return_changes': false}).run(_connection);
  }
}
