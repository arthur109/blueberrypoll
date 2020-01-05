import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

void main() async {
  DatabaseInterface database =
      new DatabaseInterface(organization: "dev_organization");

  UserSnapshot credentials = new UserSnapshot(name: "Arthur F");
  UserP signedInUser = await database.signIn(credentials);
  signedInUser.allInfoStream.listen((UserSnapshot data) {
    print("Allinfo: " + data.toMap().toString());
  });

  signedInUser.isOnline.listen((bool data) {
    print("isOnline: " + data.toString());
  });

  signedInUser.name.listen((String data) {
    print("Name: " + data.toString());
  });

  database.setOnlineStatusHooks(signedInUser);

  PollSnapshot pollInfo = new PollSnapshot(
      creatorId: signedInUser.id,
      answerType: AnswerType.TEXT_FEILD,
      question: "Are you dumb",
      isAnonymous: false,
      answers: [
        AnswerTEXT_FEILD(
            answer: "hello", pending: false, respondantId: signedInUser.id),
        AnswerTEXT_FEILD(
            answer: "suuuuuuuuup",
            pending: false,
            respondantId: signedInUser.id),
        AnswerTEXT_FEILD(
            answer: "boom ba da boom",
            pending: true,
            respondantId: signedInUser.id),
      ]);

  Poll createdPoll = await database.createPoll(pollInfo);
  createdPoll.isActive
      .listen((onData) => print("is Active Changed: " + onData.toString()));

  createdPoll.areResultsVisible.listen(
      (onData) => print("Result visibility Changed: " + onData.toString()));

  createdPoll.answers.listen((onData) {
    print("answers changed ");
    for (Answer i in onData) {
      print(i.toMap());
    }
  });

  createdPoll.allInfoStream.listen((onData) {
    print("Pollsnapshot changed ");
    print(onData.toMap());
  });

  // AnswerYES_NO_NOOPINION test = new AnswerYES_NO_NOOPINION(respondantId: signedInUser.id, pending: false, answer: AnswerEnumYES_NO_NOOPINION.NO);
  // Map testMap = test.toMap();
  // print(testMap);
  // AnswerYES_NO_NOOPINION test2 = AnswerYES_NO_NOOPINION.fromMap(testMap);
  // print(test.answer);

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
