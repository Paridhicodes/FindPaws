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

class Question4 extends StatefulWidget {
  static const String id = "question_4";
  const Question4({Key? key}) : super(key: key);

  @override
  _Question4State createState() => _Question4State();
}

class _Question4State extends State<Question4> {
  @override
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
              currentStep: 4,
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
                    "Is your pet safe?",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 170,
            ),
            RoundedButton(
                buttonText: 'Next',
                onPressed: () {
                  // Navigator.pushNamed(context, Question3.id);
                })
          ],
        ),
      ),
    );
  }
}
