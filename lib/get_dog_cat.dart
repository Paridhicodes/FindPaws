import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class GetDogCat {
  final String imageLink;
  GetDogCat({required this.imageLink});

  List _recognitions = [];

  Future<List> initialFunc() async {
    loadModel();
    await recognizeImage(imageLink);

    return _recognitions;
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/catdog_model.tflite',
        labels: 'assets/cat_dog_labels.txt');
  }

  Future recognizeImage(String imageLink) async {
    var recognitions = await Tflite.runModelOnImage(
      path: imageLink,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (recognitions != null) {
      _recognitions = recognitions;
      // print(recognitions);
    }
  }
}
