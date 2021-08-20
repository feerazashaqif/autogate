import 'dart:convert';

import 'package:auto_gate/models/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApplyVisitorPass extends StatefulWidget {
  final String uid;

  ApplyVisitorPass(this.uid);
  @override
  _ApplyVisitorPassState createState() => _ApplyVisitorPassState();
}

class _ApplyVisitorPassState extends State<ApplyVisitorPass> {
  TextEditingController visitorPlate = TextEditingController();
  TextEditingController visitorName = TextEditingController();
  TextEditingController hoursPark = TextEditingController();
  DateTime date;
  List names = [],
      plates = [],
      datetimes = [],
      hours = [],
      status = [],
      phone = [],
      uid = [],
      address = [],
      residentName = [];
  String myAddress = '', myName = '', myPhone = '';

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
          print(myAddress);
          isLoaded = true;
          _getPastVisitors();
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
          'APPLY VISITOR PASS',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
        ),
      ),
      body: isLoaded
          ? ListView(
              children: [
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Please enter your visitor's details to apply for visitor pass.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          "Visitor's Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: visitorName,
                      cursorColor: Colors.indigo,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          borderSide:
                              BorderSide(color: Colors.indigo[100], width: 4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          borderSide:
                              BorderSide(color: Colors.indigo[200], width: 2),
                        ),
                        hintText: 'John Doe',
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          "Visitor's Plate Number",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: visitorPlate,
                      cursorColor: Colors.indigo,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          borderSide:
                              BorderSide(color: Colors.indigo[100], width: 4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          borderSide:
                              BorderSide(color: Colors.indigo[200], width: 2),
                        ),
                        hintText: 'WWW 1234',
                      ),
                    )),
                SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          "  Date  ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ))),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '  ${date.day} ${months[date.month]} ${date.year}',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          "  Time  ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ))),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          date.hour < 13
                              ? '  ${date.hour.toString().padLeft(2, '0')} : ${date.minute.toString().padLeft(2, '0')} am'
                              : '  ${(date.hour - 12).toString().padLeft(2, '0')} : ${date.minute.toString().padLeft(2, '0')} pm',
                          style: TextStyle(color: Colors.black87),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          "Visitor's Parking Hour(s)",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: hoursPark,
                      cursorColor: Colors.indigo,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          borderSide:
                              BorderSide(color: Colors.indigo[100], width: 4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          borderSide:
                              BorderSide(color: Colors.indigo[200], width: 2),
                        ),
                        hintText: '1',
                      ),
                    )),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "*Note that the visitor pass need to be approved by the management before your visitors can enter the premise.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveVisitorApplication();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange[400]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(16))),
                      ),
                      child: Text(
                        'Submit to Management',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
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

  _getPastVisitors() {
    firestoreInstance
        .collection("visitors")
        .doc("allVisitors")
        .get()
        .then((querySnapshot) {
      print(querySnapshot.data());

      names = querySnapshot.get('names');
      plates = querySnapshot.get('plates');
      datetimes = querySnapshot.get('datetimes');
      hours = querySnapshot.get('hours');
      status = querySnapshot.get('status');
      uid = querySnapshot.get('uid');
      address = querySnapshot.get('address');
      residentName = querySnapshot.get('residentName');
      phone = querySnapshot.get('phone');
      print(names);
      print(plates);
      print(datetimes);
      print(hours);
      print(status);
    });
  }

  _saveVisitorApplication() {
    names.add(visitorName.text);
    plates.add(visitorPlate.text);
    datetimes.add(date.toString());
    hours.add(hoursPark.text);
    status.add('0');
    uid.add(widget.uid);
    address.add(myAddress);
    residentName.add(myName);
    phone.add(myPhone);

    firestoreInstance.collection("visitors").doc('allVisitors').update({
      "names": names,
      "plates": plates,
      "datetimes": datetimes,
      "hours": hours,
      "status": status,
      "uid": uid,
      "address": address,
      "residentName": residentName,
      "phone": phone
    }).then((value) {
      // print(value.documentID);
      Fluttertoast.showToast(
          msg: "Application Submitted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal[300],
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      print('Success');
    });
  }
}
