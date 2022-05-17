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

  @override
  void initState() {
    super.initState();
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

  void getDoc() async {
    final docref = await _firestore.collection("details").doc(userId).get();
    setState(() {
      selectedDoc = docref;
      userName = selectedDoc.data()['Name'];
      print(selectedDoc.data()['Email']);
      print(userName);
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
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
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
                // ListView.builder(
                //   scrollDirection: Axis.horizontal,
                //   itemCount: 3,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Container(
                //       child: Text(
                //         'Hello',
                //         style: TextStyle(
                //           fontSize: 45,
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: SizedBox(
                height: 400,
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

  Widget buildCard(int index) => Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.white,
        child: SizedBox(
          width: 250,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                //CircleAvatar
                SizedBox(
                  height: 10,
                ), //SizedBox
                //Text
                SizedBox(
                  height: 10,
                ),

                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    // child: Image.asset(
                    //   'images/image1.jpeg',
                    // ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('./images/image1.jpeg'),
                        ),
                      ),
                    ) // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       fit: BoxFit.fill,
                    //       image: NetworkImage("https://picsum.photos/250?image=9"),
                    //     ),
                    //   ),
                    // )
                    ), //Text
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Text("My Pet Family",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          )),
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Update your pet's information",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                MaterialButton(
                  onPressed: () {},
                  color: mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Manage',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minWidth: 150,
                  elevation: 5.0,
                )

                //SizedBox
                // SizedBox(
                //   width: 80,
                //   child: RaisedButton(
                //     onPressed: () => null,
                //     color: Colors.green,
                //     child: Padding(
                //       padding: const EdgeInsets.all(4.0),
                //       child: Row(
                //         children: [
                //           Icon(Icons.touch_app),
                //           Text('Visit'),
                //         ],
                //       ), //Row
                //     ), //Padding
                //   ), //RaisedButton
                // ), //SizedBox
              ],
            ), //Column
          ), //Padding
        ),
      );
}
