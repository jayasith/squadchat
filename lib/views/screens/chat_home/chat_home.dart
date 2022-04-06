import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/states/home/chat_bloc.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/home/home_state.dart';
import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/views/screens/chat_home/active/active.dart';
import 'package:squadchat/views/screens/chat_home/chats/chat.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';
import 'package:squadchat/views/widgets/common/header_status.dart';

class Home extends StatefulWidget {
  final User user;
  final IHomeRouter router;

  const Home(this.user, this.router);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _initialSetup();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: HeaderStatus(_user.username, _user.photoUrl, _user.active),
              bottom: TabBar(
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  tabs: [
                    Tab(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text('Chats'),
                      ),
                    )),
                    Tab(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (_, state) => state is HomeSuccess
                                ? Text('Active(${state.onlineUsers.length})')
                                : const Text('Active(0)')),
                      ),
                    ))
                  ])),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TabBarView(
              children: [
                Chats(_user, widget.router),
                Active(widget.router, _user)
              ],
            ),
          )),
    );
  }

  _initialSetup() async {
    final user =
        (!_user.active ? await context.read<HomeBloc>().connect() : _user);
    context.read<HomeBloc>().activeUsers(user);
    context.read<ChatBloc>().chats();
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  bool get wantKeepAlive => true;
}
