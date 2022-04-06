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
                size: 100,
                color: primary,
              ),
            ),
               Text(
                '${widget.chat.name}',
                style: Theme.of(context).textTheme.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 250.0),
              child: Text(
                'Members',
                style: Theme.of(context).textTheme.titleSmall.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 22,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
              ),
            ),
            SizedBox(
              height: 400,
              child:  _buildMemberListView(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  var alert = CustomConfirmationDialog(
                    title: 'Delete Group Chat',
                    content: 'Do you want to delete this group chat ?',
                    okFunction: _confirmationOk,
                  );

                  showDialog(
                      context: context,
                      builder: (BuildContext context) => alert);
                },
                child: const Icon(Icons.delete_forever),
                style: ElevatedButton.styleFrom(
                    primary: primary,
                    fixedSize: const Size(60, 60),
                    shape: const CircleBorder(),
                    elevation: 0),
              ),
            ),
             // _deleteGroup(),
          ],
        ),
      ),
    );
  }

  _confirmationOk() async {
    await iDataSource.deleteChat(widget.chat.id);
    final sharedPreferences = await SharedPreferences.getInstance();
    localCache = LocalCache(sharedPreferences);
    final currentUser = localCache.fetch('USER');
    User user = User.fromJson(currentUser);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CompositionRoot.composeChatHomeUi(user)));
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
        title: Text(user.username),
      );

  _deleteGroup(){

  }
}
