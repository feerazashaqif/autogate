import 'dart:async';

import 'package:auto_gate/home.dart';
import 'package:auto_gate/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Future<FirebaseUser> handleSignInEmail(String email, String password) async {
  //   AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
  //       email: email, password: password);
  //   final FirebaseUser user = result.user;

  //   assert(user != null);
  //   assert(await user.getIdToken() != null);

  //   final FirebaseUser currentUser = await firebaseAuth.currentUser();
  //   assert(user.uid == currentUser.uid);

  //   print('signInEmail succeeded: ${user.email}');

  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => Home(user.uid)));

  //   return user;
  // }

  void handleSignInEmail(String emaill, String passwordd) async {
    try {
      final UserCredential userCredential =
          (await _auth.signInWithEmailAndPassword(
        email: emaill,
        password: passwordd,
      ));
      Future<String> getCurrentUID() async {
        return (_auth.currentUser.uid);
      }

      if (userCredential != null) {
        setState(() async {
          final currentuid = await getCurrentUID();
          Timer(Duration(seconds: 2), () {
            Fluttertoast.showToast(
                msg: "Login  succesful!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.teal[300],
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.push(
                context,
                PageTransition(
                    child: new Home(currentuid),
                    type: PageTransitionType.fade));
            password.clear();
          });
        });
      }
    } catch (e) {
      print(e);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48,
                ),
                Center(
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 22,
                        shadows: [
                          Shadow(color: Colors.black54, offset: Offset(1, 1))
                        ]),
                  ),
                ),
                SizedBox(
                  height: 48,
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
                            color: Colors.orange,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          'E-mail Address',
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
                      controller: email,
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
                        hintText: 'example@mail.com',
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
                            color: Colors.orange,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16))),
                        child: Text(
                          'Password',
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
                      obscureText: true,
                      controller: password,
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
                        hintText: 'eg: abc12345',
                      ),
                    )),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.orange,
                    splashColor: Colors.indigo,
                    onPressed: () {
                      handleSignInEmail(email.text, password.text);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign up here",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 14,
                          shadows: [
                            Shadow(color: Colors.black54, offset: Offset(1, 1))
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
