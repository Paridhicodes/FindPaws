import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:find_paws_engage/get_breed.dart';
import 'package:find_paws_engage/get_dog_cat.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/display_breed.dart';
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

class FinderDetails extends StatefulWidget {
  static const String id = "finder_details";
  const FinderDetails({Key? key}) : super(key: key);

  @override
  _FinderDetailsState createState() => _FinderDetailsState();
}

class _FinderDetailsState extends State<FinderDetails> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(arguments['lat']);
    print(arguments['long']);
    return Scaffold();
  }
}
