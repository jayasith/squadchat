import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/states/typing/typing_notification_bloc.dart';
import 'package:squadchat/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/views/screens/chat_home/home_router.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';

import '../../../../colors.dart';
import '../../../../models/chat.dart';
import '../../../../states/home/chat_bloc.dart';
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
      if (this.chats.isEmpty)
        return Center(child: Text('No previous conversations found'));
      context.read<TypingNotificationBloc>().add(
          TypingNotificationEvent.onSubscribed(widget.user,
              usersWithChat: chats.map((e) => e.from.id).toList()));
      return _buildChatListView();
    });
  }

  _buildChatListView() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 10.0, right: 16.0),
        itemBuilder: (_, index) => GestureDetector(
              child: _chatRow(chats[index]),
              onTap: () async {
                await this.widget.homeRouter.onShowMessageThread(
                    context, chats[index].from, widget.user,
                    chatId: chats[index].id);
              },
            ),
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
          imageUrl: chat.from.photoUrl,
          userOnline: chat.from.active,
        ),
        title: Text(chat.from.username,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white)),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
            builder: (_, state) {
          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.from == chat.from.id)
            this.typingEvents.add(state.event.from);

          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.from == chat.from.id)
            this.typingEvents.add(state.event.to);

          if (this.typingEvents.contains(chat.from.id))
            return Text('Typing ...',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontStyle: FontStyle.italic));

          return Text(chat.mostRecent.message.contents,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: Theme.of(context).textTheme.caption.copyWith(
                  color:
                      isLightTheme(context) ? Colors.black54 : Colors.white70));
        }),
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
                    : SizedBox.shrink(),
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
