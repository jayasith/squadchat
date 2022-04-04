import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../colors.dart';
import '../../../../models/chat.dart';
import '../../../../states/home/chat_bloc.dart';
import '../../../widgets/chat_home/home_profile_image.dart';

class Chats extends StatefulWidget {
  const Chats();

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var chats = [];

  @override
  void initState() {
    super.initState();
    _updateChatMessage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, List<Chat>>(builder: (_, chats) {
      this.chats = chats;
      return _buildChatListView();
    });
  }

  _buildChatListView() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 10.0, right: 16.0),
        itemBuilder: (_, index) => _chatRow(chats[index]),
        separatorBuilder: (_, __) => Divider(
              color: isLightTheme(context) ? Colors.white : Colors.black,
              height: 0.0,
              endIndent: 30.0,
            ),
        itemCount: chats.length);
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
        subtitle: Text(chat.mostRecent.message.contents,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
            style: Theme.of(context).textTheme.caption.copyWith(
                color:
                    isLightTheme(context) ? Colors.black54 : Colors.white70)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                DateFormat('h:mm: a').format(chat.mostRecent.message.timestamp),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                    fontWeight:
                        chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
              ),
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
                    : Container(),
              ),
            )
          ],
        ),
      );

  _updateChatMessage() {
    final chatBloc = context.read<ChatBloc>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatBloc.chatsViewModel.receivedMessage(state.message);
        chatBloc.chats();
      }
    });
  }
}
