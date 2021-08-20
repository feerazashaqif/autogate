import 'package:auto_gate/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automated Gate System',
      theme: ThemeData(
        canvasColor: Colors.teal,
        cursorColor: Colors.orange,
        dialogBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(primary: Colors.teal),
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        highlightColor: Colors.grey[400],
        textSelectionColor: Colors.grey,
      ),
      home: Login(),
    );
  }
}
