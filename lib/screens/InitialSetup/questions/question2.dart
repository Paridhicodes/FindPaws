import 'package:find_paws_engage/screens/InitialSetup/questions/question3.dart';
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

import '../../../components/AlertBox.dart';

class Question2 extends StatefulWidget {
  static const String id = "question_2";
  const Question2({Key? key}) : super(key: key);

  @override
  _Question2State createState() => _Question2State();
}

class _Question2State extends State<Question2> {
  @override
  late String _character = "none";
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
                  currentStep: 3,
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
                        "What is the gender of your dog?",
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
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 25,
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
                            _character = value!;
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
                        fontSize: 25,
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
                          // print(_character);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 170,
              ),
              RoundedButton(
                  buttonText: 'Next',
                  onPressed: () {
                    _character == "none"
                        ? showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertBox(
                                titleText:
                                    'Please select the gender of your dog!',
                                bodyText: '',
                              );
                            },
                          )
                        : Navigator.pushNamed(context, Question3.id,
                            arguments: {
                                'url': arguments['url'],
                                'list': arguments['list'],
                                'breed': arguments['breed'],
                                'name': arguments['name'],
                                'gender': _character,
                              });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
