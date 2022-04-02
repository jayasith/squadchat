import 'dart:async';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class ReceiptService implements IReceiptService {
  final Rethinkdb rethinkdb;
  final Connection _connection;

  final _controller = StreamController<Receipt>.broadcast();
  StreamSubscription _changefeed;

  ReceiptService(this.rethinkdb, this._connection);

  @override
  Future<bool> send(Receipt receipt) async {
    final data = receipt.toJson();
    Map record =
        await rethinkdb.table('receipts').insert(data).run(_connection);
    return record['inserted'] == 1;
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  void _startReceivingReceipts(User user) {
    _changefeed = rethinkdb
        .table('receipts')
        .filter({'recipient': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final receipt = receiptFromFeed(feedData);
            _removeDeliveredReceipt(receipt);
            _controller.sink.add(receipt);
          }).catchError((error) {
            print(error);
          }).onError((error, stackTrace) => print(error));
        });
  }

  Receipt receiptFromFeed(feedData) {
    final data = feedData['new_val'];
    return Receipt.fromJson(data);
  }

  _removeDeliveredReceipt(Receipt receipt){
    rethinkdb.table('receipts').get(receipt.id).delete({'return_changes':false}).run(_connection);
  }

}
