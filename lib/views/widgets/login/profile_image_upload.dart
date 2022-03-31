import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/states/login/profile_image_cubit.dart';
import 'package:squadchat/theme.dart';

class ProfileImageUpload extends StatelessWidget {
  const ProfileImageUpload();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      width: 126,
      child: Material(
        color: isLightTheme(context) ? Colors.grey[200] : Colors.grey[900],
        borderRadius: BorderRadius.circular(126),
        child: InkWell(
          borderRadius: BorderRadius.circular(126),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: BlocBuilder<ProfileImageCubit, File>(
                      builder: (context, state) {
                    return state == null
                        ? Icon(
                            Icons.person_outline_rounded,
                            size: 50,
                            color: isLightTheme(context)
                                ? iconLight
                                : activeUsersDark,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(126),
                            child: Image.file(state,
                                width: 126, height: 126, fit: BoxFit.cover));
                  })),
              const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.add_circle_rounded,
                    size: 30,
                    color: primary,
                  ),
                ),
              )
            ],
          ),
          onTap: () async {
            await context.read<ProfileImageCubit>().getProfileImage();
          },
        ),
      ),
    );
  }
}
