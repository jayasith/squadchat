import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../cache/local_cache_service.dart';
import '../../../../../colors.dart';
import '../../../../../composition_root.dart';
import '../../../../../data/data_sources/data_source_contract.dart';
import '../../../../../models/chat.dart';
import '../../../../../theme.dart';
import '../../../../widgets/chat_home/home_profile_image.dart';
import '../../../../widgets/common/custom_confirmation_dialog.dart';

class GroupChatProfile extends StatefulWidget {
  final Chat chat;
  final List<User> receivers;


  const GroupChatProfile(this.chat, this.receivers);

  @override
  _GroupChatProfileState createState() => _GroupChatProfileState();
}

class _GroupChatProfileState extends State<GroupChatProfile> {
  IDataSource iDataSource;
  LocalCache localCache;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.group_rounded,
                size: 75,
                color: primary,
              ),
            ),
               Text(
                '${widget.chat.name}',
                style: Theme.of(context).textTheme.headlineLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 250.0),
              child: Text(
                'Members',
                style: Theme.of(context).textTheme.headlineLarge.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
              ),
            ),
            SizedBox(
              height: 400,
              child:  _buildMemberListView(),
            ),
             // _deleteGroup(),
          ],
        ),
      ),
    );
  }

  _buildMemberListView() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 10.0, right: 16.0),
        itemBuilder: (_, index) => GestureDetector(
              child: _memberRow(widget.receivers[index]),
            ),
        separatorBuilder: (_, __) => Divider(
              color: isLightTheme(context) ? Colors.white : Colors.black,
              height: 0.0,
              endIndent: 30.0,
            ),
        itemCount: widget.receivers.length);
  }

  _memberRow(User user) => ListTile(
        leading: HomeProfileImage(
          imageUrl: user.photoUrl,
          userOnline: true,
        ),
        title: Text(
            user.username,
            style: Theme.of(context).textTheme.caption.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: isLightTheme(context) ? Colors.black : Colors.white)
        ),
      );

}
