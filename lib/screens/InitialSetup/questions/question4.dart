import 'package:find_paws_engage/screens/InitialSetup/questions/question3.dart';
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
import 'dart:io';
import 'dart:async';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../components/AlertBox.dart';

class Question4 extends StatefulWidget {
  static const String id = "question_4";
  const Question4({Key? key}) : super(key: key);

  @override
  _Question4State createState() => _Question4State();
}

class _Question4State extends State<Question4> {
  bool pressAttention1 = false;
  bool pressAttention2 = false;
  bool lost = false;
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
                  currentStep: 5,
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
                        "Is your dog safe?",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      pressAttention1 = !pressAttention1;
                      pressAttention2 = false;
                      lost = false;
                    });
                  },
                  color: pressAttention1 ? Colors.green : mainColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Yes, my dog is safe!",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  minWidth: 230,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      pressAttention2 = !pressAttention2;
                      pressAttention1 = false;
                      lost = true;
                    });
                  },
                  color: pressAttention2 ? Colors.red : mainColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "No, my dog is lost!",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  minWidth: 230,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 140,
              ),
              RoundedButton(
                  buttonText: 'Next',
                  onPressed: () {
                    (!pressAttention1 && !pressAttention2)
                        ? showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertBox(
                                titleText: 'Let us know if your dog is safe.',
                                bodyText: '',
                              );
                            },
                          )
                        : Navigator.pushNamed(context, HomeScreen.id,
                            arguments: {
                                'url': arguments['url'],
                                'list': arguments['list'],
                                'breed': arguments['breed'],
                                'name': arguments['name'],
                                'gender': arguments['gender'],
                                'years': arguments['years'],
                                'months': arguments['months'],
                                'isLost': lost
                              });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
