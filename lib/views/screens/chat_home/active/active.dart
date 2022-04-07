import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/home/home_state.dart';
import 'package:squadchat/views/screens/chat_home/home_router_contract.dart';

import '../../../../theme.dart';
import '../../../widgets/chat_home/home_profile_image.dart';

class Active extends StatefulWidget {
  final User user;
  final IHomeRouter homeRouter;

  Active(this.homeRouter, this.user);

  @override
  _ActiveState createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      if (state is HomeLoading)
        return Center(child: CircularProgressIndicator());
      if (state is HomeSuccess) {
        if (state.onlineUsers.isEmpty)
          return Center(child: Text('No active users found'));
        return _buildActiveUserList(state.onlineUsers);
      }
    });
  }

  _activeRow(User user) => ListTile(
        leading: HomeProfileImage(
          imageUrl: user.photoUrl,
          userOnline: true,
        ),
        title: Text(user.username,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white)),
      );

  _buildActiveUserList(List<User> users) => ListView.separated(
      padding: const EdgeInsets.only(top: 10.0, right: 16.0),
      itemBuilder: (BuildContext context, index) => GestureDetector(
            child: _activeRow(users[index]),
            onTap: () => this.widget.homeRouter.onShowMessageThread(
                context, users[index], widget.user,
                chatId: users[index].id),
          ),
      separatorBuilder: (_, __) => Divider(
            color: isLightTheme(context) ? Colors.white : Colors.black,
            height: 0.0,
            endIndent: 30.0,
          ),
      itemCount: users.length);
}
