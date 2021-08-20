import 'dart:convert';

import 'package:auto_gate/models/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewRecord extends StatefulWidget {
  final String uid;

  ViewRecord(this.uid);
  @override
  _ViewRecordState createState() => _ViewRecordState();
}

class _ViewRecordState extends State<ViewRecord> {
  TextEditingController visitorPlate = TextEditingController();
  TextEditingController visitorName = TextEditingController();
  TextEditingController hoursPark = TextEditingController();
  DateTime date;
  List plates = [], datetimes = [], status = [], uid = [];
  String myAddress = '',
      myName = '',
      myPhone = '',
      myPlate1 = '',
      myPlate2 = '';

  bool isRestricted1 = false, isRestricted2 = false, isLoaded = false;
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
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          myAddress = documentSnapshot['address'];
          myName = documentSnapshot['name'];
          myPhone = documentSnapshot['phone'];
          myPlate1 = documentSnapshot['plate1'];
          myPlate2 = documentSnapshot['plate2'];
          print(myAddress);
          _getActivity();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          'Entry/Exit Record',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
        ),
      ),
      body: isLoaded
          ? Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  color: Colors.teal[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 60,
                        child: Center(
                          child: Text(
                            'Plate No',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 60,
                        child: Center(
                          child: Text(
                            'Date',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 60,
                        child: Center(
                          child: Text(
                            'Time',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 60,
                        child: Center(
                          child: Text(
                            'Status',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 153,
                  child: ListView(
                    children: [
                      for (int index = status.length - 1; index >= 0; index--)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(4),
                                elevation: 2,
                                child: Container(
                                  height: 20,
                                  width: 80,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      plates[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width / 4 +15,
                              //   height: 60,
                              //   child: Center(
                              //     child: Text(
                              //       plates[index],
                              //       style: TextStyle(
                              //           color: Colors.white,
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w400),
                              //       textAlign: TextAlign.center,
                              //     ),
                              //   ),
                              // ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 4 - 10,
                                height: 60,
                                child: Center(
                                  child: Text(
                                    '${(DateTime.parse(datetimes[index]).day).toString().padLeft(2, '0')} ${(DateTime.parse(datetimes[index]).month).toString().padLeft(2, '0')} ${(DateTime.parse(datetimes[index]).year)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 4 - 10,
                                height: 60,
                                child: Center(
                                  child: Text(
                                    DateTime.parse(datetimes[index]).hour == 0
                                        ? '${(DateTime.parse(datetimes[index]).hour + 12).toString().padLeft(2, '0')}:${(DateTime.parse(datetimes[index]).minute).toString().padLeft(2, '0')} am'
                                        : DateTime.parse(datetimes[index])
                                                    .hour >
                                                11
                                            ? '${(DateTime.parse(datetimes[index]).hour).toString().padLeft(2, '0')}:${(DateTime.parse(datetimes[index]).minute).toString().padLeft(2, '0')} pm'
                                            : '${(DateTime.parse(datetimes[index]).hour).toString().padLeft(2, '0')}:${(DateTime.parse(datetimes[index]).minute).toString().padLeft(2, '0')} am',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4 -
                                      15,
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      status[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 2)),
    );
    if (picked != null && picked != date)
      setState(() {
        date = DateTime(
            picked.year, picked.month, picked.day, date.hour, date.minute);
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    setState(() {
      date =
          DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
    });
  }

  _getActivity() {
    firestoreInstance
        .collection("gates")
        .doc("gate1")
        .get()
        .then((querySnapshot) {
      print(querySnapshot.get('status'));
      var platesRaw = querySnapshot.get('plateNo');
      var datetimesRaw = querySnapshot.get('datetime');
      var statusRaw = querySnapshot.get('status');
      var uidRaw = querySnapshot.get('id');
      for (int x = 0; x < uidRaw.length; x++) {
        plates.add(platesRaw[x]);
        datetimes.add(datetimesRaw[x]);
        uid.add(uidRaw[x]);
        status.add(statusRaw[x]);
      }
      setState(() {
        isLoaded = true;
      });
    });
  }
}
