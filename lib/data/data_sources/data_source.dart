import 'package:chat/src/models/receipt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:squadchat/data/data_sources/data_source_contract.dart';
import 'package:squadchat/models/chat.dart';
import 'package:squadchat/models/local_message.dart';

class DataSource implements IDataSource {
  final Database _db;

  const DataSource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert('messages', message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.update(
          'chats', {'updated_at': message.message.timestamp.toString()},
          where: 'id = ?', whereArgs: [message.chatId]);
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();

    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final listOfChatMap = await txn.query('chat', orderBy: 'updated_at DESC');

      if (listOfChatMap.isEmpty) return [];

      return await Future.wait(listOfChatMap.map<Future<Chat>>((row) async {
        final unread = Sqflite.firstIntValue(await txn.rawQuery(
            'SELECT COUNT(*) FROM MESSAGE WHERE chat_id = ? AND receipt = ?',
            [row['id'], 'deliverred']));

        final mostRecentMessage = await txn.query('messages',
            where: 'chat_id = ?',
            whereArgs: [row['id']],
            orderBy: 'created_at DESC',
            limit: 1);

        final chat = Chat.fromMap(row);
        chat.unread = unread;
        if (mostRecentMessage.isNotEmpty) {
          chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
        }
        return chat;
      }));
    });
  }

  @override
  Future<Chat> findChat(String chatId) async {
    return await _db.transaction((transaction) async {
      final listOfChatMaps = await transaction.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await transaction.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'delivered']));

      final mostRecentMessage = await transaction.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);
      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread;
      if(mostRecentMessage.isNotEmpty) {
        chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      }
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    return _db.transaction((transaction) async {
      await transaction.update('messages', {'receipt': status.value()},
          where: 'id = ?',
          whereArgs: [messageId],
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
}
