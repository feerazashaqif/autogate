import 'dart:convert';
import 'package:map_launcher/map_launcher.dart';
import 'package:auto_gate/models/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAlert extends StatefulWidget {
  final String uid;

  ViewAlert(this.uid);
  @override
  _ViewAlertState createState() => _ViewAlertState();
}

class _ViewAlertState extends State<ViewAlert> {
  DateTime date;
  List names = [], datetimes = [], uids = [], latitudes = [], longitudes = [];
  bool isLoaded = false;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<Visitor> visitors = [];
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> getCurrentUID() async {
    return (_auth.currentUser.uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateTime.now();
    getData();
  }

  // Future getData() async {
  //   var document =
  //       FirebaseFirestore.instance.collection('users').doc(widget.uid);
  //   document.get().then((value) {
  //     plate1 = value.data()['plate1'];
  //     print(plate1);
  //   });
  // }

  Future<void> getData() async {
    await Future.delayed(Duration(seconds: 0));
    final map = await FirebaseFirestore.instance
        .collection('alerts')
        .doc('all')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          names = documentSnapshot['name'];
          datetimes = documentSnapshot['datetime'];
          uids = documentSnapshot['uid'];
          latitudes = documentSnapshot['latitude'];
          longitudes = documentSnapshot['longitude'];

          setState(() {
            isLoaded = true;
          });
        });
      }
    });
  }

  openMapsSheet(context, lat, lng, name) async {
    try {
      final coords = Coords(lat, lng);
      final title = "$name's location";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURL(double lat, double lon) async => await canLaunch(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lon')
      ? await launch(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lon')
      : throw 'Could not launch the url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          'Panic Alert List',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
        ),
      ),
      body: isLoaded
          ? ListView(
              children: [
                for (int x = names.length-1; x >=0 ; x--)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(latitudes[x], longitudes[x]);
                        //_launchMapsUrl(latitudes[x], longitudes[x]);
                        // openMapsSheet(
                        //     context, latitudes[x], longitudes[x], names[x]);
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.white,
                        child: ListTile(
                          leading: Column(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 30,
                                color: Colors.red,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Go here',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              )
                            ],
                          ),
                          title: Text(
                            names[x],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                          ),
                          subtitle: Text(
                            DateTime.parse(datetimes[x]).hour < 12
                                ? "${DateTime.parse(datetimes[x]).hour.toString().padLeft(2, '0')}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} am on ${DateTime.parse(datetimes[x]).day.toString().padLeft(2, '0')} ${months[DateTime.parse(datetimes[x]).month - 1]} ${DateTime.parse(datetimes[x]).year.toString()}"
                                : DateTime.parse(datetimes[x]).hour == 12
                                    ? "${DateTime.parse(datetimes[x]).hour.toString().padLeft(2, '0')}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} pm on ${DateTime.parse(datetimes[x]).day.toString().padLeft(2, '0')} ${months[DateTime.parse(datetimes[x]).month - 1]} ${DateTime.parse(datetimes[x]).year.toString()}"
                                    : "${(DateTime.parse(datetimes[x]).hour - 12).toString().padLeft(2, '0')}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} pm on ${DateTime.parse(datetimes[x]).day.toString().padLeft(2, '0')} ${months[DateTime.parse(datetimes[x]).month - 1]} ${DateTime.parse(datetimes[x]).year.toString()}",
                            style:
                                TextStyle(fontSize: 14, color: Colors.orange),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[100]),
              ),
            ),
    );
  }
}
