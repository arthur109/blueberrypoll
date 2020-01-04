import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';


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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // Define the default Brightness and Colors
      brightness: Brightness.light,
      primaryColor: Colors.black,
      accentColor: Colors.orangeAccent,
    ),
    home: Scaffold(
      
    ),
  ));
}
