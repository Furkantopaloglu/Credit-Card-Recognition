import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
   File pickedImage;
   final picker =ImagePicker();
   bool isImageLoaded=false;

  Future pickImage()async{
    var tempStore=await picker.getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage=File(tempStore.path);
      isImageLoaded=true;
    });
  }
  Future readText()async{
    FirebaseVisionImage ourImage=FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer reconizeText=FirebaseVision.instance.textRecognizer();
    VisionText readText= await reconizeText.processImage(ourImage);
    
    for(TextBlock block in readText.blocks){
      for(TextLine line in block.lines){
        print(line.text);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            isImageLoaded ? Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(pickedImage),fit: BoxFit.cover),
                ),
              ),
            ): Container(),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: pickImage,
              child: Text("pick an image"),),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: readText,
              child: Text("read"),),
          ],
        ),
      ),
    );
  }
}

