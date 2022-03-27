import 'package:flutter/material.dart';
import 'package:squadchat/views/widgets/login/logo.dart';
import 'package:squadchat/views/widgets/login/profile_image_upload.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logo(context),
            const Spacer(),
            const ProfileImageUpload()
          ],
        ),
      ),
    );
  }

  Widget _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Logo(),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          'Squadchat',
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
