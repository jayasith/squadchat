import 'package:flutter/material.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/screens/login/login.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/images/intro.png"),
            const Spacer(flex: 3),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Welcome to",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Image.asset(
                  'assets/images/logo.png',
                  scale: 5,
                ),
              ),
              Text(
                "Squadchat",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
              ),
            ]),
            const Spacer(),
            Text(
              "Freedom to talk with anyone.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: isLightTheme(context)
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5)),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Login()));
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 24,
                ),
                style: ElevatedButton.styleFrom(
                    primary: primary,
                    fixedSize: const Size(60, 60),
                    shape: const CircleBorder(),
                    elevation: 0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
