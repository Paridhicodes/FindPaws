import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class GetBreed {
  final String imageLink;
  GetBreed({required this.imageLink});

  String result = '';
  Image? image;

  Future<String> initState() async {
    image = Image.network(imageLink);
    loadModel();
    runModelOnImage();
    await Tflite.close();
    return result;
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  runModelOnImage() async {
    if (image != null) {
      var recognitions = await Tflite.runModelOnImage(
          path: imageLink,
          imageMean: 127.5, // defaults to 117.0
          imageStd: 127.5, // defaults to 1.0
          numResults: 2, // defaults to 5
          threshold: 0.1, // defaults to 0.1
          asynch: true);
      result = '';
      for (var response in recognitions!) {
        result += response['label'] +
            " " +
            (response['confidence'] as double).toStringAsFixed(2) +
            "\n\n";
      }
    }
  }
}
