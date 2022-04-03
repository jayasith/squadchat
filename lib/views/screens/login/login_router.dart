import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:squadchat/views/screens/login/login_router_contract.dart';

class LoginRouter implements ILoginRouter {
  final Widget Function(User user) onSessionConnected;
  LoginRouter(this.onSessionConnected);

  @override
  void onSessionSuccess(context, User user) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => onSessionConnected(user)),
        (Route<dynamic> route) => false);
  }
}
