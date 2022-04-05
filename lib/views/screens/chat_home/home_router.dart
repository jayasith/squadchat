import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chat/src/models/user.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../models/chat.dart';
import 'home_router_contract.dart';

class HomeRouter implements IHomeRouter {
  final Widget Function(List<User> receivers, User user, Chat chat)
      showMessageThread;

  final Widget Function(List<User> actives, User user)
      showGroupCreation;

  HomeRouter({@required this.showMessageThread, @required this.showGroupCreation});

  @override
  Future<void> onShowMessageThread(
      BuildContext context, List<User> receivers, User user,
      Chat chat) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receivers, user, chat),
      ),
    );
  }

  @override
  Future<void> onShowGroupCreation(
      BuildContext context, List<User> actives, User user) async{
    showCupertinoModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        builder: (context) => showGroupCreation(actives, user),
    );
  }
}
