import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:squadchat/config/url_config.dart';
import 'package:squadchat/data/services/image_uploader_service.dart';
import 'package:squadchat/states/home/chat_bloc.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/login/login_cubit.dart';
import 'package:squadchat/states/login/profile_image_cubit.dart';
import 'package:squadchat/states/message/message_bloc.dart';
import 'package:squadchat/view_models/chats_view_model.dart';
import 'package:squadchat/views/screens/chat_home/chat_home.dart';
import 'package:squadchat/views/screens/login/login.dart';

import 'data/data_sources/data_source.dart';
import 'data/data_sources/data_source_contract.dart';
import 'data/factories/db_factory.dart';

class CompositionRoot {
  static Rethinkdb _rethinkdb;
  static Connection _connection;
  static IUserService _userService;
  static Database _localDb;
  static IMessageService _messageService;
  static IDataSource _iDataSource;

  static configure() async {
    _rethinkdb = Rethinkdb();
    _connection = await _rethinkdb.connect(host: UrlConfig().host, port: 28015);
    _userService = UserService(_rethinkdb, _connection);
    _localDb = await LocalDatabase().createDatabase();
    _messageService = MessageService(
      _rethinkdb,
      _connection,
    );
    _iDataSource = DataSource(_localDb);
  }

  static Widget composeLoginUi() {
    ImageUploaderService imageUploader =
        ImageUploaderService('http://${UrlConfig().ip}:3000/upload');

    LoginCubit loginCubit = LoginCubit(_userService, imageUploader);
    ProfileImageCubit imageCubit = ProfileImageCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => loginCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: const Login(),
    );
  }

  static Widget composeChatHomeUi() {
    HomeBloc homeBloc = HomeBloc(_userService);
    MessageBloc messageBloc = MessageBloc(_messageService);
    ChatsViewModel chatsViewModel = ChatsViewModel(_iDataSource, _userService);
    ChatBloc chatBloc = ChatBloc(chatsViewModel);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => homeBloc),
      BlocProvider(create: (BuildContext context) => messageBloc),
      BlocProvider(create: (BuildContext context) => chatBloc)
    ], child: const Home());
  }

  static void deleteUser(String userId) async {
    await _userService.deleteUser(userId);
  }

  static void disconnectUser(User user) async {
    return print('disconnecting user');
    await _userService.disconnect(user);
  }

  static void reconnectUser(User user) async {
    return print('disconnecting user');
    await _userService.disconnect(user);
  }
}
