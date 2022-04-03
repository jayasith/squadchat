import 'package:flutter/material.dart';
import 'package:squadchat/composition_root.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/screens/chat_home/chat_home.dart';
import 'package:squadchat/views/screens/intro/intro.dart';
import 'package:squadchat/views/screens/login/login.dart';
import 'views/screens/user_profile/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final firstPage = Intro();
  runApp(App(firstPage));
}

class App extends StatelessWidget {
  final Widget firstPage;

  App(this.firstPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Squadchat',
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        home: firstPage);
  }
}
