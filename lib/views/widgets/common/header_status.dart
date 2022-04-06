import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadchat/cache/local_cache_service.dart';
import 'package:squadchat/views/screens/user_profile/user_profile.dart';
import 'package:squadchat/views/widgets/chat_home/home_profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool active;
  static LocalCache localCache;
  final String description;
  final String typing;

  const HeaderStatus(this.username, this.imageUrl, this.active,
      {this.description, this.typing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final sharedPreferences = await SharedPreferences.getInstance();
        localCache = LocalCache(sharedPreferences);
        final currentUser = localCache.fetch('USER');
        if (username == User.fromJson(currentUser).username) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserProfile()));
        }
      },
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
                          active ? 'online' : description,
                          style: Theme.of(context).textTheme.caption,
                        )
                      : Text(typing,
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
