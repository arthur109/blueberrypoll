import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:html';
import 'login.dart';
import 'session_info.dart';

// void bob(Event data) {
//   print("bob");
//   print((data as HashChangeEvent).newUrl);
// }

void main() {
  initializeApp(
      apiKey: "AIzaSyDZ_zGoNqGa0qnpWhUYnBciAY2cm_mS924",
      authDomain: "blueberry-poll-one.firebaseapp.com",
      databaseURL: "https://blueberry-poll-one.firebaseio.com",
      projectId: "blueberry-poll-one",
      storageBucket: "blueberry-poll-one.appspot.com",
      messagingSenderId: "176622864765",
      appId: "1:176622864765:web:079ec753ca85e82ae9e414",
      measurementId: "G-63200ZDRD0");
  analytics();
  SessionInfo.database = database();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // Define the default Brightness and Colors
      brightness: Brightness.light,
      primaryColor: Colors.black,
      accentColor: Colors.orangeAccent,
    ),
    home: LoginPage(),
  ));
  // window.onHashChange.listen(bob);
}
