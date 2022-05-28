import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/custom_icons_icons.dart';
import 'package:find_paws_engage/custom_icons_paws_icons.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/edit_pages/dog_profile_edit.dart';

import 'package:find_paws_engage/screens/owner_core/LostDogCheck.dart';
import 'package:find_paws_engage/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:toggle_switch/toggle_switch.dart';
import '../login_signup/login_screen.dart';
import 'home_screen.dart';

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
  late Stream<QuerySnapshot> selectedDoc;
  bool spinner = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        progressIndicator: const CircularProgressIndicator(
          color: mainColor,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const AppBarInit(),
                FutureBuilder(
                  future: Future.value(_auth.currentUser!.uid),
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ),
                      );
                    }
                    // print(futureSnapshot.data);
                    return StreamBuilder<QuerySnapshot>(

                        // <2> Pass `Stream<QuerySnapshot>` to stream
                        stream: _firestore
                            .collection('pets')
                            .where('owner_id', isEqualTo: futureSnapshot.data)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                            final List<DocumentSnapshot> documents =
                                snapshot.data!.docs;
                            // print(documents.length);

                            return SingleChildScrollView(
                              child: ListView.builder(
                                  // physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.55,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog<void>(
                                                          context: context,
                                                          barrierDismissible:
                                                              false, // user must tap button!
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Are you sure you want to delete this pet profile?'),
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: ListBody(
                                                                  children: const <
                                                                      Widget>[
                                                                    Text(
                                                                        'Once deleted, you will not be able to retrieve it.'),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                    'Delete',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color:
                                                                          mainColor,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    setState(
                                                                        () {
                                                                      spinner =
                                                                          true;
                                                                    });
                                                                    await _firestore.runTransaction(
                                                                        (Transaction
                                                                            myTransaction) async {
                                                                      await myTransaction
                                                                          .delete(
                                                                              documents[index].reference);
                                                                    });
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .refFromURL(documents[index]
                                                                            [
                                                                            'image_url'])
                                                                        .delete();
                                                                    setState(
                                                                        () {
                                                                      spinner =
                                                                          false;
                                                                    });

                                                                    setState(
                                                                        () {
                                                                      spinner =
                                                                          false;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                            ;
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 18,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        // print(
                                                        // documents[index].id);
                                                        Navigator.pushNamed(
                                                            context,
                                                            DogProfileEdit.id,
                                                            arguments: {
                                                              'doc_id':
                                                                  documents[
                                                                          index]
                                                                      .id
                                                            });
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 18,
                                                        color: mainColor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Container(
                                                    width: 2 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            documents[index]
                                                                ['image_url']),
                                                      ),
                                                    ),
                                                  ), // Container(
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          7, 15, 7, 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(documents[index]
                                                          ['name']),
                                                      Text(documents[index]
                                                          ['breed']),
                                                      Icon(
                                                        documents[index][
                                                                    'gender'] ==
                                                                'Male'
                                                            ? Icons.male
                                                            : Icons.female,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ToggleSwitch(
                                                  minWidth: 90.0,
                                                  initialLabelIndex:
                                                      documents[index]['lost']
                                                          ? 1
                                                          : 0,
                                                  cornerRadius: 10.0,
                                                  activeFgColor: Colors.white,
                                                  inactiveBgColor: Colors.grey,
                                                  inactiveFgColor: Colors.white,
                                                  totalSwitches: 2,
                                                  labels: ['Safe', 'Lost'],
                                                  activeBgColors: [
                                                    [Colors.green],
                                                    [Colors.red]
                                                  ],
                                                  onToggle: (idx) {
                                                    if (idx == 1 &&
                                                        documents[index]
                                                                ['lost'] ==
                                                            false) {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'We are sorry to hear that your dog is lost.'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      'Provide us with some details to help you find your dog!'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text(
                                                                  'Ok',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color:
                                                                        mainColor,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  String
                                                                      dog_id =
                                                                      documents[
                                                                              index]
                                                                          .id;

                                                                  _firestore
                                                                      .collection(
                                                                          'pets')
                                                                      .doc(
                                                                          dog_id)
                                                                      .update({
                                                                    'lost': true
                                                                  });
                                                                  // print(
                                                                  //     'called');
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      LostDogCheck
                                                                          .id,
                                                                      arguments: {
                                                                        'doc_id':
                                                                            documents[index].id
                                                                      });
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else if (idx == 0 &&
                                                        documents[index]
                                                                ['lost'] ==
                                                            true) {
                                                      // print("You found your dog");

                                                      String dog_id =
                                                          documents[index].id;
                                                      _firestore
                                                          .collection('pets')
                                                          .doc(dog_id)
                                                          .update(
                                                              {'lost': false});
                                                      showDialog<void>(
                                                          context: context,
                                                          barrierDismissible:
                                                              false, // user must tap button!
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertBox(
                                                              titleText:
                                                                  'Yayy! Your dog is safe 🎉 ',
                                                              bodyText: '',
                                                              finalText: 'Yes!',
                                                            );
                                                          });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else if (snapshot.hasError) {
                            return Text('It\'s Error!');
                          } else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              ),
                            );
                          }
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
