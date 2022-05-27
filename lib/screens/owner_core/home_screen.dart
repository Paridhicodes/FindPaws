import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/custom_icons_icons.dart';
import 'package:find_paws_engage/custom_icons_paws_icons.dart';
import 'package:find_paws_engage/screens/InitialSetup/UploadImage.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/edit_pages/dog_profile_edit.dart';
import 'package:find_paws_engage/screens/edit_pages/user_profile_edit.dart';
import 'package:find_paws_engage/screens/finder_screens/finder_home_upload.dart';
import 'package:find_paws_engage/screens/owner_core/LostDogCheck.dart';
import 'package:find_paws_engage/screens/owner_core/MyDogsScreen.dart';
import 'package:find_paws_engage/screens/owner_core/about_us.dart';
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
import 'package:flutter/services.dart';
import '../../info_icons.dart';
import '../login_signup/login_screen.dart';
import '../welcome_screen.dart';
import 'package:min_id/min_id.dart';

import 'near_me.dart';

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
  List<Widget> widgetList = [];
  bool spinner = false;
  Widget currentScreen = HomeScreen();
  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      setState(() {
        arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
        spinner = true;
      });
      if (arguments['url'] != null) {
        addToDb(arguments);
      }
    });
    setState(() {
      spinner = false;
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
        });
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future logout() async {
    setState(() {
      spinner = true;
    });
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false));
    setState(() {
      spinner = false;
    });
  }

  void getDoc() async {
    setState(() {
      spinner = true;
    });
    final docref = await _firestore.collection("details").doc(userId).get();
    setState(() {
      selectedDoc = docref;
      userName = selectedDoc.data()['Name'];

      spinner = false;
    });
  }

  void addToDb(final arguments) async {
    setState(() {
      spinner = true;
    });
    await _firestore.collection('pets').add({
      "age_months": arguments['months'],
      "age_years": arguments['years'],
      'breed': arguments['breed'],
      'gender': arguments['gender'],
      'image_url': arguments['url'],
      'lost': arguments['isLost'],
      'name': arguments['name'],
      'owner_id': userId
    }).then((value) {
      // print(value.id);
      if (arguments['isLost']) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('We are sorry to hear that your dog is lost.'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Provide us with some details to help you find your dog!'),
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
                    // print(doc_id);
                    // if (doc_id == null) {
                    //   CircularProgressIndicator();
                    // }

                    Navigator.pushNamed(context, LostDogCheck.id,
                        arguments: {'doc_id': value.id});
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {});
    setState(() {
      spinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    widgetList = [
      CardLayout(
        imageLink: 'images/card7.jpg',
        mainText: 'Found a dog',
        subText: 'If you found a dog, help us find it\'s owner.',
        onPressed: () {
          Navigator.pushNamed(context, FinderUpload.id);
        },
        buttonText: 'Scan',
      ),
      CardLayout(
        imageLink: 'images/card8.jpg',
        mainText: 'My dog family',
        subText:
            'You can view and update the information about your dogs here!',
        onPressed: () {
          Navigator.pushNamed(context, MyDogsScreen.id);
        },
        buttonText: 'View',
      ),
      CardLayout(
        imageLink: 'images/card9.jpg',
        mainText: 'Invite your friends',
        subText: 'You can invite your friends to join the Find Paws community.',
        onPressed: () {
          final id = MinId.getId();

          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Your Invite Code'),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: UnconstrainedBox(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '$id',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ), // <-- Text
                                SizedBox(
                                  width: 87,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // print('Tapped');
                                  },
                                  child: InkWell(
                                    child: Icon(
                                      // <-- Icon
                                      Icons.copy,
                                      size: 15.0,
                                    ),
                                    onTap: () {
                                      Clipboard.setData(
                                              new ClipboardData(text: "$id"))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Code copied successfully !')));
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFD0D0D0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 17,
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
        },
        buttonText: 'Invite',
      ),
    ];

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
            ;
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
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w600),
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    clipBehavior: Clip.none,
                    color: mainColor,
                    shape: CircularNotchedRectangle(),
                    notchMargin: 10,
                    child: Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              MaterialButton(
                                minWidth: 40,
                                onPressed: () {
                                  setState(() {
                                    currentScreen = HomeScreen();
                                    currentTab = 0;
                                  });

                                  Navigator.pushNamed(context, UploadImage.id);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      CustomIcons.dog,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      'Add Dog',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              MaterialButton(
                                minWidth: 40,
                                onPressed: () {
                                  setState(() {
                                    currentScreen = HomeScreen();
                                    currentTab = 0;
                                  });
                                  Navigator.pushNamed(context, NearMe.id);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      CustomIconsPaws.paw,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      'Near me',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              MaterialButton(
                                minWidth: 40,
                                onPressed: () {
                                  setState(() {
                                    currentScreen = HomeScreen();
                                    currentTab = 0;
                                  });
                                  Navigator.pushNamed(context, AboutUs.id);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Info.info_circled,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      'About Us',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              MaterialButton(
                                minWidth: 40,
                                onPressed: () {
                                  setState(() {
                                    currentScreen = HomeScreen();
                                    currentTab = 0;
                                  });
                                  Navigator.pushNamed(context, UserProfile.id);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      'My Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: FloatingActionButton(
                        clipBehavior: Clip.none,
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Quick actions'),
                                content: SingleChildScrollView(
                                    child: Container(
                                  child: Column(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, MyDogsScreen.id);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Text(
                                            'Lost my dog',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, FinderUpload.id);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Text(
                                            'Found a dog',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                actions: <Widget>[],
                              );
                              ;
                            },
                          );
                        },
                        backgroundColor: Color(0xff88c0b5),
                        child: Image.asset('images/splashscreenimage.png',
                            width: 120, height: 120),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(int index) => widgetList[index];
}
