import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/custom_icons_icons.dart';
import 'package:find_paws_engage/custom_icons_paws_icons.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/edit_pages/dog_profile_edit.dart';
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

import '../login_signup/login_screen.dart';

class MyDogsScreen extends StatefulWidget {
  static const String id = "my_dogs_screen";
  const MyDogsScreen({Key? key}) : super(key: key);

  @override
  _MyDogsScreenState createState() => _MyDogsScreenState();
}

class _MyDogsScreenState extends State<MyDogsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String userId;
  late Stream<QuerySnapshot<Map<String, dynamic>>> selectedDoc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getDocList();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          userId = user.uid;
          // print(userId);
        });
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future<void> getDocList() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> docref = await _firestore
        .collection('pets')
        .where("owner_id", isEqualTo: userId)
        .snapshots();
    setState(() {
      selectedDoc = docref;
      print(userId);
      print(selectedDoc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              AppBarInit(),
            ],
          ),
        ),
      ),
    );
  }
}
