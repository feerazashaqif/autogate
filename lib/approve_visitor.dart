import 'dart:convert';

import 'package:auto_gate/models/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class ApproveVisitor extends StatefulWidget {
  final String uid;

  ApproveVisitor(this.uid);
  @override
  _ApproveVisitorState createState() => _ApproveVisitorState();
}

class _ApproveVisitorState extends State<ApproveVisitor>
    with SingleTickerProviderStateMixin {
  DateTime date;
  List names = [],
      plates = [],
      datetimes = [],
      address = [],
      phone = [],
      hours = [],
      uid = [],
      status = [],
      owner = [],
      statusAll = [],
      array = [];
  List namesBlocked = [],
      platesBlocked = [],
      datetimesBlocked = [],
      addressBlocked = [],
      phoneBlocked = [],
      hoursBlocked = [],
      uidBlocked = [],
      statusBlocked = [],
      ownerBlocked = [],
      arrayBlocked = [];
  List namesPending = [],
      platesPending = [],
      datetimesPending = [],
      addressPending = [],
      phonePending = [],
      uidPending = [],
      hoursPending = [],
      statusPending = [],
      ownerPending = [],
      arrayPending = [];
  String adminPlace = '';
  List docs;
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
  TabController _controller;
  int _selectedIndex = 0;

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
    names = [];
    namesPending = [];
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
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
        adminPlace = documentSnapshot.data()['place'];
        print(adminPlace);
        setState(() {
          _getVisitorData();
        });
      }
    });
  }

  TabBar get _tabBar => TabBar(
        overlayColor: MaterialStateProperty.all(Colors.teal[300]),
        indicatorColor: Colors.white,
        indicatorWeight: 4,
        labelStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        controller: _controller,
        onTap: (index) {
          // Tab index when user select it, it start from zero
        },
        tabs: [
          Tab(
            icon: Icon(Icons.pending),
            text: 'Pending',
          ),
          Tab(
            icon: Icon(Icons.check_circle),
            text: 'Confirmed',
          ),
          Tab(
            icon: Icon(Icons.delete),
            text: 'Deleted/Blocked',
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: ColoredBox(color: Colors.teal[600], child: _tabBar),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          'APPROVE VISITORS',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
        ),
      ),
      body: isLoaded
          ? TabBarView(controller: _controller, children: [
              namesPending.length == 0 || namesPending.length == null
                  ? Center(
                      child: Text('No data',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300)))
                  : ListView(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        for (int x = 0; x < namesPending.length; x++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Material(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(16)),
                                  elevation: 2,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width -
                                        16 -
                                        60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(16)),
                                        color: Colors.white),
                                    child: ListTile(
                                      isThreeLine: true,
                                      contentPadding: EdgeInsets.only(
                                        left: 8,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      title: Row(
                                        children: [
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            elevation: 2,
                                            child: Container(
                                              width: 80,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  platesPending[x],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Text(
                                              namesPending[x],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateTime.parse(
                                                              datetimesPending[
                                                                  x])
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      months[DateTime.parse(
                                                              datetimesPending[
                                                                  x])
                                                          .month],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      DateTime.parse(datetimesPending[
                                                                      x])
                                                                  .hour <
                                                              13
                                                          ? '${DateTime.parse(datetimesPending[x]).hour.toString()}:${DateTime.parse(datetimesPending[x]).minute.toString().padLeft(2, '0')} am'
                                                          : '${(DateTime.parse(datetimesPending[x]).hour - 12).toString()}:${DateTime.parse(datetimesPending[x]).minute.toString().padLeft(2, '0')} pm',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateTime.parse(
                                                              datetimesPending[
                                                                  x])
                                                          .add(Duration(
                                                              hours: int.parse(
                                                                  hoursPending[
                                                                      x])))
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      months[DateTime.parse(
                                                              datetimesPending[
                                                                  x])
                                                          .add(Duration(
                                                              hours: int.parse(
                                                                  hoursPending[
                                                                      x])))
                                                          .month],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      DateTime.parse(datetimesPending[
                                                                      x])
                                                                  .add(Duration(
                                                                      hours: int
                                                                          .parse(
                                                                              hoursPending[x])))
                                                                  .hour <
                                                              13
                                                          ? '${DateTime.parse(datetimesPending[x]).add(Duration(hours: int.parse(hoursPending[x]))).hour.toString()}:${DateTime.parse(datetimesPending[x]).add(Duration(hours: int.parse(hoursPending[x]))).minute.toString().padLeft(2, '0')} am'
                                                          : '${(DateTime.parse(datetimesPending[x]).add(Duration(hours: int.parse(hoursPending[x]))).hour - 12).toString()}:${DateTime.parse(datetimesPending[x]).add(Duration(hours: int.parse(hoursPending[x]))).minute.toString().padLeft(2, '0')} pm',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                ownerPending[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                addressPending[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                phonePending[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 182,
                                  width: 60,
                                  child: Column(
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            statusAll[arrayPending[x]] = '2';
                                            FirebaseFirestore.instance
                                                .collection('visitors')
                                                .doc('allVisitors')
                                                .update({
                                              "status": statusAll
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ApproveVisitor(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16)),
                                          child: Container(
                                            height: 91,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(16))),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            statusAll[arrayPending[x]] = '1';
                                            FirebaseFirestore.instance
                                                .collection('visitors')
                                                .doc('allVisitors')
                                                .update({
                                              "status": statusAll
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ApproveVisitor(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(16)),
                                          child: Container(
                                            height: 91,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(16))),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
              names.length == 0 || names.length == null
                  ? Center(
                      child: Text('No data',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300)))
                  : ListView(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        for (int x = 0; x < names.length; x++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Material(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(16)),
                                  elevation: 2,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width -
                                        16 -
                                        60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(16)),
                                        color: Colors.white),
                                    child: ListTile(
                                      isThreeLine: true,
                                      contentPadding: EdgeInsets.only(
                                        left: 8,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      title: Row(
                                        children: [
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            elevation: 2,
                                            child: Container(
                                              width: 80,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10),
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
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateTime.parse(
                                                              datetimes[x])
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      months[DateTime.parse(
                                                              datetimes[x])
                                                          .month],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      DateTime.parse(datetimes[
                                                                      x])
                                                                  .hour <
                                                              13
                                                          ? '${DateTime.parse(datetimes[x]).hour.toString()}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} am'
                                                          : '${(DateTime.parse(datetimes[x]).hour - 12).toString()}:${DateTime.parse(datetimes[x]).minute.toString().padLeft(2, '0')} pm',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateTime.parse(
                                                              datetimes[x])
                                                          .add(Duration(
                                                              hours: int.parse(
                                                                  hours[x])))
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      months[DateTime.parse(
                                                              datetimes[x])
                                                          .add(Duration(
                                                              hours: int.parse(
                                                                  hours[x])))
                                                          .month],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      DateTime.parse(datetimes[
                                                                      x])
                                                                  .add(Duration(
                                                                      hours: int
                                                                          .parse(
                                                                              hours[x])))
                                                                  .hour <
                                                              13
                                                          ? '${DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).hour.toString()}:${DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).minute.toString().padLeft(2, '0')} am'
                                                          : '${(DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).hour - 12).toString()}:${DateTime.parse(datetimes[x]).add(Duration(hours: int.parse(hours[x]))).minute.toString().padLeft(2, '0')} pm',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                owner[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                address[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                phone[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 182,
                                  width: 60,
                                  child: Column(
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            statusAll[array[x]] = '2';
                                            FirebaseFirestore.instance
                                                .collection('visitors')
                                                .doc('allVisitors')
                                                .update({
                                              "status": statusAll
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ApproveVisitor(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(16)),
                                          child: Container(
                                            height: 182,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.orange[300],
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(16)),
                                            ),
                                            child: Icon(
                                              Icons.block,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
              namesBlocked.length == 0 || namesBlocked.length == null
                  ? Center(
                      child: Text('No data',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300)))
                  : ListView(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        for (int x = 0; x < namesBlocked.length; x++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Material(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(16)),
                                  elevation: 2,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width -
                                        16 -
                                        60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(16)),
                                        color: Colors.white),
                                    child: ListTile(
                                      isThreeLine: true,
                                      contentPadding: EdgeInsets.only(
                                        left: 8,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      title: Row(
                                        children: [
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            elevation: 2,
                                            child: Container(
                                              width: 80,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  platesBlocked[x],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Text(
                                              namesBlocked[x],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateTime.parse(
                                                              datetimesBlocked[
                                                                  x])
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      months[DateTime.parse(
                                                              datetimesBlocked[
                                                                  x])
                                                          .month],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      DateTime.parse(datetimesBlocked[
                                                                      x])
                                                                  .hour <
                                                              13
                                                          ? '${DateTime.parse(datetimesBlocked[x]).hour.toString()}:${DateTime.parse(datetimesBlocked[x]).minute.toString().padLeft(2, '0')} am'
                                                          : '${(DateTime.parse(datetimesBlocked[x]).hour - 12).toString()}:${DateTime.parse(datetimesBlocked[x]).minute.toString().padLeft(2, '0')} pm',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateTime.parse(
                                                              datetimesBlocked[
                                                                  x])
                                                          .add(Duration(
                                                              hours: int.parse(
                                                                  hoursBlocked[
                                                                      x])))
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      months[DateTime.parse(
                                                              datetimesBlocked[
                                                                  x])
                                                          .add(Duration(
                                                              hours: int.parse(
                                                                  hoursBlocked[
                                                                      x])))
                                                          .month],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.teal[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      DateTime.parse(datetimesBlocked[
                                                                      x])
                                                                  .add(Duration(
                                                                      hours: int
                                                                          .parse(
                                                                              hoursBlocked[x])))
                                                                  .hour <
                                                              13
                                                          ? '${DateTime.parse(datetimesBlocked[x]).add(Duration(hours: int.parse(hoursBlocked[x]))).hour.toString()}:${DateTime.parse(datetimesBlocked[x]).add(Duration(hours: int.parse(hoursBlocked[x]))).minute.toString().padLeft(2, '0')} am'
                                                          : '${(DateTime.parse(datetimesBlocked[x]).add(Duration(hours: int.parse(hoursBlocked[x]))).hour - 12).toString()}:${DateTime.parse(datetimesBlocked[x]).add(Duration(hours: int.parse(hoursBlocked[x]))).minute.toString().padLeft(2, '0')} pm',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[700],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                ownerBlocked[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                addressBlocked[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                phoneBlocked[x],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 182,
                                  width: 60,
                                  child: Column(
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            statusAll[arrayBlocked[x]] = '0';
                                            FirebaseFirestore.instance
                                                .collection('visitors')
                                                .doc('allVisitors')
                                                .update({
                                              "status": statusAll
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ApproveVisitor(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(16)),
                                          child: Container(
                                            height: 182,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.teal[300],
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(16)),
                                            ),
                                            child: Icon(
                                              Icons.undo,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    )
            ])
          // for (int x = 0; x < names.length; x++)

          //   ),
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[100]),
              ),
            ),
    );
  }

  _getVisitorData() {
    firestoreInstance.collection("visitors").get().then((querySnapshot) {
      docs = querySnapshot.docs;
      print('Total: ${docs.length}');
      for (int x = 0; x < docs[0]['names'].length; x++) {
        statusAll.add(docs[0]['status'][x]);
        if (docs[0]['status'][x] == '1') {
          names.add(docs[0]['names'][x]);
          plates.add(docs[0]['plates'][x]);
          datetimes.add(docs[0]['datetimes'][x]);
          hours.add(docs[0]['hours'][x]);
          status.add(docs[0]['status'][x]);
          phone.add(docs[0]['phone'][x]);
          uid.add(docs[0]['uid'][x]);
          address.add(docs[0]['address'][x]);
          owner.add(docs[0]['residentName'][x]);
          array.add(x);
        }
        if (docs[0]['status'][x] == '0') {
          namesPending.add(docs[0]['names'][x]);
          platesPending.add(docs[0]['plates'][x]);
          datetimesPending.add(docs[0]['datetimes'][x]);
          hoursPending.add(docs[0]['hours'][x]);
          statusPending.add(docs[0]['status'][x]);
          phonePending.add(docs[0]['phone'][x]);
          uidPending.add(docs[0]['uid'][x]);
          addressPending.add(docs[0]['address'][x]);
          ownerPending.add(docs[0]['residentName'][x]);
          arrayPending.add(x);
        }
        if (docs[0]['status'][x] == '2') {
          namesBlocked.add(docs[0]['names'][x]);
          platesBlocked.add(docs[0]['plates'][x]);
          datetimesBlocked.add(docs[0]['datetimes'][x]);
          hoursBlocked.add(docs[0]['hours'][x]);
          statusBlocked.add(docs[0]['status'][x]);
          phoneBlocked.add(docs[0]['phone'][x]);
          uidBlocked.add(docs[0]['uid'][x]);
          addressBlocked.add(docs[0]['address'][x]);
          ownerBlocked.add(docs[0]['residentName'][x]);
          arrayBlocked.add(x);
        } else {}
      }
      for (int a = 0; a < namesPending.length; a++) {
        print(namesPending[a]);
        print(datetimesPending[a]);
        print(hoursPending[a]);
      }
      setState(() {
        isLoaded = true;
      });
    });
  }
}
