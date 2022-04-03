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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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

    if (isNotActive) print('disconnecting user');
    if (isResumed) print('reconnecting user');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Squadchat',
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        home: CompositionRoot.composeChatHomeUi());
  }
}
