import 'package:flutter/material.dart';
import 'package:squadchat/composition_root.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/screens/chat_home/chat_home.dart';
import 'package:squadchat/views/screens/intro/intro.dart';
import 'package:squadchat/views/screens/login/login.dart';
import 'package:squadchat/views/screens/user_profile/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final firstPage = Intro();
  runApp(App(firstPage));
}

class App extends StatefulWidget {
  final Widget firstPage;

  App(this.firstPage);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isNotActive = state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached;
    final isResumed = state == AppLifecycleState.resumed;

    if (isNotActive) CompositionRoot.disconnectUser();
    if (isResumed) CompositionRoot.reconnectUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Squadchat',
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        home: widget.firstPage);
  }
}
