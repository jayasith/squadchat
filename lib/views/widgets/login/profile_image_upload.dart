import 'package:flutter/material.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/theme.dart';

class ProfileImageUpload extends StatelessWidget {
  const ProfileImageUpload();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 50,
                  color: isLightTheme(context) ? iconLight : activeUsersDark,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: const Padding(
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
          onTap: () {},
        ),
      ),
    );
  }
}
