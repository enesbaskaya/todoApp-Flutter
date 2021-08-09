import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/home_page.dart';
import 'Screens/my_notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

// ignore: use_key_in_widget_constructors
class Main extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO APP',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
      ),
      home: user != null ? MyNotes() : const HomePage(),
    );
  }
}
