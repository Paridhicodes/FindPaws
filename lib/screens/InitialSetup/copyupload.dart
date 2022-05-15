// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:find_paws_engage/constants.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:find_paws_engage/components/RoundedButton.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:async';
//
// class UploadImage extends StatefulWidget {
//   static const String id = "upload_image";
//   const UploadImage({Key? key}) : super(key: key);
//
//   @override
//   _UploadImageState createState() => _UploadImageState();
// }
//
// class _UploadImageState extends State<UploadImage> {
//   var imageFile;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Image Picker"),
//         ),
//         body: Container(
//             child: imageFile == null
//                 ? Container(
//                     alignment: Alignment.center,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         RaisedButton(
//                           color: Colors.greenAccent,
//                           onPressed: () {
//                             _getFromGallery();
//                           },
//                           child: Text("PICK FROM GALLERY"),
//                         ),
//                         Container(
//                           height: 40.0,
//                         ),
//                         RaisedButton(
//                           color: Colors.lightGreenAccent,
//                           onPressed: () {
//                             _getFromCamera();
//                           },
//                           child: Text("PICK FROM CAMERA"),
//                         )
//                       ],
//                     ),
//                   )
//                 : Container(
//                     child: Image.file(
//                       imageFile,
//                       fit: BoxFit.cover,
//                     ),
//                   )));
//   }
//
//   /// Get from gallery
//   _getFromGallery() async {
//     PickedFile? pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//         print(imageFile);
//       });
//     }
//   }
//
//   /// Get from Camera
//   _getFromCamera() async {
//     PickedFile? pickedFile = await ImagePicker().getImage(
//       source: ImageSource.camera,
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//         print(imageFile);
//       });
//     }
//   }
// }

//-----------------------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class GetBreed extends StatefulWidget {
  final String imageLink;
  const GetBreed({required this.imageLink});

  @override
  _GetBreedState createState() => _GetBreedState();
}

class _GetBreedState extends State<GetBreed> {
  bool isWorking = false;
  String result = '';
  Image? image;
  Widget build(BuildContext context) {
    return Container();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  runModelOnImage() async {
    if (image != null) {
      var recognitions = await Tflite.runModelOnImage(
          path: widget.imageLink,
          imageMean: 127.5, // defaults to 117.0
          imageStd: 127.5, // defaults to 1.0
          numResults: 2, // defaults to 5
          threshold: 0.1, // defaults to 0.1
          asynch: true);
      result = '';
      for (var response in recognitions!) {
        result += response['label'] +
            " " +
            (response['confidence'] as double).toStringAsFixed(2) +
            "\n\n";
      }
      setState(() {
        result;
      });

      isWorking = false;
    }
  }

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    image = Image.network(widget.imageLink);
    loadModel();

    runModelOnImage();
    super.dispose();
    await Tflite.close();
  }
}

