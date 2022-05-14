import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final String titleText;
  final String bodyText;
  AlertBox({required this.titleText, required this.bodyText});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(bodyText),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Ok',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
//
// AlertBox(BuildContext context) {
//   return
// }
