import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squadchat/views/screens/user_profile/user_profile.dart';
import 'package:squadchat/views/widgets/chat_home/home_profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool active;
  final DateTime lastseen;
  final bool typing;

  const HeaderStatus(this.username, this.imageUrl, this.active,
      {this.lastseen, this.typing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserProfile())),
      child: Container(
          width: double.maxFinite,
          child: Row(children: [
            HomeProfileImage(
              imageUrl: imageUrl,
              userOnline: active,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(username.trim(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: typing == null
                      ? Text(
                          active
                              ? 'online'
                              : 'lastseen ${DateFormat.yMd().add_jm().format(lastseen)}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      : Text('typing...',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontStyle: FontStyle.italic)),
                )
              ],
            )
          ])),
    );
  }
}
