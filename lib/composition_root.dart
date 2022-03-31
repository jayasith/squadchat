import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:squadchat/config/url_config.dart';
import 'package:squadchat/data/services/image_uploader_service.dart';
import 'package:squadchat/states/home/home_bloc.dart';
import 'package:squadchat/states/login/login_cubit.dart';
import 'package:squadchat/states/login/profile_image_cubit.dart';
import 'package:squadchat/views/screens/chat_home/chat_home.dart';
import 'package:squadchat/views/screens/login/login.dart';

class CompositionRoot {
  static Rethinkdb _rethinkdb;
  static Connection _connection;
  static IUserService _userService;

  static configure() async {
    _rethinkdb = Rethinkdb();
    _connection = await _rethinkdb.connect(host: UrlConfig().host, port: 28015);
    _userService = UserService(_rethinkdb, _connection);
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

    return MultiBlocProvider(
        providers: [BlocProvider(create: (BuildContext context) => homeBloc)],
        child: const Home());
  }
}
