import 'package:squadchat/data/data_sources/data_source_contract.dart';
import 'package:squadchat/models/chat.dart';
import 'package:squadchat/models/local_message.dart';

abstract class BaseViewModel {
  final IDataSource _dataSource;

  BaseViewModel(this._dataSource);

  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId)) {
      final chat = Chat(message.chatId, ChatType.individual, membersId: [
        {message.chatId: ""}
      ]);
      await _createNewChat(chat);
    }
    await _dataSource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataSource.findChat(chatId) != null;
  }

  Future<void> createNewChat(Chat chat) async {
    await _dataSource.addChat(chat);
  }
}
