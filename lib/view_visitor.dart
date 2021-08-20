import 'dart:convert';

import 'package:auto_gate/models/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewVisitor extends StatefulWidget {
  final String uid;

  ViewVisitor(this.uid);
  @override
  _ViewVisitorState createState() => _ViewVisitorState();
}

class _ViewVisitorState extends State<ViewVisitor> {
  DateTime date;
  List names = [], plates = [], datetimes = [], hours = [], status = [];

  bool isRestricted1 = false, isRestricted2 = false, isLoaded = false;
  List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
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

  Future<void> getData() async {
    await Future.delayed(Duration(seconds: 0));
    final map = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
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
          'MY VISITOR(S)',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
        ),
      ),
      body: isLoaded
          ? ListView(
              children: [
                // SizedBox(
                //   height: 32,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Text(
                //     "",
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 13,
                //         fontWeight: FontWeight.w300),
                //   ),
                // ),
                SizedBox(
                  height: 8,
                ),
                for (int x = 0; x < names.length; x++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        child: ListTile(
                            title: Row(
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(4),
                                  elevation: 2,
                                  child: Container(
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
                                        plates[x],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Flexible(
                                  child: Text(
                                    names[x],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Container(
                                margin:
                                    EdgeInsets.only(top: 8, bottom: 8, left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            DateTime.parse(datetimes[x])
                                                .day
                                                .toString()
                                                .padLeft(2, '0'),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            months[DateTime.parse(datetimes[x])
                                                .month],
                                            style: TextStyle(
                                                color: Colors.teal[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            DateTime.parse(datetimes[x]).hour <
                                                    13
                                                ? '${DateTime.parse(datetimes[x]).hour.toString()}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} am'
                                                : '${(DateTime.parse(datetimes[x]).hour - 12).toString()}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} pm',
                                            style: TextStyle(
                                                color: Colors.orange[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.teal,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            DateTime.parse(datetimes[x])
                                                .add(Duration(
                                                    hours: int.parse(hours[x])))
                                                .day
                                                .toString()
                                                .padLeft(2, '0'),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            months[DateTime.parse(datetimes[x])
                                                .add(Duration(
                                                    hours: int.parse(hours[x])))
                                                .month],
                                            style: TextStyle(
                                                color: Colors.teal[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            DateTime.parse(datetimes[x])
                                                        .add(Duration(
                                                            hours: int.parse(
                                                                hours[x])))
                                                        .hour <
                                                    13
                                                ? '${DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).hour.toString()}:${DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).minute.toString().padLeft(2, '0')} am'
                                                : '${(DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).hour - 12).toString()}:${DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).minute.toString().padLeft(2, '0')} pm',
                                            style: TextStyle(
                                                color: Colors.orange[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: status[x] == '0'
                                      ? Colors.grey
                                      : status[x] == '1'
                                          ? Colors.green[300]
                                          : Colors.red[300],
                                  child: Icon(
                                    status[x] == '0'
                                        ? Icons.horizontal_rule
                                        : status[x] == '1'
                                            ? Icons.check_sharp
                                            : Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
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

  _getPastVisitors() {
    firestoreInstance.collection("visitors").get().then((querySnapshot) {
      List allVisitors = querySnapshot.docs;
      print(allVisitors[0]['names'][0]);
      for (int x = 0; x < allVisitors[0]['names'].length; x++) {
        if (widget.uid == allVisitors[0]['uid'][x]) {
          names.add(allVisitors[0]['names'][x]);
          plates.add(allVisitors[0]['plates'][x]);
          datetimes.add(allVisitors[0]['datetimes'][x]);
          hours.add(allVisitors[0]['hours'][x]);
          status.add(allVisitors[0]['status'][x]);
        }
      }
      setState(() {
        isLoaded = true;
      });
    });
  }
}
