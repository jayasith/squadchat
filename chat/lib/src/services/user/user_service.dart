import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {
  final Rethinkdb rethinkdb;
  final Connection _connection;

  UserService(this.rethinkdb, this._connection);

  @override
  Future<User> connect(User user) async {
    print('connecting user...');
    var data = user.toJson();

    if (user.id != null) data['id'] = user.id;

    final result = await rethinkdb.table('users').insert(
        data, {'conflict': 'update', 'return_changes': true}).run(_connection);

    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(String userId) async {
    print('disconnecting user...');
    try {
      await rethinkdb.table('users').filter({'id': userId}).update({
        'active': false,
        'last_seen': DateTime.now(),
      }).run(_connection);
    } catch (e) {
      print(e);
    }
    // _connection.close();
  }

  @override
  Future<void> reconnect(String userId) async {
    print('reconnecting user...');
    try {
      await rethinkdb.table('users').filter({
        'id': userId,
      }).update({
        'active': true,
        'last_seen': DateTime.now(),
      }).run(_connection);
    } catch (e) {
      print(e);
    }

    // _connection.close();
  }

  @override
  Future<List<User>> online() async {
    Cursor users = await rethinkdb
        .table('users')
        .filter({'active': true}).run(_connection);
    final userList = await users.toList();
    return userList.map((user) => User.fromJson(user)).toList();
  }

  @override
  Future<void> deleteUser(String userId) async {
    print('removing user...');
    await rethinkdb
        .table('users')
        .filter({'id': userId})
        .delete()
        .run(_connection);
    _connection.close();
  }

  @override
  Future<User> fetch(String chatId) async {
    final user = await rethinkdb.table('users').get(chatId).run(_connection);
    return User.fromJson(user);
  }

  @override
  Future<User> fetchUser(String userId) async {
    final user = await rethinkdb
        .table('users')
        .filter({'id': userId})
        .pluck('username', 'active', 'last_seen')
        .run(_connection);
    return User.fromJson(user);
  }
}
