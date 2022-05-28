import 'package:find_paws_engage/screens/InitialSetup/UploadImage.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/display_breed.dart';

import 'package:find_paws_engage/screens/InitialSetup/questions/question1.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question3.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question4.dart';
import 'package:find_paws_engage/screens/edit_pages/dog_profile_edit.dart';
import 'package:find_paws_engage/screens/edit_pages/fetch_location.dart';
import 'package:find_paws_engage/screens/edit_pages/user_profile_edit.dart';
import 'package:find_paws_engage/screens/finder_screens/FinderChecklist.dart';
import 'package:find_paws_engage/screens/finder_screens/FinderDetails.dart';
import 'package:find_paws_engage/screens/finder_screens/FoundOwners.dart';

import 'package:find_paws_engage/screens/finder_screens/finder_home_upload.dart';
import 'package:find_paws_engage/screens/login_signup/login_screen.dart';
import 'package:find_paws_engage/screens/login_signup/signup_screen.dart';

import 'package:find_paws_engage/screens/owner_core/LostDogCheck.dart';
import 'package:find_paws_engage/screens/owner_core/MyDogsScreen.dart';
import 'package:find_paws_engage/screens/owner_core/about_us.dart';
import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
import 'package:find_paws_engage/screens/owner_core/near_me.dart';
import 'package:find_paws_engage/screens/splash_screen.dart';
import 'package:find_paws_engage/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();
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
        Question2.id: (context) => Question2(),
        Question3.id: (context) => Question3(),
        Question4.id: (context) => Question4(),
        DisplayBreed.id: (context) => DisplayBreed(),
        HomeScreen.id: (context) => HomeScreen(),
        DogProfileEdit.id: (context) => DogProfileEdit(),
        MyDogsScreen.id: (context) => MyDogsScreen(),
        UserProfile.id: (context) => UserProfile(),
        FetchLocation.id: (context) => FetchLocation(),
        LostDogCheck.id: (context) => LostDogCheck(),
        FinderUpload.id: (context) => FinderUpload(),
        FinderCheckList.id: (context) => FinderCheckList(),
        FinderDetails.id: (context) => FinderDetails(),
        FoundOwners.id: (context) => FoundOwners(),
        AboutUs.id: (context) => AboutUs(),
        NearMe.id: (context) => NearMe(),
        // FinderHome.id: (context) => FinderHome(),
        // DisplayBreed.id: (context) => DisplayBreed(),
      },
    );
  }
}
