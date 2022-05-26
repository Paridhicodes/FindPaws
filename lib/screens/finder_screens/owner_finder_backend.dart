import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:string_extensions/string_extensions.dart';

class OwnerList {
  final double latitude;
  final double longitude;
  final _firestore = FirebaseFirestore.instance;
  final geo = Geoflutterfire();
  final List list;

  List owners = [];
  List breedList = [];
  OwnerList({
    required this.latitude,
    required this.longitude,
    required this.list,
  });

  List initialFunc() {
    fetchRecords();
    print(owners);
    return owners;
  }

  void fetchRecords() async {
    for (var i = 0; i < list.length; i++) {
      String? str = list[i]['label'].toString().toTitleCase;
      breedList.add(str);
    }

    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
    _firestore.collection("pets").where('breed', whereIn: breedList).get().then(
          (res) => {},
          onError: (e) => print("Error completing: $e"),
        );
    var queryRef = _firestore
        .collection('pets')
        .where('lost', isEqualTo: true)
        .where('breed', whereIn: breedList);

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: queryRef)
        .within(center: center, radius: 50, field: 'point');

    stream.listen((List<DocumentSnapshot> documentList) {
      print(documentList.length);

      documentList.forEach((DocumentSnapshot document) {
        owners.add(document);
      });
      for (int i = 0; i < owners.length; i++) {
        print(owners[i].data()['name']);
      }
    });
  }
}
