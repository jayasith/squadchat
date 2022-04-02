import 'package:chat/src/models/user.dart';

abstract class IUserService {
  Future<User> connect(User user);
  Future<List<User>> online();
  Future<void> disconnect(User user);
  Future<void> reconnect(User user);
  Future<void> deleteUser(String userId);
  Future<User> fetch(String chatId);
  Future<User> fetchUser(String userId);
}
