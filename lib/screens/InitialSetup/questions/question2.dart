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

class Question2 extends StatefulWidget {
  static const String id = "question_2";
  const Question2({Key? key}) : super(key: key);

  @override
  _Question2State createState() => _Question2State();
}

class _Question2State extends State<Question2> {
  @override
  late String _character = "female";
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppBarInit(),
            const SizedBox(
              height: 30,
            ),
            const StepProgressIndicator(
              totalSteps: 4,
              currentStep: 2,
              selectedColor: Color(0xffdb8207),
              unselectedColor: Color(0xFFf5c489),
              size: 10,
              roundedEdges: Radius.circular(10),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: const Text(
                    "What is the gender of your pet?",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(
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
                    splashRadius: 40,
                    value: "Male",
                    groupValue: _character,
                    onChanged: (value) {
                      setState(
                        () {
                          _character = value!;
                          print(_character);
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
                    splashRadius: 40,
                    value: "Female",
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value!;
                        print(_character);
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
                  Navigator.pushNamed(context, Question3.id);
                })
          ],
        ),
      ),
    );
  }
}
