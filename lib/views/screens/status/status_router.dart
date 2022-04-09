import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IStatusRouter {
  Future<void> onShowStatusThread(
      BuildContext context, UserStatus userStatus,
      {String userId});
}
