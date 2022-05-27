import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:find_paws_engage/components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:find_paws_engage/components/AppBarInit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:io';
import 'dart:async';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:find_paws_engage/components/CardLayout.dart';

class UserProfile extends StatefulWidget {
  static const String id = "user_profile";
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  String userId = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';

  @override
  void initState() {
    // TODO: implement initState
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          userId = user.uid;
        });
        getDoc();
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  void getDoc() async {
    final docref = await _firestore.collection("details").doc(userId).get();
    setState(() {
      userName = docref['Name'];
      userEmail = docref['Email'];
      userPhone = docref['Phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    bool spinner = false;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: SafeArea(
              child: (userName == '')
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 1.1,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 6,
                          decoration: BoxDecoration(
                            color: mainColor,
                          ),
                        ),
                        Positioned(
                          left: (MediaQuery.of(context).size.width / 2) - 65,
                          top: MediaQuery.of(context).size.height / 6 - 65,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 69,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/user_profile.gif'),
                              radius: 65,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 200, 8, 8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 8),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: UnconstrainedBox(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              userName,
                                              style: TextStyle(fontSize: 20),
                                            ), // <-- Text
                                            SizedBox(
                                              width: 85,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        'Change your name '),
                                                    content: TextField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor,
                                                                        width:
                                                                            1.0),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor,
                                                                        width:
                                                                            2.0),
                                                              ),
                                                              hintText:
                                                                  'Your name'),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          userName = value;
                                                        });
                                                      },
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Change',
                                                          style: TextStyle(
                                                            color: mainColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                // <-- Icon
                                                Icons.edit,
                                                size: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: mainColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 8),
                                  child: Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: UnconstrainedBox(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              userPhone,
                                              style: TextStyle(fontSize: 20),
                                            ), // <-- Text
                                            SizedBox(
                                              width: 60,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        'Change your phone number '),
                                                    content: TextField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor,
                                                                        width:
                                                                            1.0),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor,
                                                                        width:
                                                                            2.0),
                                                              ),
                                                              hintText:
                                                                  'Your phone number'),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          userPhone = value;
                                                        });
                                                      },
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Change',
                                                          style: TextStyle(
                                                            color: mainColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                // <-- Icon
                                                Icons.edit,
                                                size: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: mainColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 8),
                                  child: Text(
                                    'Email ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: UnconstrainedBox(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              userEmail,
                                              style: TextStyle(fontSize: 20),
                                            ), // <-- Text
                                            SizedBox(
                                              width: 60,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        'You cannot change your email address.'),
                                                    content: Text(''),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                            color: mainColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                // <-- Icon
                                                Icons.edit,
                                                size: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: mainColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                child: RoundedButton(
                                    buttonText: 'Save Changes',
                                    textSize: 18,
                                    buttonSize: 140,
                                    onPressed: () async {
                                      setState(() {
                                        spinner = true;
                                      });
                                      await _firestore
                                          .collection('details')
                                          .doc(userId)
                                          .update({
                                        'Name': userName,
                                        'Phone': userPhone,
                                      });
                                      setState(() {
                                        spinner = false;
                                      });
                                      Navigator.pop(context);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
