import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:find_paws_engage/get_breed.dart';
import 'package:find_paws_engage/get_dog_cat.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/display_breed.dart';

import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/screens/finder_screens/FinderChecklist.dart';
import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
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

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../welcome_screen.dart';

class FinderUpload extends StatefulWidget {
  static const String id = "finder_upload_screen";
  const FinderUpload({Key? key}) : super(key: key);

  @override
  _FinderUploadState createState() => _FinderUploadState();
}

class _FinderUploadState extends State<FinderUpload> {
  var imageFile;
  String downurl = '';
  Storage storage = Storage();
  bool spinner = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Do you really want to exit?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(''),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 18,
                      color: mainColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                ),
                TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(
                      fontSize: 18,
                      color: mainColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        return Future<bool>.value(true);
      },
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: spinner,
          progressIndicator: const CircularProgressIndicator(
            color: mainColor,
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppBarInit(),
                Container(
                  child: imageFile == null
                      ? Container(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(bottom: 9),
                                    child: Text(
                                      "Help us find the owner!",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Take a photo of the lost dog you have just found. While you take care of that dog, we work zealously to find its home. ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Image.asset(
                                'images/lost_dog_image.jpg',
                                width: 250,
                                height: 250,
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          70, 8, 70, 8),
                                      child: RoundedButton(
                                        buttonText: 'Click a picture',
                                        onPressed: () {
                                          _getFromCamera();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Skip to Home',
                                      style: TextStyle(
                                          shadows: [
                                            Shadow(
                                                color: mainColor,
                                                offset: Offset(0, -5))
                                          ],
                                          color: Colors.transparent,
                                          decoration: TextDecoration.underline,
                                          decorationColor: mainColor,
                                          decorationThickness: 4,
                                          fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, HomeScreen.id);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  "Here is the pic that you clicked!",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  "Thankyou for the noble work ❤",
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
                                border: Border.all(color: mainColor, width: 5),
                              ),
                              child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              ),
                            ),
                            RoundedButton(
                              buttonText: 'Next',
                              onPressed: () async {
                                setState(() {
                                  spinner = true;
                                });
                                GetBreed _getBreed =
                                    GetBreed(imageLink: imageFile.path);
                                List list = await _getBreed.initialFunc();

                                GetDogCat _getDogCat =
                                    GetDogCat(imageLink: imageFile.path);

                                List sec_list = await _getDogCat.initialFunc();
                                // print(list);
                                // print(sec_list);
                                if (sec_list.length > 1 &&
                                    sec_list[0]['label'] == 'Cat') {
                                  setState(() {
                                    spinner = false;
                                  });
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
                                                  context, FinderUpload.id);
                                              ;
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (!sec_list.isEmpty &&
                                    sec_list[0]['label'] == 'Cat') {
                                  setState(() {
                                    spinner = false;
                                  });
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'You have uploaded the image of a cat!'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'You are required to upload a clear image of your dog.'),
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
                                                context,
                                                FinderUpload.id,
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (!list.isEmpty) {
                                  await storage.uploadFile(
                                      imageFile.path, 'finder_image');
                                  downurl =
                                      await storage.downloadUrl('finder_image');

                                  Navigator.pushNamed(
                                      context, FinderCheckList.id, arguments: {
                                    'list': list,
                                    'url': downurl
                                  });
                                  setState(() {
                                    spinner = false;
                                  });
                                } else {
                                  setState(() {
                                    spinner = false;
                                  });
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
                                                  context, FinderUpload.id);
                                              ;
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            )
                          ],
                        )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        // print(imageFile);
      });
    }
  }
}
