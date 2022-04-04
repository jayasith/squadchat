import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chat/src/models/user.dart';

import 'home_router_contract.dart';

class HomeRouter implements IHomeRouter {
  final Widget Function(User receiver, User user, {String chatId})
      showMessageThread;

  HomeRouter({@required this.showMessageThread});
  @override
  Future<void> onShowMessageThread(
      BuildContext context, User receiver, User user,
      {String chatId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receiver, user, chatId: chatId),
      ),
    );
  }
}
