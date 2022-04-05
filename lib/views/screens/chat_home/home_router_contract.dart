import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

import '../../../models/chat.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(BuildContext context, List<User> receivers,
      User user,
      Chat chat);

  Future<void> onShowGroupCreation(BuildContext context, List<User> actives,
      User user)
}
