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
      body: SingleChildScrollView(
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
                SizedBox(
                  height: 98.0,
                ),
                AppButton(
                  buttonText: "Join Us",
                    onPressed: () => Navigator.pushNamed(context, RegisterScreen.id),
                ),
                SizedBox(
                  height: 20,
                ),
                AppButton(
                  buttonText: "I've found a lost pet",
                  onPressed: () {
                    print("Found");
                  },
                ),
                SizedBox(
                  height: 110,
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                  child: Text(
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
    );
  }
}
