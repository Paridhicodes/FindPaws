import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../components/AppBarInit.dart';
import '../../constants.dart';

class NearMe extends StatefulWidget {
  static const String id = "near me";
  const NearMe({Key? key}) : super(key: key);

  @override
  _NearMeState createState() => _NearMeState();
}

class _NearMeState extends State<NearMe> {
  List lostpets = [];
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  double _currlat = 0;
  double _currlong = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) {
      setState(() {
        _currlat = value.latitude;
        _currlong = value.longitude;
      });
      print(value);
      fetchRecords(_currlat, _currlong);
    });
  }

  void fetchRecords(double lat, double long) {
    List tempowners = [];

    GeoFirePoint center = geo.point(latitude: lat, longitude: long);

    var queryRef = _firestore.collection('pets').where('lost', isEqualTo: true);

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: queryRef)
        .within(center: center, radius: 50, field: 'point');

    stream.listen((List<DocumentSnapshot> documentList) async {
      final response = await documentList;
      documentList.forEach((DocumentSnapshot document) {
        tempowners.add(document);
        // print(document.data());
      });

      setState(() {
        lostpets = tempowners;
        // print(lostpets);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarInit(),
              (lostpets.length == 0)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Lost Pets Near You',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: renderList(),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget renderList() {
    List<Widget> ls = [];

    for (int i = 0; i < lostpets.length; i++) {
      ls.add(Padding(
        padding: const EdgeInsets.all(30.0),
        child: Card(
          elevation: 10,
          shadowColor: Colors.black,
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.50,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 2 * MediaQuery.of(context).size.width / 3,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(lostpets[i]['image_url']),
                        ),
                      ),
                    ), // Container(
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 15, 7, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lostpets[i]['breed']),
                        Text(
                            '${lostpets[i]['age_years']} yrs  ${lostpets[i]['age_months']} mon'),
                        Icon(
                          lostpets[i]['gender'] == 'Male'
                              ? Icons.male
                              : Icons.female,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    lostpets[i]['name'],
                    style: const TextStyle(
                      fontSize: 23,
                      color: mainColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return Column(
      children: ls,
    );
  }
}
