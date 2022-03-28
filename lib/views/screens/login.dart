import 'package:flutter/material.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/views/widgets/common/custom_text_field.dart';
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
            const ProfileImageUpload(),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomTextField(
                hint: 'What is your name?',
                height: 45,
                onchanged: (val) {},
                inputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: const Text(
                      "Let's Connect",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                style: ElevatedButton.styleFrom(
                    primary: primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45))),
              ),
            ),
            const Spacer(flex: 1),
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
