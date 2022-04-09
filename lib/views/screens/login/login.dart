import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/states/login/login_cubit.dart';
import 'package:squadchat/states/login/login_state.dart';
import 'package:squadchat/states/login/profile_image_cubit.dart';
import 'package:squadchat/views/widgets/common/custom_text_field.dart';
import 'package:squadchat/views/widgets/login/logo.dart';
import 'package:squadchat/views/widgets/login/profile_image_upload.dart';
import 'package:squadchat/views/screens/login/login_router_contract.dart';

class Login extends StatefulWidget {
  final ILoginRouter loginRouter;

  Login(this.loginRouter);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  _logo(context),
                  const SizedBox(
                    height: 100,
                  ),
                  const Center(child: ProfileImageUpload()),
                  const SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: CustomTextField(
                      hint: 'What is your name?',
                      height: 45,
                      onchanged: (val) {
                        _name = val;
                      },
                      inputAction: TextInputAction.done,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () async {
                        final error = _validateInputs();

                        if (error.isNotEmpty) {
                          final snackBar = SnackBar(
                              content: Text(
                            error,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        await _connectSession();
                      },
                      child: BlocConsumer<LoginCubit, LoginState>(
                          builder: (context, state) => state is Loading
                              ? const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                                )
                              : Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Let's Connect",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )),
                          listener: (_, state) {
                            if (state is LoginSuccess) {
                              widget.loginRouter
                                  .onSessionSuccess(context, state.user);
                            }
                          }),
                      style: ElevatedButton.styleFrom(
                          primary: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45))),
                    ),
                  ),
                ],
              ),
            ),
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

  String _validateInputs() {
    String error = '';

    if (_name.isEmpty) {
      error = 'Please enter your name';
    }

    if (context.read<ProfileImageCubit>().state == null) {
      error = error + '\nPlease select a profile image';
    }

    return error;
  }

  void _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<LoginCubit>().connect(_name, profileImage);
  }
}
