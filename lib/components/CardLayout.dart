import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:card_swiper/card_swiper.dart';

class CardLayout extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final String imageLink;
  final String mainText;
  final String subText;

  CardLayout(
      {required this.buttonText,
      required this.onPressed,
      required this.imageLink,
      required this.mainText,
      required this.subText});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black,
      color: Colors.white,
      child: SizedBox(
        width: 250,
        height: 390,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //CircleAvatar
              //SizedBox
              //Text
              SizedBox(
                height: 10,
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(imageLink),
                    ),
                  ),
                ), // Container(
              ), //Text
              SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: Text(mainText,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        )),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subText,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: onPressed,
                color: mainColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minWidth: 150,
                elevation: 5.0,
              )
            ],
          ), //Column
        ), //Padding
      ),
    );
  }
}
