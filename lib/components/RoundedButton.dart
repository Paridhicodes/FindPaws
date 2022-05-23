import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  double textSize = 25;
  double buttonSize = 150;
  RoundedButton(
      {required this.buttonText,
      required this.onPressed,
      this.textSize = 25,
      this.buttonSize = 150});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      color: mainColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          this.buttonText,
          style: TextStyle(color: Colors.white, fontSize: textSize),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      minWidth: buttonSize,
      elevation: 5.0,
    );
  }
}
