import 'package:flutter/material.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/theme.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String val) onchanged;
  final double height;
  final TextInputAction inputAction;

  const CustomTextField({
    this.hint,
    this.height = 54.0,
    this.onchanged,
    this.inputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onchanged,
        textInputAction: inputAction,
        cursorColor: primary,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
          color: isLightTheme(context) ? Colors.white : bubbleDark,
          borderRadius: BorderRadius.circular(45.0),
          border: Border.all(
            color: isLightTheme(context)
                ? const Color(0xFFC4C4C4)
                : const Color(0xFF393737),
            width: 1.5,
          )),
    );
  }
}
