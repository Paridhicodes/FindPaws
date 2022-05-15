// import 'package:flutter/material.dart';
// import 'package:find_paws_engage/get_breed.dart';
//
// class DisplayBreed extends StatefulWidget {
//   // final String imageLink;
//   static const String id = "display_breed";
//   // const DisplayBreed({required this.imageLink});
//
//   @override
//   _DisplayBreedState createState() => _DisplayBreedState();
// }
//
// class _DisplayBreedState extends State<DisplayBreed> {
//   @override
//   late String breedResult = '';
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(breedResult),
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     call_get_breed();
//   }
//
//   void call_get_breed() async {
//     print('entered');
//     GetBreed _getBreed = GetBreed(imageLink: 'images/image1.jpeg');
//     breedResult = await _getBreed.initialFunc();
//   }
// }
