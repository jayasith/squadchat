import 'package:flutter/material.dart';
import 'package:squadchat/views/widgets/chat_home/user_online_indicator.dart';

class HomeProfileImage extends StatelessWidget {
  final String imageUrl;
  final bool userOnline;

  const HomeProfileImage({@required this.imageUrl, this.userOnline = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(126.0),
                child: Image.network(imageUrl,
                    width: 126, height: 126, fit: BoxFit.cover)),
            Align(
              alignment: Alignment.topRight,
              child: userOnline ? const UserOnlineIndicator() : Container(),
            )
          ],
        ));
  }
}
