abstract class IStatusEncryptionService {
  String encrypt(String status);
  String decrypt(String encryptedStatus);
}
