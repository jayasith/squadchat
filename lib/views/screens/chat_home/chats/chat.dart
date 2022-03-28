import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squadchat/theme.dart';

import '../../../../colors.dart';
import '../../../widgets/chat_home/home_profile_image.dart';

class Chat extends StatefulWidget {
  const Chat();

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 10.0, right: 16.0),
        itemBuilder: (_, index) => _chatRow(),
        separatorBuilder: (_, __) =>  Divider(
          color: isLightTheme(context) ? Colors.white : Colors.black,
          height: 0.0,
          endIndent: 30.0,
        ),
        itemCount: 5);
  }

  _chatRow() =>  ListTile(
    contentPadding: const EdgeInsets.only(left: 16.0),
    leading: const HomeProfileImage(imageUrl: 'https://i.imgur.com/ZD73Ov7.jpg',userOnline: true,),
    title: Text('jayasith',
    style: Theme.of(context).textTheme.subtitle2.copyWith(
      fontWeight: FontWeight.bold,
      color: isLightTheme(context) ? Colors.black : Colors.white)),
    subtitle: Text('Thank you',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: Theme.of(context).textTheme.caption.copyWith(
            color: isLightTheme(context) ? Colors.black54 : Colors.white70)
    ),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            '10AM',
            style: Theme.of(context).textTheme.caption.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              height: 15.0,
              width: 15.0,
              color: primary,
              alignment: Alignment.center,
              child:Text(
                '2',
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
