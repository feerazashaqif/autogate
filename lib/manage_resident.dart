import 'dart:convert';

import 'package:auto_gate/models/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class ManageResident extends StatefulWidget {
  final String uid;

  ManageResident(this.uid);
  @override
  _ManageResidentState createState() => _ManageResidentState();
}

class _ManageResidentState extends State<ManageResident>
    with SingleTickerProviderStateMixin {
  DateTime date;
  List names = [],
      plates = [],
      plates2 = [],
      address = [],
      phone = [],
      email = [],
      uid = [],
      status = [];
  List namesBlocked = [],
      platesBlocked = [],
      plates2Blocked = [],
      addressBlocked = [],
      phoneBlocked = [],
      emailBlocked = [],
      uidBlocked = [],
      statusBlocked = [];
  List namesPending = [],
      platesPending = [],
      plates2Pending = [],
      addressPending = [],
      phonePending = [],
      uidPending = [],
      emailPending = [],
      statusPending = [];
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
          _getResidentData();
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
          'MANAGE RESIDENTS',
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
                                            children: [
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                elevation: 2,
                                                child: Container(
                                                  width: 80,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
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
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                elevation: 2,
                                                child: Container(
                                                  width: 80,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      plates2Pending[x],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
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
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                emailPending[x],
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
                                  height: 150,
                                  width: 60,
                                  child: Column(
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(uidPending[x])
                                                .update({
                                              "status": '2'
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ManageResident(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16)),
                                          child: Container(
                                            height: 75,
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
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(uidPending[x])
                                                .update({
                                              "status": '1'
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ManageResident(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(16)),
                                          child: Container(
                                            height: 75,
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
                                            children: [
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                elevation: 2,
                                                child: Container(
                                                  width: 80,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
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
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                elevation: 2,
                                                child: Container(
                                                  width: 80,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      plates2[x],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
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
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                email[x],
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
                                  height: 150,
                                  width: 60,
                                  child: Column(
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(uid[x])
                                                .update({
                                              "status": '2'
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ManageResident(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(16)),
                                          child: Container(
                                            height: 150,
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
                                            children: [
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                elevation: 2,
                                                child: Container(
                                                  width: 80,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
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
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                elevation: 2,
                                                child: Container(
                                                  width: 80,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      plates2Blocked[x],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
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
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: Colors.orange[800],
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                emailBlocked[x],
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
                                  height: 150,
                                  width: 60,
                                  child: Column(
                                    children: [
                                      Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(16)),
                                        child: InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(uidBlocked[x])
                                                .update({
                                              "status": '0'
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: new ManageResident(
                                                          widget.uid),
                                                      type: PageTransitionType
                                                          .fade));
                                            });
                                          },
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(16)),
                                          child: Container(
                                            height: 150,
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

  _getResidentData() {
    firestoreInstance.collection("users").get().then((querySnapshot) {
      docs = querySnapshot.docs;
      print('Total: ${docs.length}');
      for (int x = 0; x < docs.length; x++) {
        print(docs[x]['name']);
        if (docs[x]['place'] == adminPlace) {
          if (docs[x]['status'] == '1' && docs[x]['userType'] == '1') {
            names.add(docs[x]['name']);
            plates.add(docs[x]['plate1']);
            plates2.add(docs[x]['plate2']);
            address.add(docs[x]['address']);
            phone.add(docs[x]['phone']);
            email.add(docs[x]['email']);
            uid.add(docs[x]['uid']);
          }
          if (docs[x]['status'] == '0' && docs[x]['userType'] == '1') {
            namesPending.add(docs[x]['name']);
            platesPending.add(docs[x]['plate1']);
            plates2Pending.add(docs[x]['plate2']);
            addressPending.add(docs[x]['address']);
            phonePending.add(docs[x]['phone']);
            emailPending.add(docs[x]['email']);
            uidPending.add(docs[x]['uid']);
          }
          if (docs[x]['status'] == '2' && docs[x]['userType'] == '1') {
            namesBlocked.add(docs[x]['name']);
            platesBlocked.add(docs[x]['plate1']);
            plates2Blocked.add(docs[x]['plate2']);
            addressBlocked.add(docs[x]['address']);
            phoneBlocked.add(docs[x]['phone']);
            emailBlocked.add(docs[x]['email']);
            uidBlocked.add(docs[x]['uid']);
          } else {}
        }
      }
      setState(() {
        isLoaded = true;
      });
    });
  }
}
