import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/UI/login.dart';
import 'package:blueberrypoll/UI/main_page.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const PRODUCTION_ORGANIZATION_NODE_KEY = "production-organization";
const DEVELOPMENT_ORGANIZATION_NODE_KEY = "development-organization";
void main() async {
  DatabaseInterface database =
      // new DatabaseInterface(organization: "dev_org_two");
      new DatabaseInterface(organization: PRODUCTION_ORGANIZATION_NODE_KEY);

  runApp(CupertinoApp(
    navigatorKey: MainPage.navKey,
    debugShowCheckedModeBanner: false,
    home: LoginPage(database),
    localizationsDelegates: [
      DefaultMaterialLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
    ],
  ));
}
