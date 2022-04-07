import 'package:flutter/material.dart';

class OthersStatus extends StatelessWidget {
  const OthersStatus({Key key, this.image, this.name, this.time})
      : super(key: key);
  final String name;
  final String time;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 26,
        backgroundColor: Colors.green,
        // backgroundImage: (image),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        "Today at, $time",
        style: TextStyle(fontSize: 14, color: Colors.grey[900]),
      ),
    );
  }
}
