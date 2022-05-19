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
import 'dart:io';
import 'dart:async';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:find_paws_engage/components/CardLayout.dart';

import '../login_signup/login_screen.dart';
import '../welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String userId;
  late final selectedDoc;
  String userName = '';
  var arguments;

  final List<Widget> widgetList = [
    CardLayout(
      imageLink: 'images/card7.jpg',
      mainText: 'MainText1',
      subText: 'SubText1',
      onPressed: () {
        print('1');
      },
      buttonText: 'Manage',
    ),
    CardLayout(
      imageLink: 'images/card8.jpg',
      mainText: 'MainText2',
      subText: 'SubText2',
      onPressed: () {
        print('2');
      },
      buttonText: 'Link',
    ),
    CardLayout(
      imageLink: 'images/card9.jpg',
      mainText: 'MainText3',
      subText: 'SubText3',
      onPressed: () {
        print('3');
      },
      buttonText: 'Update',
    ),
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
      });
      addToDb(arguments);
    });
    getCurrentUser();
    getDoc();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          userId = user.uid;
          print(userId);
        });
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future logout() async {
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false));
  }

  void getDoc() async {
    final docref = await _firestore.collection("details").doc(userId).get();
    setState(() {
      selectedDoc = docref;
      userName = selectedDoc.data()['Name'];
      print(selectedDoc.data()['Email']);
      print(userName);
    });
  }

  void addToDb(final arguments) {
    _firestore.collection('pets').add({
      "age_months": arguments['months'],
      "age_years": arguments['years'],
      'breed': arguments['breed'],
      'gender': arguments['gender'],
      'image_url': arguments['url'],
      'lost': arguments['isSafe'],
      'name': arguments['name'],
      'owner_id': userId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: mainColor,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: TextButton(
                    child: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      logout();
                    }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello, $userName !',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome to your very own pet corner, where you can manage all your doggies and update everything! Happy Pawesome!',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: SizedBox(
                height: 390,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  padding: EdgeInsets.all(12.0),
                  itemBuilder: (context, index) {
                    return buildCard(index);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 12);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget buildCard(int index) => widgetList[index];
}
