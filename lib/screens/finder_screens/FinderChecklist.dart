import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:find_paws_engage/get_breed.dart';
import 'package:find_paws_engage/get_dog_cat.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/display_breed.dart';
import 'package:find_paws_engage/screens/finder_screens/FinderDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
import 'package:find_paws_engage/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:find_paws_engage/components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:find_paws_engage/components/AppBarInit.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FinderCheckList extends StatefulWidget {
  static const String id = "finder_checklist";
  const FinderCheckList({Key? key}) : super(key: key);

  @override
  _FinderCheckListState createState() => _FinderCheckListState();
}

class _FinderCheckListState extends State<FinderCheckList> {
  bool loc = false;
  double _currlat = 0;
  double _currlong = 0;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/splashscreenimage.png',
                    width: 70,
                    height: 70,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 65),
                    child: Text(
                      'Finder Check List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: mainColor,
              toolbarHeight: 70,
              elevation: 5,
            ),
            Column(
              children: [
                Container(
                  height: 2 * MediaQuery.of(context).size.height / 3,
                  child: ListView(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          print("n");
                        },
                        child: const ListTile(
                          leading: Icon(
                            Icons.check_circle_outline_outlined,
                            size: 25,
                            color: Colors.green,
                          ),
                          title: Text(
                            'The probable breeds of the dog are:',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Container(
                          child: getButtons(
                            arguments['list'],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            loc = true;
                          });
                          Future<Position?> newPos = determinePosition();
                          if (_currlat == 0 && _currlong == 0) {
                            const Center(child: CircularProgressIndicator());
                          }
                        },
                        child: ListTile(
                          leading: Icon(
                            loc == false
                                ? Icons.radio_button_unchecked
                                : Icons.check_circle_outline_outlined,
                            size: 25,
                            color: loc == false ? Colors.red : Colors.green,
                          ),
                          title: const Text(
                            'Allow us to get your location',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                        child: RoundedButton(
                          buttonText: 'Next',
                          onPressed: () {
                            if (!loc || (_currlat == 0 && _currlong == 0)) {
                              if (loc) {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertBox(
                                      titleText:
                                          'We are still fetching your current location...',
                                      bodyText: '',
                                      finalText: 'Wait',
                                    );
                                  },
                                );
                              } else {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertBox(
                                      titleText: 'Tick all the tasks!',
                                      bodyText: '',
                                    );
                                  },
                                );
                              }
                            } else {
                              Navigator.pushNamed(context, FinderDetails.id,
                                  arguments: {
                                    'lat': _currlat,
                                    'long': _currlong,
                                    'url': arguments['url'],
                                    'list': arguments['list'],
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getButtons(List<dynamic> list) {
    // print(list);
    List<Widget> ls = [];
    for (var x in list) {
      String breed = x['label'].toString().toTitleCase!;
      ls.add(ListTile(
        title: Text(
          breed,
          style: const TextStyle(
            fontSize: 19,
            fontStyle: FontStyle.italic,
            color: mainColor,
          ),
        ),
      ));
    }
    return Column(
      children: ls,
    );
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) {
      setState(() {
        _currlat = value.latitude;
        _currlong = value.longitude;
      });
      // print(value);
    });
  }
}
