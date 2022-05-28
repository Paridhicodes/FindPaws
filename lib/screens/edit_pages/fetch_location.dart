import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_paws_engage/screens/InitialSetup/questions/question2.dart';
import 'package:find_paws_engage/screens/owner_core/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:find_paws_engage/components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:find_paws_engage/components/AppBarInit.dart';
import 'dart:io';
import 'dart:async';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:find_paws_engage/components/AlertBox.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:find_paws_engage/components/CardLayout.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FetchLocation extends StatefulWidget {
  static const String id = "lost_dog";
  const FetchLocation({Key? key}) : super(key: key);

  @override
  _FetchLocationState createState() => _FetchLocationState();
}

class _FetchLocationState extends State<FetchLocation> {
  GoogleMapController? _controller;
  Location currentLocation = Location();
  final _firestore = FirebaseFirestore.instance;
  Set<Marker> _markers = {};
  double currLat = 48.8561;
  double currLong = 2.2930;
  final geo = Geoflutterfire();

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    setState(() {
      getLocation();
    });
  }

  void getLocation() async {
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller
          ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));

      if (!mounted) return;
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
        currLat = loc.latitude!;
        currLong = loc.longitude!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    // print(arguments['doc_id']);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarInit(),
            Stack(
              fit: StackFit.loose,
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(48.8561, 2.2930),
                        zoom: 12.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      markers: _markers,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: FloatingActionButton(
                      backgroundColor: mainColor,
                      child: Icon(
                        Icons.location_searching,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getLocation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.0,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                        child: Center(
                          child: Text(
                            'Latitude',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      subtitle: UnconstrainedBox(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$currLat',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ), // <-- Text
                                SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: mainColor,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50.0,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                        child: Center(
                          child: Text(
                            'Longitude',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      subtitle: UnconstrainedBox(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$currLong',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ), // <-- Text
                                SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: mainColor,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: RoundedButton(
                onPressed: () {
                  GeoFirePoint myLocation =
                      geo.point(latitude: currLat, longitude: currLong);
                  _firestore
                      .collection('pets')
                      .doc(arguments['doc_id'])
                      .update({'point': myLocation.data});
                  Navigator.pop(context);
                },
                buttonText: 'Done',
                textSize: 18,
                buttonSize: 120,
              ),
            )
          ],
        ),
      ),
    );
  }
}
