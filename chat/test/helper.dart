import 'package:rethinkdb_dart/rethinkdb_dart.dart';

Future<void> createDb(Rethinkdb rethinkdb, Connection connection) async {
  await rethinkdb.dbCreate('test').run(connection).catchError((err) => {});
  await rethinkdb.tableCreate('user').run(connection).catchError((err) => {});
}

Future<void> cleanDb(Rethinkdb rethinkdb, Connection connection) async {
    await rethinkdb.table('user').delete().run(connection);
}
