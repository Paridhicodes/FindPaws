import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
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
import 'package:string_extensions/string_extensions.dart';
import 'package:number_selection/number_selection.dart';

class DogProfileEdit extends StatefulWidget {
  static const String id = "dog_profile_edit";
  const DogProfileEdit({Key? key}) : super(key: key);

  @override
  _DogProfileEditState createState() => _DogProfileEditState();
}

class _DogProfileEditState extends State<DogProfileEdit> {
  @override
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String userId;
  late var selectedDoc = null;
  var arguments;
  String dogName = '';
  String dogBreed = '';
  String dogGender = '';
  String dogMon = '';
  String dogYr = '';

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
      });
      getDoc();
    });
  }

  void getDoc() async {
    final docref =
        await _firestore.collection("pets").doc(arguments['doc_id']).get();
    setState(() {
      selectedDoc = docref;
      dogName = docref['name'];
      dogBreed = docref['breed'];
      dogGender = docref['gender'];
      dogMon = docref['age_months'];
      dogYr = docref['age_years'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String _character = dogGender;
    String tempYr = dogYr;
    String tempMon = dogMon;
    bool spinner = false;
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: (selectedDoc == null)
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.1,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ),
                  )
                : Stack(clipBehavior: Clip.none, children: [
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
                          backgroundImage: AssetImage('images/dog_profile.gif'),
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
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                              child: Text(
                                'Dog name',
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
                                          dogName,
                                          style: TextStyle(fontSize: 20),
                                        ), // <-- Text
                                        SizedBox(
                                          width: 87,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Change your doggie\'s name '),
                                                content: TextField(
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor,
                                                            width: 1.0),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor,
                                                            width: 2.0),
                                                      ),
                                                      hintText:
                                                          'Doggie\'s name'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      dogName =
                                                          value.toTitleCase!;
                                                    });
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
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
                          //Second field
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                              child: Text(
                                'Dog breed',
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
                                          dogBreed,
                                          style: TextStyle(fontSize: 20),
                                        ), // <-- Text
                                        SizedBox(
                                          width: 87,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Change your doggie\'s breed (Check your spelling!)'),
                                                content: TextField(
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor,
                                                            width: 1.0),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor,
                                                            width: 2.0),
                                                      ),
                                                      hintText:
                                                          'Doggie\'s breed'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      dogBreed =
                                                          value.toTitleCase!;
                                                    });
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
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
                                          child: const Icon(
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
                          //Third Field
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                              child: Text(
                                'Gender',
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
                                          dogGender,
                                          style: TextStyle(fontSize: 20),
                                        ), // <-- Text
                                        SizedBox(
                                          width: 87,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Select your doggie\'s gender',
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      title: const Text(
                                                        'Male',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      leading: Radio<String>(
                                                        activeColor: mainColor,
                                                        splashRadius: 70,
                                                        value: "Male",
                                                        groupValue: _character,
                                                        onChanged: (value) {
                                                          setState(
                                                            () {
                                                              _character =
                                                                  value!;
                                                              dogGender =
                                                                  _character;
                                                              // dogGender = value;
                                                              // print(_character);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: const Text(
                                                        'Female',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      leading: Radio<String>(
                                                        activeColor: mainColor,
                                                        splashRadius: 70,
                                                        value: "Female",
                                                        groupValue: _character,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _character = value!;
                                                            dogGender =
                                                                _character;
                                                            // dogGender = value;
                                                            // print(_character);
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
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
                          //Fourth field
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 20, 0, 8),
                              child: Text(
                                'Age',
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
                                          '${dogYr} years  ${dogMon} months',
                                          style: TextStyle(fontSize: 20),
                                        ), // <-- Text
                                        SizedBox(
                                          width: 87,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Select your doggie\'s age',
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text('Years'),
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          child:
                                                              NumberSelection(
                                                            theme: NumberSelectionTheme(
                                                                draggableCircleColor:
                                                                    Colors
                                                                        .white,
                                                                iconsColor:
                                                                    Colors
                                                                        .white,
                                                                numberColor:
                                                                    mainColor,
                                                                backgroundColor:
                                                                    mainColor,
                                                                outOfConstraintsColor:
                                                                    Colors
                                                                        .deepOrange),
                                                            initialValue: 1,
                                                            minValue: 0,
                                                            maxValue: 15,
                                                            direction:
                                                                Axis.horizontal,
                                                            withSpring: true,
                                                            onChanged: (int
                                                                    value) =>
                                                                setState(() {
                                                              tempYr = value
                                                                  .toString();
                                                            }),
                                                            enableOnOutOfConstraintsAnimation:
                                                                true,
                                                            onOutOfConstraints:
                                                                () => print(
                                                                    "This value is too high or too low"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text('Months'),
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          child:
                                                              NumberSelection(
                                                            theme: NumberSelectionTheme(
                                                                draggableCircleColor:
                                                                    Colors
                                                                        .white,
                                                                iconsColor:
                                                                    Colors
                                                                        .white,
                                                                numberColor:
                                                                    mainColor,
                                                                backgroundColor:
                                                                    mainColor,
                                                                outOfConstraintsColor:
                                                                    Colors
                                                                        .deepOrange),
                                                            initialValue: 1,
                                                            minValue: 0,
                                                            maxValue: 11,
                                                            direction:
                                                                Axis.horizontal,
                                                            withSpring: true,
                                                            onChanged: (int
                                                                    value) =>
                                                                setState(() {
                                                              tempMon = value
                                                                  .toString();
                                                            }),
                                                            enableOnOutOfConstraintsAnimation:
                                                                true,
                                                            onOutOfConstraints:
                                                                () => print(
                                                                    "This value is too high or too low"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      // print(dogYr);
                                                      // print(dogMon);
                                                      if (tempYr == '0' &&
                                                          tempMon == '0') {
                                                        showDialog<void>(
                                                          context: context,
                                                          barrierDismissible:
                                                              false, // user must tap button!
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertBox(
                                                              titleText:
                                                                  'Please select the age of your dog!',
                                                              bodyText: '',
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        setState(() {
                                                          dogYr = tempYr;
                                                          dogMon = tempMon;
                                                        });
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: const Text(
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
                                      .collection('pets')
                                      .doc(arguments['doc_id'])
                                      .update({
                                    'name': dogName,
                                    'breed': dogBreed,
                                    'gender': dogGender,
                                    'age_years': dogYr,
                                    'age_months': dogMon,
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
                  ]),
          ),
        ),
      ),
    );
  }
}
