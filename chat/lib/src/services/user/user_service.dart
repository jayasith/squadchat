import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_constract.dart';

import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {
  Connection _connection;
  Rethinkdb rethinkdb;

  UserService(this.rethinkdb, this._connection);

  @override
  Future<User> connect(User user) async {
    var data = user.toJson();

    if (user.id != null) data['id'] = user.id;

    final result = await rethinkdb.table('user').insert(
        data, {'conflict': 'update', 'return_changes': true}).run(_connection);

    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(User user) async {
    await rethinkdb.table('user').update({
      'id': user.id,
      'active': false,
      'last_seen': DateTime.now(),
    }).run(_connection);
    _connection.close();
  }

  @override
  Future<List<User>> online() async {
    Cursor users =
        await rethinkdb.table('user').filter({'active': true}).run(_connection);
    final userList = await users.toList();
    return userList.map((user) => User.fromJson(user)).toList();
  }
}
