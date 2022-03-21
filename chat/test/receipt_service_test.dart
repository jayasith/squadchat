import 'helper.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  ReceiptService receiptService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    receiptService = ReceiptService(rethinkdb, connection);
  });

  tearDown(() async {
    receiptService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  final User user = User.fromJson({
    'id': "1234",
    'username': 'test',
    'photoUrl': 'url',
    'active': true,
    'lastseen': DateTime.now(),
  });

  test('sent receipt successfully', () async {
    Receipt receipt = Receipt(
        recipient: '1234',
        messageId: '1111',
        status: ReceiptStatus.delivered,
        timestamp: DateTime.now());

    final res = await receiptService.send(receipt);
    expect(res, true);
  });

  test('subscribe and receive receipts successfully', () async {
    receiptService.receipts(user).listen(expectAsync1((receipt) {
          expect(receipt.recipient, user.id);
        }, count: 2));

    Receipt receipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.delivered,
        timestamp: DateTime.now());

    Receipt anotherReceipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.delivered,
        timestamp: DateTime.now());

    await receiptService.send(receipt);
    await receiptService.send(anotherReceipt);
  });
}
