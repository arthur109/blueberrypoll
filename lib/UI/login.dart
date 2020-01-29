import 'package:blueberrypoll/UI/main_page.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
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
  DatabaseInterface database;

  LoginPage(this.database);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final nameTextboxController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    if(UIGenerator.width == null){
      UIGenerator.width = MediaQuery.of(context).size.width;
    }
    return loading
        ? loadingPage()
        : Material(
            child: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: UIGenerator.toUnits(5.0),
              minWidth: UIGenerator.toUnits(5.0),
              maxHeight: UIGenerator.toUnits(30.0),
              maxWidth: UIGenerator.toUnits(30.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: UIGenerator.toUnits(40), left: UIGenerator.toUnits(115), right: 115),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  UIGenerator.logo(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UIGenerator.subtitle(
                            "Welcome to the juiciest polling tool around"),
                        SizedBox(
                          height: UIGenerator.toUnits(20),
                        ),
                        UIGenerator.heading("Enter your name to join"),
                      ],
                    ),
                  ),
                  UIGenerator.label("YOUR NAME"),
                  SizedBox(
                    height: UIGenerator.toUnits(11),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(UIGenerator.toUnits(4.0))),
                                color: Color.fromRGBO(243, 243, 247, 1)),
                            padding: EdgeInsets.only(top: UIGenerator.toUnits(8), left: UIGenerator.toUnits(17), right: UIGenerator.toUnits(17)),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              // initialValue: "Arthur F",
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
                    height: UIGenerator.toUnits(40),
                  ),
                  
                  Align(child: UIGenerator.button("Join", login), alignment: Alignment.centerLeft,),
                   
                  
                  
                ],
              ),
            ),
          ));
  }

  Widget loadingPage() {
    return Material(
      child: UIGenerator.loading(message: "logging you in")
    );
  }

  void login() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      String name = nameTextboxController.text.trim();
      print(name);
      UserSnapshot credentials = UserSnapshot(name: name);
      UserP signedInUser = await this.widget.database.signIn(credentials);
      this.widget.database.setOnlineStatusHooks(signedInUser);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainPage(this.widget.database, signedInUser)),
      );
    }
  }

  @override
  void initState() { 
    super.initState();
  }
}
