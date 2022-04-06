import 'package:chat/src/models/user_status.dart';

abstract class IUserStatusService {
  Future<bool> send(UserStatus userStatus);
   Future<UserStatus> fetchStatus(String userStatusId);
   Future<void> deleteStatus(String userStatusId);
}
