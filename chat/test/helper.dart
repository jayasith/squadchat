import 'package:rethinkdb_dart/rethinkdb_dart.dart';

Future<void> createDb(Rethinkdb rethinkdb, Connection connection) async {
  await rethinkdb.dbCreate('test').run(connection).catchError((err) => {});
  await rethinkdb.tableCreate('users').run(connection).catchError((err) => {});
}

Future<void> cleanDb(Rethinkdb rethinkdb, Connection connection) async {
  await rethinkdb.table('users').delete().run(connection);
}
