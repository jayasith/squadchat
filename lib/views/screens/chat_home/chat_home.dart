import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/states/group/group_bloc.dart';
import 'package:squadchat/states/home/chat_bloc.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/home/home_state.dart';
import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/view_models/chats_view_model.dart';
import 'package:squadchat/views/screens/chat_home/active/active.dart';
import 'package:squadchat/views/screens/chat_home/chats/chat.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';
import 'package:squadchat/views/widgets/common/header_status.dart';

import '../../../cache/local_cache_service.dart';
import '../user_profile/user_profile.dart';

class Home extends StatefulWidget {
  final User user;
  final IHomeRouter router;
  final ChatsViewModel chatsViewModel;

  const Home(this.chatsViewModel, this.router, this.user);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User _user;
  List<User> _actives = [];

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
            title:InkWell(
                onTap: () async {
                  final sharedPreferences = await SharedPreferences.getInstance();
                  var localCache = LocalCache(sharedPreferences);
                  final currentUser = localCache.fetch('USER');
                  if (widget.user.username == User.fromJson(currentUser).username) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const UserProfile()));
                  }
                },
                child:  HeaderStatus(_user.username, _user.photoUrl, _user.active)
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
                      child:
                          BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
                        if (state is HomeSuccess) {
                          _actives = state.onlineUsers;
                          return Text("Active(${state.onlineUsers.length})");
                        }
                        return const Text("Active(0)");
                      }),
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          child: Icon(
            Icons.group_add_rounded,
            color: Colors.white,
          ),
          onPressed: () async {
            await widget.router.onShowGroupCreation(context, _actives, _user);
          },
        ),
      ),
    );
  }

  _initialSetup() async {
    final user =
        (!_user.active ? await context.read<HomeBloc>().connect() : _user);
    context.read<HomeBloc>().activeUsers(user);
    context.read<ChatBloc>().chats();
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
    context.read<GroupBloc>().add(GroupEvent.onSubscribed(user));
  }

  @override
  bool get wantKeepAlive => true;
}
