import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:find_paws_engage/get_breed.dart';

import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/storage.dart';
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
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:string_extensions/string_extensions.dart';

class DisplayBreed extends StatefulWidget {
  static const String id = "display_breed";

  @override
  _DisplayBreedState createState() => _DisplayBreedState();
}

class _DisplayBreedState extends State<DisplayBreed> {
  @override
  late String _breed = "none";

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const AppBarInit(),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StepProgressIndicator(
                    totalSteps: 5,
                    currentStep: 1,
                    selectedColor: Color(0xffdb8207),
                    unselectedColor: Color(0xFFf5c489),
                    size: 10,
                    roundedEdges: Radius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Select the breed of your dog.",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [getButtons(arguments['list'])],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    cursorHeight: 30,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 3.0),
                      ),
                      labelText: 'Specify, if other',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: mainColor,
                      ),
                    ),
                    onChanged: (value) {
                      _breed = value.toTitleCase!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 110,
                ),
                RoundedButton(
                    buttonText: 'Next',
                    onPressed: () {
                      _breed == "none"
                          ? showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertBox(
                                  titleText:
                                      'Please select the breed of your dog!',
                                  bodyText: '',
                                );
                              },
                            )
                          : Navigator.pushNamed(
                              context,
                              Question1.id,
                              arguments: {
                                'url': arguments['url'],
                                'list': arguments['list'],
                                'breed': _breed
                              },
                            );
                    })
              ],
            ),
          ),
        ),
      ),
    );
    ;
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
            fontSize: 25,
          ),
        ),
        leading: Radio<String>(
          activeColor: mainColor,
          splashRadius: 70,
          value: x['label'].toString().toTitleCase!,
          groupValue: _breed,
          onChanged: (value) {
            setState(() {
              _breed = value!;
            });
          },
        ),
      ));
    }
    return Column(
      children: ls,
    );
  }
}
