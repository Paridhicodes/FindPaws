import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:string_extensions/string_extensions.dart';

import 'FinderDetails.dart';

class OwnerList {
  final double latitude;
  final double longitude;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final geo = Geoflutterfire();
  final List list;
  // final User loggedInUser;
  // final String userId;
  // required this.loggedInUser,
  // required this.userId
  List owners = [];
  List breedList = [];
  OwnerList({
    required this.latitude,
    required this.longitude,
    required this.list,
  });

  List initialFunc() {
    // print(loggedInUser);
    fetchRecords();
    return owners;
  }

  void fetchRecords() {
    print(latitude);
    for (var i = 0; i < list.length; i++) {
      String? str = list[i]['label'].toString().toTitleCase;
      breedList.add(str);
    }
    // print(breedList);
    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
    _firestore.collection("pets").where('breed', whereIn: breedList).get().then(
          (res) => print(res.toString()),
          onError: (e) => print("Error completing: $e"),
        );
    var queryRef = _firestore
        .collection('pets')
        .where('lost', isEqualTo: true)
        .where('breed', whereIn: breedList);
    // .;

    // print(queryRef);
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: queryRef)
        .within(center: center, radius: 50, field: 'point');
    print(stream);
    stream.listen((List<DocumentSnapshot> documentList) {
      // doSomething()
      print(documentList.length);

      documentList.forEach((DocumentSnapshot document) {
        print(document.data());
      });
    });
  }
}

//
