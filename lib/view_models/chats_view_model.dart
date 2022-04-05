import 'package:chat/chat.dart';
import 'package:squadchat/data/data_sources/data_source_contract.dart';
import 'package:squadchat/models/chat.dart';
import 'package:squadchat/models/local_message.dart';
import 'package:squadchat/view_models/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  final IDataSource _dataSource;
  final IUserService _iUserService;

  ChatsViewModel(this._dataSource, this._iUserService) : super(_dataSource);

  Future<void> receivedMessage(Message message) async {
    final chatId = message.groupId != null ? message.groupId : message.from;
    LocalMessage localMessage =
        LocalMessage(chatId, message, ReceiptStatus.delivered);
    await addMessage(localMessage);
  }

  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    await Future.forEach(chats, (chat) async {
      final ids = chat.memberId.map<String>((e) => e.keys.first).toList();
      final users = await _iUserService.fetch(ids);
      chat.members = users;
    });

    return chats;
  }
}
