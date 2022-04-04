
import 'package:chat/src/services/status_encryption/status_encryption_contract.dart';
import 'package:encrypt/encrypt.dart';

class StatusEncryptionService implements IStatusEncryptionService {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(10);

  StatusEncryptionService(this._encrypter);

  @override
  String encrypt(String status) {
    return _encrypter.encrypt(status, iv: _iv).base64;
  }

  @override
  String decrypt(String encryptedStatus) {
    final encrypted = Encrypted.fromBase64(encryptedStatus);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}
