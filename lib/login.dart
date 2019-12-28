import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'session_info.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final nameTextboxController = TextEditingController();
  bool signedIn = false;

  void login() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        signedIn = true;
      });
      String name = nameTextboxController.value.text.trim();
      SessionInfo.storage.setString('last_used_name', name);
      print(name);
      Map userFound = (await SessionInfo.database
              .ref(SessionInfo.organization + '/users')
              .orderByChild('name')
              .equalTo(name)
              .once("value"))
          .snapshot
          .val();
      print(userFound);
      if (userFound != null) {
        print("account already exists");
        setUser(name, userFound.keys.first);
        print("you are signed in.");
      } else {
        print("account was created - it did not exist");
        setUser(name, await createUser(name));
        print("you are signed in.");
      }
    }
    goToHome();
  }

  void goToHome() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => HomePage()),
    );
  }

  void setUser(String name, String id) {
    SessionInfo.name = name;
    SessionInfo.userID = id;
    print(SessionInfo.name + " - " + SessionInfo.userID);
  }

  // returns the user id once it is created
  Future<String> createUser(String username) async {
    String newUserID = SessionInfo.database
        .ref(SessionInfo.organization + '/users')
        .push()
        .key;
    await SessionInfo.database
        .ref(SessionInfo.organization + '/users/' + newUserID)
        .set({"name": username});
    return newUserID;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: signedIn
          ? loadingPage()
          : Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Enter your name to join",
                    style: TextStyle(
                      fontSize: 17,
                    )),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        onEditingComplete: login,
                        controller: nameTextboxController,
                        decoration: const InputDecoration(
                          hintText: 'Your Name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name, e.g. "John Doe"';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: login,
                    child: Text('Submit'),
                  ),
                ),
              ],
            )),
    );
  }

  Widget loadingPage() {
    return Center(
        child:  CupertinoActivityIndicator());
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences data) {
      SessionInfo.storage = data;
      final String name = SessionInfo.storage.getString('last_used_name');
      if(name != null){
        nameTextboxController.text = name;
      }
    });

  }
  
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameTextboxController.dispose();
    super.dispose();
  }
}
