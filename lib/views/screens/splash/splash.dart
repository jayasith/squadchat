import 'package:flutter/material.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/screens/intro/intro.dart';

class Splash extends StatefulWidget {
  const Splash();

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    this._NavigateToIntro();
    super.initState();
  }

  _NavigateToIntro() async {
    await Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Intro()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/logo.png")),
          SizedBox(height: 50),
          Text(
            'Squadchat',
            style: Theme.of(context).textTheme.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            "Freedom to talk with anyone.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: isLightTheme(context)
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5)),
          )
        ],
      ),
    );
  }
}
