import 'package:find_paws_engage/screens/InitialSetup/questions/question4.dart';
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

class Question3 extends StatefulWidget {
  static const String id = "question_3";
  const Question3({Key? key}) : super(key: key);

  @override
  _Question3State createState() => _Question3State();
}

class _Question3State extends State<Question3> {
  String? selectedValue_years;
  String? selectedValue_months;
  List<String> items1 = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15'
  ];
  List<String> items2 = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];
  @override
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
                  currentStep: 4,
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
                        "What is the age of your dog?",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Years',
                          style: TextStyle(fontSize: 30),
                        ),
                        DropdownButton2(
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items1
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue_years,
                          onChanged: (value) {
                            setState(() {
                              selectedValue_years = value as String;
                            });
                          },
                          iconEnabledColor: mainColor,
                          selectedItemHighlightColor: mainColor,
                          buttonHeight: 60,
                          buttonWidth: 140,
                          itemHeight: 40,
                          dropdownWidth: 140,
                          underline: Container(
                            color: mainColor,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Months', style: TextStyle(fontSize: 30)),
                        DropdownButton2(
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items2
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue_months,
                          onChanged: (value) {
                            setState(() {
                              selectedValue_months = value as String;
                            });
                          },
                          iconEnabledColor: mainColor,
                          selectedItemHighlightColor: mainColor,
                          buttonHeight: 60,
                          buttonWidth: 140,
                          itemHeight: 40,
                          dropdownWidth: 140,
                          underline: Container(
                            color: mainColor,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
              RoundedButton(
                  buttonText: 'Next',
                  onPressed: () {
                    (selectedValue_months == null ||
                            selectedValue_years == null ||
                            (selectedValue_months == '0' &&
                                selectedValue_years == '0'))
                        ? showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertBox(
                                titleText: 'Please select the age of your dog!',
                                bodyText:
                                    'You must specify both the years and the months.',
                              );
                            },
                          )
                        : Navigator.pushNamed(context, Question4.id,
                            arguments: {
                                'url': arguments['url'],
                                'list': arguments['list'],
                                'breed': arguments['breed'],
                                'name': arguments['name'],
                                'gender': arguments['gender'],
                                'years': selectedValue_years,
                                'months': selectedValue_months,
                              });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
