import 'package:flutter/material.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function okFunction;

  const CustomConfirmationDialog(
      {Key key, this.title, this.content, this.okFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
        TextButton(onPressed: okFunction, child: const Text('OK'))
      ],
    );
  }
}
