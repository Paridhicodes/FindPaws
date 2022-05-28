import 'package:find_paws_engage/screens/finder_screens/finder_home_upload.dart';
import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:find_paws_engage/components/AppButton.dart';

import 'login_signup/login_screen.dart';
import 'login_signup/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'images/splashscreenimage.png',
                        width: 250,
                        height: 250,
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 210),
                          child: Text(
                            "find PAWS",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'OleoScript',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 98.0,
                  ),
                  AppButton(
                    buttonText: "Join Us",
                    onPressed: () =>
                        Navigator.pushNamed(context, RegisterScreen.id),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    buttonText: "I've found a lost dog",
                    onPressed: () {
                      Navigator.pushNamed(context, FinderUpload.id);
                    },
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, LoginScreen.id),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
