import 'package:flutter/material.dart';

import '../../widgets/status/status_image_upload.dart';

class StatusScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text('Status') ,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Upload',
              style:TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return StatusImageUpload();
            }
            ));
          },
          
        ),
    );
  }
}