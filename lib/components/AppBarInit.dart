import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';

class AppBarInit extends StatelessWidget {
  const AppBarInit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'images/splashscreenimage.png',
        width: 100,
        height: 100,
      ),
      backgroundColor: mainColor,
      toolbarHeight: 70,
      elevation: 5,
      centerTitle: true,
    );
  }
}
