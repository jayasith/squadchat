import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/states/typing/typing_notification_bloc.dart';
import 'package:squadchat/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/views/screens/chat_home/chat_home.dart';
import 'package:squadchat/views/screens/chat_home/home_router.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';
import 'package:squadchat/views/widgets/common/custom_confirmation_dialog.dart';

import '../../../../colors.dart';
import '../../../../models/chat.dart';
import '../../../../states/group/group_bloc.dart';
import '../../../../states/home/chat_bloc.dart';
import '../../../../utils/color_generator.dart';
import '../../../widgets/chat_home/home_profile_image.dart';

class Chats extends StatefulWidget {
  final User user;
  final IHomeRouter homeRouter;

  const Chats(this.user, this.homeRouter);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var chats = [];
  final typingEvents = [];
  var deletePop = false;
  var dataLoad = false;
  var chatId;

  @override
  void initState() {
    super.initState();
    _updateChatMessage();
    context.read<ChatBloc>().chats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, List<Chat>>(builder: (_, chats) {
      this.chats = chats;
      if (this.chats.isEmpty) return Container();
      List<String> userIds = [];
      chats.forEach((chat) {
        userIds += chat.members.map((e) => e.id).toList();
      });
      context.read<TypingNotificationBloc>().add(
          TypingNotificationEvent.onSubscribed(widget.user,
              usersWithChat: userIds.toSet().toList()));
      return _buildChatListView();
    });
  }

  _buildChatListView() {
    return GestureDetector(
      onTap: () {
        chats.forEach((element) {
          element.deleted = false;
          print(element.deleted);
        });
      },
      child: ListView.separated(
          padding: const EdgeInsets.only(top: 10.0, right: 16.0),
          itemBuilder: (_, index) => GestureDetector(
                onLongPress: () {
                  setState(() {
                    chats[index].deleted = true;
                  });
                  chatId = chats[index].id;
                },
                child: _chatRow(chats[index]),
                onTap: () async {
                  setState(() {
                    chats[index].deleted = false;
                  });
                  await this.widget.homeRouter.onShowMessageThread(
                      context, chats[index].members, widget.user,
                      chats[index]);
                },
              ),
          separatorBuilder: (_, __) => Divider(
                color: isLightTheme(context) ? Colors.white : Colors.black,
                height: 0.0,
                endIndent: 30.0,
              ),
          itemCount: chats.length),
    );
  }

  _chatRow(Chat chat) => ListTile(
        contentPadding: const EdgeInsets.only(left: 16.0),
        leading: HomeProfileImage(
          imageUrl: chat.type == ChatType.individual
              ? chat.members.first.photoUrl
              : null,
          userOnline: chat.type == ChatType.individual
              ? chat.members.first.active
              : false,
        ),
        title: Text(
            chat.type == ChatType.individual
                ? chat.members.first.username
                : chat.name,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white)),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
            builder: (_, state) {
          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.from == chat.id) {
            this.typingEvents.add(state.event.chatId);
          }

          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.from == chat.id) {
            this.typingEvents.add(state.event.chatId);
          }

          if (this.typingEvents.contains(chat.id)) {
            switch (chat.type) {
              case ChatType.group:
                final st = state as TypingNotificationReceivedSuccess;
                final username = chat.members
                    .firstWhere((element) => element.id == st.event.from)
                    .username;

                return Text(
                  '$username is typing ...',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontStyle: FontStyle.italic),
                );
                break;
              default:
                return Text(
                  'Typing ...',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontStyle: FontStyle.italic),
                );
            }
          }

          return Text(
              chat.mostRecent != null
                  ? chat.type == ChatType.individual
                      ? chat.mostRecent.message.contents
                      : (chat.members
                                  .firstWhere(
                                      (element) =>
                                          element.id ==
                                          chat.mostRecent.message.from,
                                      orElse: () => null)
                                  ?.username ??
                              'You') +
                          ': ' +
                          chat.mostRecent.message.contents
                  : 'Group created',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: Theme.of(context).textTheme.caption.copyWith(
                  color:
                      isLightTheme(context) ? Colors.black54 : Colors.white70));
        }),

        trailing: chat.deleted
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                    child: IconButton(
                      onPressed: () async {
                        var alert = CustomConfirmationDialog(
                          title: 'Delete Chat',
                          content: 'Do you want to delete this chat?',
                          okFunction: _delete_chat,
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => alert);
                        context.read<ChatBloc>().chats();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: isLightTheme(context) ? primary : Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: chat.mostRecent != null ? Text(
                      DateFormat('h:mm: a')
                          .format(chat.mostRecent.message.timestamp),
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: isLightTheme(context)
                              ? Colors.black54
                              : Colors.white70,
                          fontWeight: chat.unread > 0
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ):Text(' ') ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: chat.unread > 0
                          ? Container(
                              height: 15.0,
                              width: 15.0,
                              color: primary,
                              alignment: Alignment.center,
                              child: Text(
                                '2',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: Colors.white),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  )
                ],
              ),
      );

  _delete_chat() async {
    chats.removeWhere((element) => element.id == chatId);
    final chatBloc = context.read<ChatBloc>();
    await chatBloc.chatsViewModel.deleteChat(chatId);
    context.read<ChatBloc>().chats();
    Navigator.pop(context);
  }

  _updateChatMessage() {
    final chatsBloc = context.read<ChatBloc>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsBloc.chatsViewModel.receivedMessage(state.message);
        chatsBloc.chats();
      }
    });

    context.read<GroupBloc>().stream.listen((event) async {
      if (event is GroupReceivedSuccess) {
        final group = event.group;
        group.members.removeWhere((element) => element == widget.user.id);
        final memberId = group.members
            .map((e) => {e: ColorGenerator.getColor().value.toString()})
            .toList();
        final chat = Chat(group.id, ChatType.group,
            name: group.name, membersId: memberId);
        await chatsBloc.chatsViewModel.createNewChat(chat);
        chatsBloc.chats();
      }
    });
  }
}
