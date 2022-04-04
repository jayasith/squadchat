import 'package:chat/src/models/userStatus.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IUserStatusService {
  Future<bool> send(UserStatus userStatus);
  Stream<UserStatus> userStatus({@required User activeUser});
  void dispose();
}
