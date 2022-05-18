import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  AppButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          this.buttonText,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      color: Colors.white,
      minWidth: 250,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
