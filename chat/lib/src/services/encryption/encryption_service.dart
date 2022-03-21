import 'package:chat/src/services/encryption/encryption_service_contract.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncryptionService {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(10);

  EncryptionService(this._encrypter);

  @override
  String encrypt(String message) {
    return _encrypter.encrypt(message, iv: _iv).base64;
  }

  @override
  String decrypt(String encryptedMessage) {
    final encrypted = Encrypted.fromBase64(encryptedMessage);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}
