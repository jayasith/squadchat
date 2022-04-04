import 'dart:async';

import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/models/local_message.dart';
import 'package:squadchat/states/home/chat_bloc.dart';
import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/states/message_thread/message_thread_cubit.dart';
import 'package:squadchat/states/receipt/receipt_bloc.dart';
import 'package:squadchat/states/typing/typing_notification_bloc.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/widgets/common/header_status.dart';

class MessageThread extends StatefulWidget {
  final User receiver;
  final User user;
  final String chatId;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatBloc chatBloc;

  MessageThread(this.receiver, this.user, this.messageBloc, this.chatBloc,
      this.typingNotificationBloc,
      {String chatId = ''})
      : this.chatId = chatId;

  @override
  State<MessageThread> createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  String chatId = '';
  User receiver;
  StreamSubscription _subscription;
  List<LocalMessage> messages = [];
  Timer _startTypingTimer;
  Timer _stopTypingTimer;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    receiver = widget.receiver;
    _updateOnMessageReceived();
    _updateOnReceiptReceived();
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.user));
    widget.typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(
        widget.user,
        usersWithChat: [receiver.id]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: isLightTheme(context) ? Colors.black : Colors.white,
                )),
            Expanded(
                child: HeaderStatus(
              receiver.username,
              receiver.photoUrl,
              receiver.active,
              lastseen: receiver.lastseen,
            ))
          ],
        ),
      ),
      body: Container(),
    );
  }

  void _updateOnReceiptReceived() {
    final meassageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) meassageThreadCubit.messages(chatId);
    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await meassageThreadCubit.viewModel.receivedMessage(state.message);

        final receipt = Receipt(
            recipient: state.message.from,
            messageId: state.message.id,
            status: ReceiptStatus.read,
            timestamp: DateTime.now());

        context.read<ReceiptBloc>().add(ReceiptEvent.onMessageSent(receipt));
      }

      if (state is MessageSentSuccess) {
        await meassageThreadCubit.viewModel.sentMessage(state.message);
      }

      if (chatId.isEmpty) chatId = meassageThreadCubit.viewModel.chatId;
      meassageThreadCubit.messages(chatId);
    });
  }

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.viewModel.updateMessageReceipt(state.receipt);
        messageThreadCubit.messages(chatId);
        widget.chatBloc.chats();
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _subscription?.cancel();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();
    super.dispose();
  }
}
