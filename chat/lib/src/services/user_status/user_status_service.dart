import 'dart:async';
import 'package:chat/src/models/user_status.dart';
import 'package:chat/src/services/user_status/user_status_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';


class UserStatusService implements IUserStatusService{
  final Connection _connection;
  final Rethinkdb rk;


  UserStatusService(this.rk,this._connection);
   


  @override
  Future<bool> send(UserStatus userStatus) async {
    final data = userStatus.toJson();
   Map record =
        await rk.table('userStatus').insert(data).run(_connection);
    return record['inserted'] == 1;
     }

  @override
  Future<UserStatus> fetchStatus(String userStatusId) async{
    final UserStatus = await rk
        .table('userStatus')
        .filter({'id': userStatusId})
        .pluck('username', 'statusUrl', 'time')
        .run(_connection);
    return UserStatus.fromJson(UserStatus);
  }
  
  @override
   Future<void> deleteStatus(String userStatusId)async{
    print(userStatusId);
    await rk
        .table('userStatus')
        .filter({'id': userStatusId})
        .delete()
        .run(_connection);
    _connection.close();
   }
}
