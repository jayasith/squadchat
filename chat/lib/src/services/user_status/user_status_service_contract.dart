import 'package:chat/src/models/user_status.dart';
import '../../../chat.dart';

abstract class IStatusService {
  Future<bool> send(UserStatus userStatus);
  Future<UserStatus>fetchOtherStatus(String userStatusId);
   Future<UserStatus> fetchStatus(String userStatusId);
   // Future<void> deleteStatus(String userStatusId);
  Stream<UserStatus> userStatus(User user);
  void dispose();
}
