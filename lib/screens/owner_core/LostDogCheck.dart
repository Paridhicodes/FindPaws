import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/custom_icons_icons.dart';
import 'package:find_paws_engage/custom_icons_paws_icons.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/edit_pages/dog_profile_edit.dart';
import 'package:find_paws_engage/screens/edit_pages/fetch_location.dart';
import 'package:find_paws_engage/screens/edit_pages/user_profile_edit.dart';

import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
import 'package:find_paws_engage/screens/welcome_screen.dart';
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
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:find_paws_engage/components/CardLayout.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../login_signup/login_screen.dart';

class LostDogCheck extends StatefulWidget {
  static const String id = "";
  const LostDogCheck({Key? key}) : super(key: key);

  @override
  _LostDogCheckState createState() => _LostDogCheckState();
}

class _LostDogCheckState extends State<LostDogCheck> {
  @override
  final _firestore = FirebaseFirestore.instance;
  int count = 0;
  List iconKeeper = [0, 0, 0];
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return WillPopScope(
      onWillPop: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Please complete a few crucial steps for us to record the details of your lost dog.'),
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
                    'Ok',
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
                    'No, my dog is safe!',
                    style: TextStyle(
                      fontSize: 18,
                      color: mainColor,
                    ),
                  ),
                  onPressed: () {
                    _firestore
                        .collection('pets')
                        .doc(arguments['doc_id'])
                        .update({'lost': false});
                    Navigator.pushNamed(context, HomeScreen.id);
                  },
                ),
              ],
            );
            ;
          },
        );
        return Future<bool>.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppBarInit(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: ListView(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            count++;
                            setState(() {
                              iconKeeper[0] = 1;
                            });
                            Navigator.pushNamed(context, DogProfileEdit.id,
                                arguments: {'doc_id': arguments['doc_id']});
                          },
                          child: ListTile(
                            leading: Icon(
                              iconKeeper[0] == 0
                                  ? Icons.radio_button_unchecked
                                  : Icons.check_circle_outline_outlined,
                              size: 25,
                              color: iconKeeper[0] == 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            title: Text(
                              'Check your dog\'s profile',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            count++;
                            setState(() {
                              iconKeeper[1] = 1;
                            });
                            Navigator.pushNamed(context, UserProfile.id);
                          },
                          child: ListTile(
                            leading: Icon(
                              iconKeeper[1] == 0
                                  ? Icons.radio_button_unchecked
                                  : Icons.check_circle_outline_outlined,
                              size: 25,
                              color: iconKeeper[1] == 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            title: Text(
                              'Check your personal details',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            count++;
                            setState(() {
                              iconKeeper[2] = 1;
                            });
                            Navigator.pushNamed(context, FetchLocation.id,
                                arguments: {'doc_id': arguments['doc_id']});
                          },
                          child: ListTile(
                            leading: Icon(
                              iconKeeper[2] == 0
                                  ? Icons.radio_button_unchecked
                                  : Icons.check_circle_outline_outlined,
                              size: 25,
                              color: iconKeeper[2] == 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            title: Text(
                              'Allow us to get your location',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundedButton(
                    buttonText: 'Done',
                    onPressed: () {
                      if (count < 3) {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertBox(
                              titleText: 'Tick all the tasks!',
                              bodyText: '',
                            );
                          },
                        );
                      } else {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'The required details have been recorded.'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'We shall inform you as soon as we get an update!'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: mainColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, HomeScreen.id);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        // ;
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
