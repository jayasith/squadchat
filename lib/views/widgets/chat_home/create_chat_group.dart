import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/models/chat.dart';
import 'package:squadchat/states/group/group_bloc.dart';
import 'package:squadchat/states/home/chat_bloc.dart';
import 'package:squadchat/states/home/group_chat_bloc.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/utils/color_generator.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';
import 'package:squadchat/views/widgets/common/custom_text_field.dart';

import 'home_profile_image.dart';

class CreateChatGroup extends StatefulWidget {
  final List<User> _actives;
  final User _user;
  final ChatBloc _chatBloc;
  final IHomeRouter _homeRouter;

  const CreateChatGroup(
      this._actives, this._user, this._chatBloc, this._homeRouter);

  @override
  _CreateChatGroupState createState() => _CreateChatGroupState();
}

class _CreateChatGroupState extends State<CreateChatGroup> {
  List<User> selectedUsers = [];
  ChatBloc _chatBloc;
  GroupBloc _groupBloc;
  GroupChatBloc _groupChatBloc;
  String _groupName = '';

  @override
  void initState() {
    _groupChatBloc = context.read<GroupChatBloc>();
    _chatBloc = widget._chatBloc;
    _groupBloc = context.read<GroupBloc>();

    _groupBloc.stream.listen((event) async {
      if (event is GroupCreatedSuccess) {
        event.group.members
            .removeWhere((element) => element == widget._user.id);
        final memberId = event.group.members
            .map((e) => {e: ColorGenerator.getColor().value.toString()})
            .toList();
        final chat = Chat(event.group.id, ChatType.group,
            membersId: memberId, name: _groupName);
        await _chatBloc.chatsViewModel.createNewChat(chat);
        final chats = await _chatBloc.chatsViewModel.getChats();
        final receivers =
            chats.firstWhere((chat) => chat.id == event.group.id).members;
        await _chatBloc.chats();
        Navigator.of(context).pop();
        widget._homeRouter
            .onShowMessageThread(context, receivers, widget._user, chat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupChatBloc, List<User>>(
        bloc: _groupChatBloc,
        builder: (_, state) {
          selectedUsers = state;
          return SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(selectedUsers.length > 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: CustomTextField(
                    height: 43,
                    hint: 'Group Name',
                    inputAction: TextInputAction.done,
                    onchanged: (val) {
                      _groupName = val;
                    },
                  ),
                ),
                state.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: 65,
                        child: ListView.builder(
                          itemBuilder: (__, index) =>
                              _selectedUserListItem(selectedUsers[index]),
                          itemCount: selectedUsers.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                Expanded(child: _buildList(widget._actives))
              ],
            ),
          );
        },
      ),
    );
  }

  _header(bool buttonEnable) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              TextButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        Theme.of(context).textTheme.caption)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                ),
              ),
              Center(
                child: Text(
                  'New Group',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        Theme.of(context).textTheme.caption)),
                onPressed: buttonEnable
                    ? () {
                        if (_groupName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Enter Group Name'),
                            ),
                          );
                          return;
                        }
                        _createGroup();
                      }
                    : null,
                child: const Text(
                  'Create',
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      );

  _selectedUserListItem(User user) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () => _groupChatBloc.remove(user),
          child: SizedBox(
            width: 40,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundColor: iconLight,
                    radius: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        user.photoUrl,
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLightTheme(context)
                              ? Colors.black54
                              : appBarDark),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 12.0,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    user.username.split(' ').first,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
      padding: const EdgeInsets.only(top: 20, right: 2),
      itemBuilder: (BuildContext context, index) => GestureDetector(
            child: _listItem(users[index]),
            onTap: () {
              if (selectedUsers.any((e) => e.id == users[index].id)) {
                _groupChatBloc.remove(users[index]);
                return;
              }
              _groupChatBloc.add(users[index]);
            },
          ),
      separatorBuilder: (_, __) => Divider(
        color: isLightTheme(context) ? Colors.white : Colors.black,
        height: 0.0,
        endIndent: 30.0,
          ),
      itemCount: users.length);

  _listItem(User user) => ListTile(
        leading: HomeProfileImage(
          imageUrl: user.photoUrl,
          userOnline: true,
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.caption.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        trailing: _checkBox(
          size: 20.0,
          isChecked: selectedUsers.any((e) => e.id == user.id),
        ),
      );

  _checkBox({@required double size, @required bool isChecked}) => ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: AnimatedContainer(
          duration: const Duration(microseconds: 500),
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: isChecked ? primary : Colors.transparent,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      );

  void _createGroup() {
    GroupMessage groupMessage = GroupMessage(
        createdBy: widget._user.id,
        name: _groupName,
        members: selectedUsers.map<String>((e) => e.id).toList() +
            [widget._user.id]);
    final event = GroupEvent.onGroupCreated(groupMessage);
    _groupBloc.add(event);
  }
}
