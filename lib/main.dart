import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/UI/login.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  DatabaseInterface database =
      new DatabaseInterface(organization: "dev_org_two");

  // UserSnapshot credentials = new UserSnapshot(name: "Arthur F");
  // UserP signedInUser = await database.signIn(credentials);
  // signedInUser.allInfoStream.listen((UserSnapshot data) {
  //   print("Allinfo: " + data.toMap().toString());
  // });

  // signedInUser.isOnline.listen((bool data) {
  //   print("isOnline: " + data.toString());
  // });

  // signedInUser.name.listen((String data) {
  //   print("Name: " + data.toString());
  // });

  // database.setOnlineStatusHooks(signedInUser);

  // PollSnapshot pollInfo = new PollSnapshot(
  //     creatorId: signedInUser.id,
  //     answerType: AnswerType.YES_NO_NOOPINION,
  //     question: "Are you dumb",
  //     isAnonymous: false,
  //     answers: [
  //       AnswerYES_NO_NOOPINION(
  //           answer: AnswerEnumYES_NO_NOOPINION.NOOPINION,
  //           pending: false,
  //           respondantId: signedInUser.id+"bob"),
  //       AnswerYES_NO_NOOPINION(
  //           answer: AnswerEnumYES_NO_NOOPINION.YES,
  //           pending: false,
  //           respondantId: signedInUser.id+"john"),
  //       AnswerYES_NO_NOOPINION(
  //           answer: AnswerEnumYES_NO_NOOPINION.NO,
  //           pending: true,
  //           respondantId: signedInUser.id+"billy"),
  //     ]);

  // Poll createdPoll = await database.createPoll(pollInfo);
  // createdPoll.getAnswerOfUser(signedInUser.id).listen((data){
  //   if(data != null)
  //     print(data.toMap());
  //   else
  //     print("NO ANSWER FOUND");
  // });

  // createdPoll.allInfoStream.listen(
  //   (PollSnapshot data){
  //     print("is active: "+data.isActive.toString());
  //   }
  // ); 

  // createdPoll.isActive
  //     .listen((onData) => print("is Active Changed: " + onData.toString()));

  // createdPoll.areResultsVisible.listen(
  //     (onData) => print("Result visibility Changed: " + onData.toString()));

  // createdPoll.answers.listen((onData) {
  //   print("answers changed ");
  //   for (Answer i in onData) {
  //     print(i.toMap());
  //   }
  // });

  // createdPoll.allInfoStream.listen((onData) {
  //   print("Pollsnapshot changed ");
  //   print(onData.toMap());
  // });

  // createdPoll.getSummaryStream(signedInUser.id).listen((sum){
  //   PollSummaryYES_NO_NOOPINION summary = sum as PollSummaryYES_NO_NOOPINION;
  //   if(summary != null){
  //   print("visibility privilage: "+summary.hasResultVisibilityPrivilege.toString());
  //   print("are results visible: "+summary.areResultsVisible.toString());
  //   print("is anonymous: "+ summary.isAnonymous.toString());
  //   print("pending count: "+summary.pendingCount.toString());
  //   print("total count: "+summary.totalCount.toString());
  //   print("yes count: "+summary.yesCount.toString());
  //   print("no count: "+summary.noCount.toString());
  //   print("no opinion count: "+summary.noOpinionCount.toString());
  //   }
  // });

  // AnswerYES_NO_NOOPINION test = new AnswerYES_NO_NOOPINION(respondantId: signedInUser.id, pending: false, answer: AnswerEnumYES_NO_NOOPINION.NO);
  // Map testMap = test.toMap();
  // print(testMap);
  // AnswerYES_NO_NOOPINION test2 = AnswerYES_NO_NOOPINION.fromMap(testMap);
  // print(test.answer);

  runApp(CupertinoApp(
    debugShowCheckedModeBanner: false,
    // theme: ThemeData(
    //   // Define the default Brightness and Colors
    //   brightness: Brightness.light,
    //   primaryColor: Colors.black,
    //   accentColor: Colors.orangeAccent,
    // ),
    home: LoginPage(database)
  ));
}
