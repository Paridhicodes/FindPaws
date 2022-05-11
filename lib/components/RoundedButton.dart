import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  RoundedButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      color: mainColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          this.buttonText,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      minWidth: 150,
      elevation: 5.0,
    );
  }
}
