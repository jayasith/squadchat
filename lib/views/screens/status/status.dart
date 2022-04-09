import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:squadchat/views/screens/status/othersStatus.dart';


class StatusScreen extends StatefulWidget {
  const StatusScreen();

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<StatusScreen> {
  File _imageFile;
  String _filePath;
  final picker = ImagePicker();

  Future pickImageC() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(_filePath);
      _filePath = pickedFile.path;
      print(_filePath);
    });
  }

  Future pickImageG() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(_filePath);
      _filePath = pickedFile.path;
      print(_filePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status')),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              elevation: 8,
              onPressed: () async {
                pickImageG();
              },
              child: Icon(
                Icons.image,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          FloatingActionButton(
            onPressed: () async {
              pickImageC();
            },
            backgroundColor: Colors.blueAccent[700],
            elevation: 5,
            child: const Icon(Icons.camera_alt),
          )
        ],

      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox()
              ListTile(
                  leading: Stack(
                      children: [
                      CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 40.0,
                      child: CircleAvatar(
                        radius: 30.0,
                        child: ClipOval(
                          child: (_imageFile != null)
                              ? Image.file(_imageFile)
                              : Image.asset('/assets/images/logo.png'),
                          // clipper: MyClip(),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      ),
                      ],
                  ),
                  title: const Text(
                    "My status",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    "Tap to add status",
                    style: TextStyle(fontSize: 12, color: Colors.grey[900]),
                  )),
              Container(
                height: 33,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.grey[300],
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  child: Text(
                    "Others Status",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const OthersStatus(
                name: "onella",
                // image:"",
                time: "08.30",
              ),
              const OthersStatus(
                name: "Chamindu",
                // image:"",
                time: "07.50",
              ),  const OthersStatus(
                name: "Naduni",
                // image:"",
                time: "07.30",
              )


            ],
          )),
    );
  }
}


class HeadStatus extends StatelessWidget {
  const HeadStatus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class MyClip extends CustomClipper<Rect> {
//   Rect getClip(Size size) {
//     return const Rect.fromLTWH(0, 0, 100, 100);
//   }
//
//   bool shouldReclip(oldClipper) {
//     return false;
//   }
// }