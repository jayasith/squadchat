import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/home/home_state.dart';
import 'package:squadchat/views/screens/chat_home/active/active.dart';
import 'package:squadchat/views/screens/chat_home/chats/chat.dart';
import 'package:squadchat/views/widgets/chat_home/home_profile_image.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().activeUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Container(
                  width: double.maxFinite,
                  child: Row(children: [
                    const HomeProfileImage(
                      imageUrl: "https://i.imgur.com/ZD73Ov7.jpg",
                      userOnline: true,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Chamindu',
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
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
          body: const TabBarView(
            children: [Chat(), Active()],
          )),
    );
  }
}
