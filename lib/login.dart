import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  void login(){
       if (_formKey.currentState.validate()) {
         
       }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child:Column(
                
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
}
