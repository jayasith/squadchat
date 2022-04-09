import 'dart:async';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/user_status.dart';
import 'package:chat/src/services/user_status/user_status_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';


class UserStatusService implements IStatusService{
  final Connection _connection;
  final Rethinkdb rk;

  final _controller = StreamController<UserStatus>.broadcast();
  StreamSubscription _changefeed;

  UserStatusService(this.rk,this._connection);
   


  @override
  Future<bool> send(UserStatus userStatus) async {
    final data = userStatus.toJson();
   Map record =
        await rk.table('userStatus').insert(data).run(_connection);
    return record['inserted'] == 1;
     }

  @override
  Future<UserStatus> fetchOtherStatus(String userStatusId) async{
    final UserStatus = await rk
        .table('userStatus')
        .run(_connection);
    return UserStatus.fromJson(UserStatus);
  }

  @override
  Future<UserStatus> fetchStatus(String userStatusId) async{
    final UserStatus = await rk
        .table('userStatus').pluck('time')
        .run(_connection);
    return UserStatus.fromJson(UserStatus);
  }

  // @override
  //  Future<void> deleteStatus(String userStatusId)async{
  //   print(userStatusId);
  //   await rk
  //       .table('userStatus')
  //       .filter({'id': userStatusId})
  //       .delete()
  //       .run(_connection);
  //   _connection.close();
  //  }

  @override
  Stream<UserStatus> userStatus(User user) {
    _startReceivingStatus(user);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  void _startReceivingStatus(User user) {
    _changefeed = rk
        .table('userStatus')
        .filter({'userStatus': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
      event.forEach((feedData) {
        if (feedData['new_val'] == null) return;

        final userStatus = userStatusFromFeed(feedData);
        _removeDeliveredReceipt(userStatus);
        _controller.sink.add(userStatus);
      }).catchError((error) {
        print(error);
      }).onError((error, stackTrace) => print(error));
    });
  }

  UserStatus userStatusFromFeed(feedData) {
    final data = feedData['new_val'];
    return UserStatus.fromJson(data);
  }

  _removeDeliveredReceipt(UserStatus userStatus){
    rk.table('userStatus').get(userStatus.id).delete({'return_changes':false}).run(_connection);
  }
}
