import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:find_paws_engage/get_breed.dart';
import 'package:find_paws_engage/screens/InitialSetup/display_breed.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/storage.dart';
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class UploadImage extends StatefulWidget {
  static const String id = "upload_image";

  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final _firebaseStorage = FirebaseStorage.instance;
  Storage storage = Storage();
  var imagePath;
  var imageName;
  String imageUrl = "";
  List<dynamic> ls = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppBarInit(),
            Container(
              child: imagePath == null
                  ? Container(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListTile(
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
                          const SizedBox(
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
                            child: Image.file(File(imagePath)),
                          ),
                          RoundedButton(
                            buttonText: 'Next',
                            onPressed: () async {
                              // checkBreed();
                              GetBreed _getBreed =
                                  GetBreed(imageLink: imagePath);
                              List list = await _getBreed.initialFunc();
                              print(list);
                              print(list.length);
                              if (!list.isEmpty) {
                                await storage.uploadFile(imagePath, imageName);
                                var downurl =
                                    await storage.downloadUrl(imageName);
                                print(downurl);
                                await Navigator.pushNamed(
                                    context, Question1.id);
                              } else {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Please upload a clear image of your dog.'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'The image of your dog must be front-facing and must have proper lighting.'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: mainColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, UploadImage.id);
                                          },
                                        ),
                                      ],
                                    );
                                    // return AlertBox(
                                    //   titleText:
                                    //       'Please upload a clear image of your dog.',
                                    //   bodyText:
                                    //       'The image of your dog must be front-facing and must have proper lighting.',
                                    // );
                                  },
                                );
                              }

                              // print(imagePath);
                              // print(File(imagePath));

                              // setState(() async {
                              //   ls = list;
                              //   print("taken");
                              // });

                              // await Navigator.pushNamed(
                              //   context,
                              //   DisplayBreed.id,
                              // );
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
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (results != null) {
      setState(() {
        imagePath = results.files.single.path;
        imageName = results.files.single.name;

        // print(imageName);
        // print(imagePath);
      });
    }
  }

  void checkBreed() async {
    // print(ls);
  }
}
