import 'package:flutter/material.dart';
import 'ui_generator.dart';
import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:firebase/firebase.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final nameTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top:40, left: 115),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UIGenerator.logo(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UIGenerator.subtitle(
                        "Welcome to the juiciest polling tool around"),
                    SizedBox(
                      height: 20,
                    ),
                    UIGenerator.heading("Enter your name to join"),
                  ],
                ),
              ),
              UIGenerator.label("YOUR NAME"),
              SizedBox(
                height: 11,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Color.fromRGBO(243, 243, 247, 1)),
                      padding: EdgeInsets.only(top: 8, left: 17, right: 17),
                      child: TextFormField(
                        // autofocus: true,
                        style: UIGenerator.textFeildTextStyle(),
                        onEditingComplete: login,
                        controller: nameTextboxController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name, e.g. "John Doe"';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              UIGenerator.button("Join", login)
            ],
          ),
        ),
      );
  }

  void login() {
    if (_formKey.currentState.validate()) {
      String name = nameTextboxController.text.trim();
      print(name);
      // UserSnapshot
    }
  }
}
