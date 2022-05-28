import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:find_paws_engage/get_breed.dart';
import 'package:find_paws_engage/get_dog_cat.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/display_breed.dart';
import 'package:find_paws_engage/screens/finder_screens/FoundOwners.dart';
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
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:string_extensions/string_extensions.dart';

class FinderDetails extends StatefulWidget {
  static const String id = "finder_details";
  const FinderDetails({Key? key}) : super(key: key);

  @override
  _FinderDetailsState createState() => _FinderDetailsState();
}

class _FinderDetailsState extends State<FinderDetails> {
  late String email;
  late String name;
  late String phoneNumber;
  bool showSpinner = false;
  CountryCode countryCode = CountryCode(name: "IN", dialCode: '+91');
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  List owners = [];
  bool updated = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                AppBarInit(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Contact details",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          //Do something with the user input.
                          name = value;
                        },
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: 'Name'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              //Do something with the user input.
                              email = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Email Address'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CountryCodePicker(
                                onChanged: (value) {
                                  countryCode = value;
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'IN',
                                favorite: ['+91', 'IN'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.left,
                                  onChanged: (value) {
                                    //Do something with the user input.
                                    phoneNumber = "$countryCode$value";
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Phone Number'),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: RoundedButton(
                    buttonText: 'Find',
                    onPressed: () async {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email);
                      if (!emailValid) {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertBox(
                              titleText: 'Please enter a valid email address.',
                              bodyText:
                                  'This will help us to reach the owners asap. ',
                            );
                          },
                        );
                      } else {
                        fetchRecords(arguments['lat'], arguments['long'],
                            arguments['list']);
                        if (!updated) {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertBox(
                                titleText:
                                    'Fetching potential owner details...',
                                bodyText:
                                    'Please wait while we search for the possible owners near you.',
                              );
                            },
                          );
                        }
                        if (updated) {
                          Navigator.pushNamed(context, FoundOwners.id,
                              arguments: {
                                'lat': arguments['lat'],
                                'long': arguments['long'],
                                'url': arguments['url'],
                                'list': arguments['list'],
                                'finder_name': name,
                                'finder_email': email,
                                'finder_phone': phoneNumber,
                                'owner_list': owners,
                              });
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchRecords(double lat, double long, List list) {
    List tempowners = [];
    List breedList = [];

    for (var i = 0; i < list.length; i++) {
      String? str = list[i]['label'].toString().toTitleCase;
      breedList.add(str);
    }

    GeoFirePoint center = geo.point(latitude: lat, longitude: long);
    _firestore.collection("pets").where('breed', whereIn: breedList).get().then(
          (res) => {},
          onError: (e) => print("Error completing: $e"),
        );
    var queryRef = _firestore
        .collection('pets')
        .where('lost', isEqualTo: true)
        .where('breed', whereIn: breedList);

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: queryRef)
        .within(center: center, radius: 50, field: 'point');

    stream.listen((List<DocumentSnapshot> documentList) async {
      final response = await documentList;
      documentList.forEach((DocumentSnapshot document) {
        tempowners.add(document);
      });

      setState(() {
        owners = tempowners;
        updated = true;
      });
    });
  }
}
