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
import 'package:string_extensions/string_extensions.dart';

class Question1 extends StatefulWidget {
  static const String id = "question_01";
  const Question1({Key? key}) : super(key: key);

  @override
  _Question1State createState() => _Question1State();
}

class _Question1State extends State<Question1> {
  @override
  String name = "";

  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      body: SingleChildScrollView(
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
                  currentStep: 2,
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
                        "What is the name of your dog?",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 33, vertical: 56),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                  cursorHeight: 30,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 1.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 4.0),
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontSize: 30,
                      color: mainColor,
                    ),
                  ),
                  onChanged: (value) {
                    name = value.toTitleCase!;
                  },
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              RoundedButton(
                  buttonText: 'Next',
                  onPressed: () {
                    name == ""
                        ? showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertBox(
                                titleText: 'Please enter a valid name!',
                                bodyText:
                                    'The name must have at least one character.',
                              );
                            },
                          )
                        : Navigator.pushNamed(
                            context,
                            Question2.id,
                            arguments: {
                              'url': arguments['url'],
                              'list': arguments['list'],
                              'breed': arguments['breed'],
                              'name': name,
                            },
                          );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
