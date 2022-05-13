import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:find_paws_engage/components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:find_paws_engage/components/AppBarInit.dart';
import 'dart:io';
import 'dart:async';

class UploadImage extends StatefulWidget {
  static const String id = "upload_image";
  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  var imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarInit(),
            Container(
              child: imageFile == null
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const ListTile(
                              title: Text(
                                "Add a cute photo of your pet!",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                "Choose a front facing picture, similar to a passport photo.",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'images/upload_image01.jpg',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RoundedButton(
                                    buttonText: 'From Gallery',
                                    onPressed: () {
                                      _getFromGallery();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RoundedButton(
                                    buttonText: 'From Camera',
                                    onPressed: () {
                                      _getFromCamera();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                "Wonderful Pic!",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                "Just answer a few questions to make it easier to find your pet if they ever go missing",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 360,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: mainColor, width: 10),
                            ),
                            child: Image.file(imageFile),
                          ),
                          // Container(
                          //   child: Image.file(
                          //     imageFile,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          RoundedButton(
                            buttonText: 'Next',
                            onPressed: () {
                              Navigator.pushNamed(context, Question1.id);
                            },
                          )
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(imageFile);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(imageFile);
      });
    }
  }
}
