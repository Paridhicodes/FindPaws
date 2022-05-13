import 'package:find_paws_engage/screens/InitialSetup/UploadImage.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/screens/login_signup/login_screen.dart';
import 'package:find_paws_engage/screens/login_signup/signup_screen.dart';
import 'package:find_paws_engage/screens/splash_screen.dart';
import 'package:find_paws_engage/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(findPaws());
}

class findPaws extends StatelessWidget {
  const findPaws({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.dosisTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        UploadImage.id: (context) => UploadImage(),
        Question1.id: (context) => Question1(),
      },
    );
  }
}
