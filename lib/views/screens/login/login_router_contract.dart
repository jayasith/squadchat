import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class ILoginRouter {
  void onSessionSuccess(BuildContext context, User user);
}
