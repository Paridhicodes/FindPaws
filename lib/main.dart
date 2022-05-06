import 'package:find_paws_engage/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(findPaws());
}

class findPaws extends StatelessWidget {
  const findPaws({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {SplashScreen.id: (context) => SplashScreen()},
    );
  }
}
