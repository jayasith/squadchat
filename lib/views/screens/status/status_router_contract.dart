import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IStatusRouter {
  void onSessionSuccess(BuildContext context, UserStatus userStatus);
}
