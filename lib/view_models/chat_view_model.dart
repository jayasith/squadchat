import 'package:chat/chat.dart';
import 'package:squadchat/data/data_sources/data_source_contract.dart';
import 'package:squadchat/models/local_message.dart';
import 'package:squadchat/view_models/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  final IDataSource _dataSource;
  String _chatId = '';
  int otherMessages = 0;

  String get chatId => _chatId;

  ChatViewModel(this._dataSource) : super(_dataSource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.sent);
    if (_chatId.isNotEmpty) return await _dataSource.addMessage(localMessage);
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);
    //! check if this persists
    if (_chatId.isEmpty) _chatId = localMessage.chatId;
    if (localMessage.chatId != _chatId) otherMessages++;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _dataSource.updateMessageReceipt(receipt.messageId, receipt.status);
  }
}
