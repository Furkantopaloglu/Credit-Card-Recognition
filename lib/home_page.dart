import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File pickedImage;
  final picker = ImagePicker();
  bool isImageLoaded = false;
  String readValue = "";

  Future pickImage() async {
    var tempStore = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer reconizeText = FirebaseVision.instance.textRecognizer();
    VisionText readedText = await reconizeText.processImage(ourImage);
    setState(() {
      readValue = readedText.text.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Credit Card",
          )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isImageLoaded
                ? Center(
                    child: Container(
                      height: 200,
                      width: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: pickImage,
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "pick an image",
                style: TextStyle(fontSize: 17),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: readText,
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "read",
                style: TextStyle(fontSize: 17),
              ),
            ),
            Text(readValue.toString(),style: TextStyle(fontSize: 17),),
          ],
        ),
      ),
    );
  }
}
