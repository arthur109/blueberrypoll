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
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  DatabaseInterface database;

  LoginPage(this.database);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount _currentUser;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      // // 'personal'
      // 'profile',
      // // 'https://www.googleapis.com/auth/userinfo.profile	'
      // // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _formKey = GlobalKey<FormState>();
  final nameTextboxController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    if (UIGenerator.width == null) {
      UIGenerator.width = MediaQuery.of(context).size.width;
    }
    if (loading) {
      return signingUserIn();
    }
    if (_currentUser == null) {
      return signingInWithGoogle();
    } else {
      return confirmAccount();
    }
  }

  Widget signingUserIn() {
    return Material(child: UIGenerator.loading(message: "logging you in"));
  }

  Widget signingInWithGoogle() {
    return UIGenerator.loading(message: "signing in with google");
  }

  Widget confirmAccount() {
    return Center(
      child: Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  _currentUser.photoUrl,
                  width: UIGenerator.toUnits(64),
                  height: UIGenerator.toUnits(64),
                ),
                SizedBox(
                  width: UIGenerator.toUnits(32),
                ),
                UIGenerator.heading(_currentUser.displayName),
              ],
            ),
            SizedBox(
              height: UIGenerator.toUnits(16),
            ),
            UIGenerator.subtitle("Welcome to Blueberry Poll!"),
            SizedBox(
              height: UIGenerator.toUnits(32),
            ),
            // Align(alignment: Alignment.center, child: UIGenerator.button("Continue", login)),
                       UIGenerator.button("Continue", login),

            SizedBox(
              height: UIGenerator.toUnits(16),
            ),
            InkWell(
              child: UIGenerator.coloredThinText("or switch account", UIGenerator.grey),
              onTap: () {
                _googleSignIn.signOut().then((value) {
                  _googleSignIn.signIn();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    // if (_formKey.currentState.validate()) {
    setState(() {
      loading = true;
    });
    String name = nameTextboxController.text.trim();
    print(name);
    UserSnapshot credentials =
        UserSnapshot(name: _currentUser.displayName, id: _currentUser.id);
    UserP signedInUser = await this.widget.database.signIn(credentials);
    this.widget.database.setOnlineStatusHooks(signedInUser);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainPage(this.widget.database, signedInUser)),
    );
    // }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        print("New user: " + account.displayName);
      });
      if (_currentUser != null) {
        print("Current User: " + this._currentUser.displayName);
      } else {
        print("There is no current user");
      }
    });

    _googleSignIn.signInSilently().then((GoogleSignInAccount user) {
      if (user == null) {
        print("no prev user found");
        _googleSignIn.signIn();
      } else {
        print("prev user found");
      }
    });

    // _googleSignIn.isSignedIn().then((isSignedIn){
    //   print("User is signed in: "+isSignedIn.toString());
    //   if(!isSignedIn){
    //     _googleSignIn.signIn();
    //   }else{
    //     print("name: " +_googleSignIn.currentUser.displayName.toString());
    //   }
    // });
  }
}
