import 'package:flutter/material.dart';

import '../../../../../colors.dart';

class GroupChatProfile extends StatelessWidget {
  const GroupChatProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(126.0),
                      child: const Icon(
                        Icons.group_rounded,
                        size: 35,
                        color: primary,
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
