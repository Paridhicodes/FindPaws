import 'package:flutter/material.dart';
import 'package:find_paws_engage/get_breed.dart';

class DisplayBreed extends StatefulWidget {
  final String imageLink;
  static const String id = "display_breed";
  const DisplayBreed({required this.imageLink});

  @override
  _DisplayBreedState createState() => _DisplayBreedState();
}

class _DisplayBreedState extends State<DisplayBreed> {
  @override
  late String breedResult;
  Widget build(BuildContext context) {
    return Container(
      child: Text(breedResult),
    );
  }

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    GetBreed _getBreed = GetBreed(imageLink: widget.imageLink);
    breedResult = await _getBreed.initState() as String;
  }
}
