import 'package:flutter/material.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/theme.dart';

class UserOnlineIndicator extends StatelessWidget {
  const UserOnlineIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
        color: indicatorBubble,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 3.0,
          color: isLightTheme(context) ? Colors.white : Colors.black,
        )
      )
    );
  }
}