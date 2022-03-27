import 'package:flutter/material.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/screens/login.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Squadchat',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: const Login(),
    );
  }
}
