// import 'package:find_paws_engage/components/AppBarInit.dart';
// import 'package:find_paws_engage/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite/tflite.dart';
// import 'package:cupertino_icons/cupertino_icons.dart';
// import '../../main.dart';
//
// class FinderHome extends StatefulWidget {
//   static const String id = "finder_home_screen";
//
//   const FinderHome({Key? key}) : super(key: key);
//
//   @override
//   _FinderHomeState createState() => _FinderHomeState();
// }
//
// class _FinderHomeState extends State<FinderHome> {
//   bool isWorking = false;
//   String result = '';
//   late CameraController cameraController;
//   CameraImage? imgCamera;
//
//   initCamera() {
//     cameraController = CameraController(cameras![0], ResolutionPreset.medium);
//
//     cameraController.initialize().then((value) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         cameraController.startImageStream(
//           (imageFromStream) => {
//             if (!isWorking)
//               {
//                 isWorking = true,
//                 imgCamera = imageFromStream,
//                 runModelOnStreamFrames(),
//               }
//           },
//         );
//       });
//     });
//   }
//
//   loadModel() async {
//     await Tflite.loadModel(
//         model: 'assets/model.tflite', labels: 'assets/labels.txt');
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initCamera();
//     loadModel();
//   }
//
//   runModelOnStreamFrames() async {
//     print(imgCamera);
//     if (imgCamera != null) {
//       var recognitions = await Tflite.runModelOnFrame(
//         bytesList: imgCamera!.planes.map((plane) {
//           print(plane);
//           return plane.bytes;
//         }).toList(),
//         imageHeight: imgCamera!.height,
//         imageWidth: imgCamera!.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         rotation: 90,
//         numResults: 2,
//         threshold: 0.1,
//         asynch: true,
//       );
//       print(recognitions);
//       result = '';
//       recognitions!.forEach((response) {
//         result += response['label'] +
//             " " +
//             (response['confidence'] as double).toStringAsFixed(2) +
//             "\n\n";
//       });
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         result;
//         print(result);
//       });
//       isWorking = false;
//     }
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//
//     cameraController.dispose();
//
//     // await Tflite.close();
//     print('disposed');
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(children: [
//       AppBarInit(),
//       Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.7,
//               width: MediaQuery.of(context).size.width,
//               child: !cameraController!.value.isInitialized
//                   ? Container()
//                   : AspectRatio(
//                       aspectRatio: cameraController!.value.aspectRatio,
//                       child: CameraPreview(cameraController!),
//                     ),
//             ),
//           ),
//           Text(result),
//         ],
//       )
//     ]));
//   }
// // Stack(
// //   children: [
// //     Center(
// //       child: Container(
// //         height: 320.0,
// //         width: 360.0,
// //         child: Image.asset('images/camera_bordered.png'),
// //       ),
// //     ),
// //     Center(
// //       child: TextButton(
// //         onPressed: () {
// //           initCamera();
// //         },
// //         child: Container(
// //           margin: EdgeInsets.only(top: 35.0),
// //           height: 230.0,
// //           width: 360.0,
// //           child: imgCamera == null
// //               ? Container(
// //                   height: 200.0,
// //                   width: 360.0,
// //                   child: Icon(
// //                     Icons.camera_enhance_outlined,
// //                     color: mainColor,
// //                     size: 40.0,
// //                   ),
// //                 )
// //               : AspectRatio(
// //                   aspectRatio:
// //                       cameraController!.value.aspectRatio,
// //                   child: CameraPreview(cameraController!),
// //                 ),
// //         ),
// //       ),
// //     )
// //   ],
// // ),
// // Center(
// //     child: Container(
// //   margin: EdgeInsets.only(top: 55.0),
// //   child: SingleChildScrollView(
// //     child: Text(
// //       result,
// //       style: TextStyle(
// //           backgroundColor: mainColor,
// //           fontSize: 25.0,
// //           color: Colors.black),
// //       textAlign: TextAlign.center,
// //     ),
// //   ),
// // ))
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
// }
