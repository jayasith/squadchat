import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../../../widgets/chat_home/home_profile_image.dart';

class Active extends StatefulWidget {
  const Active();

  @override
  _ActiveState createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 10.0, right: 16.0),
        itemBuilder: (_, index) => _activeRow(),
        separatorBuilder: (_, __) => Divider(
              color: isLightTheme(context) ? Colors.white : Colors.black,
              height: 0.0,
              endIndent: 30.0,
            ),
        itemCount: 5);
  }

  _activeRow() => ListTile(
        leading: HomeProfileImage(
          imageUrl: 'https://i.imgur.com/ZD73Ov7.jpg',
          userOnline: true,
        ),
        title: Text('jayasith',
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white)),
      );
}
