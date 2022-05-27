import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/display_breed.dart';

import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/screens/finder_screens/FinderChecklist.dart';
import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
import 'package:find_paws_engage/screens/welcome_screen.dart';
import 'package:find_paws_engage/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/AlertBox.dart';
import 'finder_home_upload.dart';
import 'package:http/http.dart' as http;

class FoundOwners extends StatefulWidget {
  static const String id = "found_owners";
  const FoundOwners({Key? key}) : super(key: key);

  @override
  _FoundOwnersState createState() => _FoundOwnersState();
}

class _FoundOwnersState extends State<FoundOwners> {
  bool permissionTaken = false;
  bool allowed = false;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    // print(arguments['owner_list']);

    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                color: mainColor,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: TextButton(
                      child: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, WelcomeScreen.id);
                      }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your matches',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'findPAWS gas suggested these matches. Please select the one which appears closest to the dog with you.',
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (arguments['owner_list'].length == 0)
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                      child: Center(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 300,
                                width: 300,
                                child: Image.asset('images/no_results.jpg'),
                              ),
                            ),
                            const Text(
                              'No owners found!',
                              style: TextStyle(
                                fontSize: 25,
                                color: mainColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                    child: Container(
                      child: renderList(arguments['owner_list'], arguments),
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  Widget renderList(List documentList, var arguments) {
    List<Widget> ls = [];
    // List counter = [];
    // for (int i = 0; i < documentList.length; i++) {
    //   counter.add(1);
    // }
    for (int i = 0; i < documentList.length; i++) {
      ls.add(Padding(
        padding: const EdgeInsets.all(30.0),
        child: Card(
          elevation: 10,
          shadowColor: Colors.black,
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.60,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 2 * MediaQuery.of(context).size.width / 3,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(documentList[i]['image_url']),
                        ),
                      ),
                    ), // Container(
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 15, 7, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(documentList[i]['breed']),
                        Text(
                            '${documentList[i]['age_years']} yrs  ${documentList[i]['age_months']} mon'),
                        Icon(
                          documentList[i]['gender'] == 'Male'
                              ? Icons.male
                              : Icons.female,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    documentList[i]['name'],
                    style: const TextStyle(
                      fontSize: 23,
                      color: mainColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      String ownerName = '';
                      String ownerMail = '';

                      var docRef = _firestore
                          .collection('details')
                          .doc(documentList[i]['owner_id']);
                      await docRef.get().then(
                        (DocumentSnapshot doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          String tempownerName = data['Name'];
                          String tempownerMail = data['Email'];
                          setState(() {
                            ownerName = tempownerName;
                            ownerMail = tempownerMail;
                          });
                        },
                        onError: (e) => print("Error getting document: $e"),
                      );

                      if (!permissionTaken) {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sharing of Details '),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          'Please confirm that you agree to share your contact details with the potential pet owner and the findPaws team.'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: mainColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        permissionTaken = true;
                                      });
                                      Navigator.of(context).pop();
                                      sendEmail(
                                        toEmail: ownerMail,
                                        dogName: documentList[i]['name'],
                                        ownerName: ownerName,
                                        finderName: arguments['finder_name'],
                                        finderEmail: arguments['finder_email'],
                                        finderPhone: arguments['finder_phone'],
                                        imageURL: arguments['url'],
                                      );
                                    },
                                  ),
                                ],
                              );
                            });
                      }

                      if (permissionTaken) {
                        sendEmail(
                          toEmail: ownerMail,
                          dogName: documentList[i]['name'],
                          ownerName: ownerName,
                          finderName: arguments['finder_name'],
                          finderEmail: arguments['finder_email'],
                          finderPhone: arguments['finder_phone'],
                          imageURL: arguments['url'],
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xff88c0b5),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'CONTACT OWNER',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return Column(
      children: ls,
    );
  }

  Future sendEmail(
      {required String toEmail,
      required String dogName,
      required String ownerName,
      required String finderName,
      required String finderEmail,
      required String finderPhone,
      required String imageURL}) async {
    final serviceId = 'service_m1sf9mp';
    final templateId = 'template_4bix1bl';
    final userId = 'Y7zUyqa2qK1ZL2Kzy';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_email': toEmail,
          'to_name': ownerName,
          'dog_name': dogName,
          'finder_name': finderName,
          'finder_email': finderEmail,
          'finder_phone': finderPhone,
          'image_url': imageURL,
        }
      }),
    );

    if (response.body == 'OK') {
      final snackBar = SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 17,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Mail Sent!',
              style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                fontSize: 15,
              )),
            )
          ],
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.cancel_outlined,
              size: 17,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Error Occurred!',
              style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                fontSize: 15,
              )),
            )
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
