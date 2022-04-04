import 'dart:async';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class MessageService implements IMessageService {
  final Rethinkdb rethinkdb;
  final Connection _connection;
  final EncryptionService _encryptionService;

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription _changefeed;

  MessageService(this.rethinkdb, this._connection,
      {EncryptionService encryptionService})
      : _encryptionService = encryptionService;

  @override
  Future<Message> send(Message message) async {
    final data = message.toJson();
    if (_encryptionService != null) {
      data['contents'] = _encryptionService.encrypt(data['contents']);
    }
    Map record =
        await rethinkdb.table('messages').insert(data,{'return_changes':true}).run(_connection);
    return Message.fromJson(record['changes'].first['new_val']);
  }

  @override
  Stream<Message> messages({User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  void _startReceivingMessages(User activeUser) {
    _changefeed = rethinkdb
        .table('messages')
        .filter({'to': activeUser.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final message = messageFromFeed(feedData);
            _controller.sink.add(message);
            _removeDeliveredMessage(message);
          }).catchError((error) {
            print(error);
          }).onError((error, stackTrace) => print(error));
        });
  }

  Message messageFromFeed(feedData) {
    final data = feedData['new_val'];
    if (_encryptionService != null) {
      data['contents'] = _encryptionService.decrypt(data['contents']);
    }

    return Message.fromJson(data);
  }

  void _removeDeliveredMessage(Message message) {
    rethinkdb
        .table('messages')
        .get(message.id)
        .delete({'return_changes': false}).run(_connection);
  }
}
