import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

void main() async {
  DatabaseInterface database =
      new DatabaseInterface(organization: "dev_organization");

  UserSnapshot credentials = new UserSnapshot(name: "Arthur F");
  UserP signedInUser = await database.signIn(credentials);
  signedInUser.allInfoStream.listen((UserSnapshot data) {
    print("Allinfo: "+data.toMap().toString());
  });

  signedInUser.isOnline.listen((bool data) {
    print("isOnline: "+data.toString());
  });

  signedInUser.name.listen((String data) {
    print("Name: "+data.toString());
  });

  database.setOnlineStatusHooks(signedInUser);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // Define the default Brightness and Colors
      brightness: Brightness.light,
      primaryColor: Colors.black,
      accentColor: Colors.orangeAccent,
    ),
    home: Scaffold(
      body: Text("hello"),
    ),
  ));
}
