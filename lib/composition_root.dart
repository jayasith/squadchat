import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:squadchat/cache/local_cache_contract.dart';
import 'package:squadchat/cache/local_cache_service.dart';
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
import 'package:squadchat/views/screens/login/login_router.dart';
import 'package:squadchat/views/screens/login/login_router_contract.dart';

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
  static ILocalCache _localCache;
  static MessageBloc _messageBloc;

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
    final sharedPreferences = await SharedPreferences.getInstance();
    _localCache = LocalCache(sharedPreferences);
    _messageBloc = MessageBloc(_messageService);
  }

  static Widget start() {
    final user = _localCache.fetch('USER');
    return user.isEmpty
        ? composeLoginUi()
        : composeChatHomeUi(User.fromJson(user));
  }

  static Widget composeLoginUi() {
    ImageUploaderService imageUploader =
        ImageUploaderService('http://${UrlConfig().ip}:3000/upload');

    LoginCubit loginCubit =
        LoginCubit(_userService, imageUploader, _localCache);
    ProfileImageCubit imageCubit = ProfileImageCubit();
    ILoginRouter loginRouter = LoginRouter(composeChatHomeUi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => loginCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: Login(loginRouter),
    );
  }

  static Widget composeChatHomeUi(User user) {
    HomeBloc homeBloc = HomeBloc(_userService, _localCache);
    ChatsViewModel chatsViewModel = ChatsViewModel(_iDataSource, _userService);
    ChatBloc chatBloc = ChatBloc(chatsViewModel);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => homeBloc),
      BlocProvider(create: (BuildContext context) => _messageBloc),
      BlocProvider(create: (BuildContext context) => chatBloc)
    ], child: Home(user));
  }

  static void deleteUser(String userId) async {
    await _userService.deleteUser(userId);
  }
}
