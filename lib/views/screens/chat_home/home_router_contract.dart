import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(
      BuildContext context, User receiver, User user,
      {String chatId});
}
