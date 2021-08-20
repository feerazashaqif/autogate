import 'package:auto_gate/login.dart';
import 'package:auto_gate/pushnoti/PushNotificationManager.dart';
import 'package:auto_gate/view_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_gate/apply_visitor.dart';
import 'package:auto_gate/approve_visitor.dart';
import 'package:auto_gate/manage_resident.dart';
import 'package:auto_gate/user_activity.dart';
import 'package:auto_gate/view_record.dart';
import 'package:auto_gate/view_visitor.dart';

class Home extends StatefulWidget {
  final String uid;

  Home(this.uid);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position position;
  String plate1 = '',
      plate2 = '',
      name = '',
      email = '',
      status = '',
      userType = '',
      plate1Status = '',
      plate2Status = '';
  bool isUnlocked1 = false,
      isUnlocked2 = false,
      isLoaded = false,
      accApproved = false,
      user = true;
  List names = [], uids = [], datetimes = [], latitudes = [], longitudes = [];

  final firestoreInstance = FirebaseFirestore.instance;

  var postUrl = "fcm.googleapis.com/fcm/send";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    PushNotificationsManager().init();
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              ));
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  static Future<void> sendNotification(name) async {
    final data = {
      "notification": {
        "body": "$name pressed the panic alert button",
        "title": "Alert!"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
      },
      "to":
          "fzfkytiWS6Wq1zDzg2B8fy:APA91bGf096C5e-DNPXFN2ghnKsoab3Okm0kIzH-LJGl1lS-V9P0b-GD6zASfDr4jYT7NBPbCmXBJQ5E50HiTtvGDqLW4VLoGf6FLt9lGt9x7GFt7WTuCTnMypB5a1mpA7vOua-4jyyh" //ni account admin aku punya device token
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAAx5M-1I:APA91bHu8UT97dEvCDrW6kQIbWMj1FQYakvn5fFN1ytPnwTw-yD39-FvP20JQtUB_TFK6g8po3h2utE-XriBMAzQ96ahS5rbXOWR6mrRFzzsfiQvYsTsRTLpz0j2YWC_Ju6xAx40Ex2d'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options)
          .post("https://fcm.googleapis.com/fcm/send", data: data);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Alert Sent To Management');
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
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
          plate1 = documentSnapshot.data()['plate1'];
          plate2 = documentSnapshot.data()['plate2'];
          name = documentSnapshot.data()['name'];
          email = documentSnapshot.data()['email'];
          status = documentSnapshot.data()['status'];
          userType = documentSnapshot.data()['userType'];
          if (userType == '0') {
            print('admin');

            user = false;
            isLoaded = true;
          }
          if (status == '1') {
            accApproved = true;
            plate1Status = documentSnapshot.data()['plate1Status'];
            plate2Status = documentSnapshot.data()['plate2Status'];
            print(plate1Status);
            print(plate2Status);
            if (plate1Status == '1') {
              isUnlocked1 = true;
            } else {
              isUnlocked1 = false;
            }
            if (plate2Status == '1') {
              isUnlocked2 = true;
            } else {
              isUnlocked2 = false;
            }
            isLoaded = true;
          } else {
            isLoaded = true;
          }
        });
      }
    });
    final map2 = await FirebaseFirestore.instance
        .collection('alerts')
        .doc('all')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          names = documentSnapshot.data()['name'];
          uids = documentSnapshot.data()['uid'];
          datetimes = documentSnapshot.data()['datetime'];
          latitudes = documentSnapshot.data()['latitude'];
          longitudes = documentSnapshot.data()['longitude'];
        });
      }
    });
    print(plate1);
    position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .whenComplete(() => print('POSITION SET'));
  }

  void toggleSwitch1(bool value) {
    if (isUnlocked1 == false) {
      setState(() {
        isUnlocked1 = true;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({"plate1Status": '1'}).whenComplete(() =>
                Fluttertoast.showToast(
                    msg: "Plate Unlocked!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0));
      });
    } else {
      setState(() {
        isUnlocked1 = false;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({"plate1Status": '0'}).whenComplete(() =>
                Fluttertoast.showToast(
                    msg: "Plate Locked!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0));
      });
    }
  }

  void toggleSwitch2(bool value) {
    if (isUnlocked2 == false) {
      setState(() {
        isUnlocked2 = true;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({"plate2Status": '1'}).whenComplete(() =>
                Fluttertoast.showToast(
                    msg: "Plate Unlocked!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0));
      });
    } else {
      setState(() {
        isUnlocked2 = false;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({"plate2Status": '0'}).whenComplete(() =>
                Fluttertoast.showToast(
                    msg: "Plate Locked!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return accApproved && user
        ? Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.teal,
            drawer: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Hello',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '$name',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      email,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: new ApplyVisitorPass(widget.uid),
                              type: PageTransitionType.fade));
                    },
                    splashColor: Colors.orange[100],
                    highlightColor: Colors.orange[300],
                    child: ListTile(
                      title: Text(
                        'Apply Visitor Pass',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                      trailing: Icon(
                        Icons.group_add,
                        color: Colors.teal[300],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: new ViewVisitor(widget.uid),
                              type: PageTransitionType.fade));
                    },
                    splashColor: Colors.orange[100],
                    highlightColor: Colors.orange[300],
                    child: ListTile(
                      title: Text(
                        'My Visitors',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                      trailing: Icon(
                        Icons.people_rounded,
                        color: Colors.teal[300],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.teal,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'HOME',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w200),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _signOut();
                  },
                )
              ],
            ),
            body: isLoaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 32.0, left: 32),
                              child: Text(
                                'MY VEHICLE(S)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, left: 32),
                              child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: new UserActivity(widget.uid),
                                            type: PageTransitionType.fade));
                                  },
                                  color: Colors.teal[300],
                                  child: Text(
                                    'VIEW VEHICLE ACTIVITY',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  )),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            ListTile(
                              isThreeLine: true,
                              title: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  plate1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    Text(
                                      !isUnlocked1
                                          ? "is restricted "
                                          : "is unrestricted ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      !isUnlocked1
                                          ? Icons.lock_outline
                                          : Icons.lock_open,
                                      color: !isUnlocked1
                                          ? Colors.red[300]
                                          : Colors.green[300],
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  Switch(
                                    onChanged: toggleSwitch1,
                                    value: isUnlocked1,
                                    activeColor: Colors.green,
                                    activeTrackColor: Colors.green[100],
                                    inactiveThumbColor: Colors.red,
                                    inactiveTrackColor: Colors.red[100],
                                  )
                                ],
                              ),
                            ),
                            ListTile(
                              isThreeLine: true,
                              title: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  plate2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    Text(
                                      !isUnlocked2
                                          ? "is restricted "
                                          : "is unrestricted ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      !isUnlocked2
                                          ? Icons.lock_outline
                                          : Icons.lock_open,
                                      color: !isUnlocked2
                                          ? Colors.red[300]
                                          : Colors.green[300],
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  Switch(
                                    onChanged: toggleSwitch2,
                                    value: isUnlocked2,
                                    activeColor: Colors.green,
                                    activeTrackColor: Colors.green[100],
                                    inactiveThumbColor: Colors.red,
                                    inactiveTrackColor: Colors.red[100],
                                  )
                                ],
                              ),
                            ),
                          ]),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: new ApplyVisitorPass(widget.uid),
                                  type: PageTransitionType.fade));
                        },
                        color: Colors.teal[300],
                        child: Text(
                          'APPLY VISITOR PASS',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(position.latitude.toString());
                              print(position.longitude.toString());
                              names.add(name);
                              uids.add(widget.uid);
                              datetimes.add(DateTime.now().toString());
                              latitudes.add(position.latitude);
                              longitudes.add(position.longitude);
                              sendNotification(name);
                              firestoreInstance
                                  .collection('alerts')
                                  .doc('all')
                                  .update({
                                'name': names,
                                'uid': uids,
                                'datetime': datetimes,
                                'latitude': latitudes,
                                'longitude': longitudes
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.yellow),
                              child: Icon(Icons.warning,
                                  size: 40, color: Colors.black54),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Hold this button for emergency",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.teal[100]),
                    ),
                  ),
          )
        : !accApproved && user
            ? Scaffold(
                body: isLoaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Pending Account Approval',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.5,
                              child: Image(
                                image: AssetImage('assets/locked.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Please wait for your account to be approved by the management',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.teal[100]),
                        ),
                      ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.teal,
                  centerTitle: true,
                  leading: Container(),
                  title: Text(
                    'HOME',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w200),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _signOut();
                      },
                    )
                  ],
                ),
                body: isLoaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 40, bottom: 30),
                            child: Row(
                              children: [
                                Text(
                                  'Choose Responsibility',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: new ManageResident(widget.uid),
                                        type: PageTransitionType.fade));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.teal[50]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Manage Resident',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.teal[800]),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: new ApproveVisitor(widget.uid),
                                        type: PageTransitionType.fade));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.teal[50]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Approve Visitor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.teal[800]),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: new ViewRecord(widget.uid),
                                        type: PageTransitionType.fade));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.teal[50]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View Entry/Exit Record',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.teal[800]),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: new ViewAlert(widget.uid),
                                        type: PageTransitionType.fade));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.teal[50]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View Panic Alert List',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.teal[800]),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(height: 80),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.teal[100]),
                        ),
                      ),
              );
  }
}
