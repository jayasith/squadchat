import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/states/home/chat_bloc.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/home/home_state.dart';
import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/views/screens/chat_home/active/active.dart';
import 'package:squadchat/views/screens/chat_home/chats/chat.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';
import 'package:squadchat/views/screens/user_profile/user_profile.dart';
import 'package:squadchat/views/widgets/chat_home/home_profile_image.dart';

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
              title: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserProfile())),
                child: Container(
                    width: double.maxFinite,
                    child: Row(children: [
                      HomeProfileImage(
                        imageUrl: _user.photoUrl,
                        userOnline: true,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(_user.username,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('online',
                                style: Theme.of(context).textTheme.caption),
                          )
                        ],
                      )
                    ])),
              ),
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
            padding: EdgeInsets.symmetric(horizontal: 6.0),
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
