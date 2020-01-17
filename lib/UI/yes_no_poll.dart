import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'create_poll.dart';

class YesNoPoll extends StatefulWidget {
  Poll poll;
  DatabaseInterface database;
  UserP user;
  YesNoPoll(this.poll, this.user, this.database);
  @override
  _YesNoPollState createState() => _YesNoPollState();
}

class _YesNoPollState extends State<YesNoPoll> {
  @override
  Widget build(BuildContext context) {
    return this.widget.poll.isCreator(this.widget.user.id)
        ? creatorView()
        : participantView();
  }

  Widget creatorView() {
    return pollSummary();
  }

  Widget participantView() {
    return StreamBuilder(
      stream: this.widget.poll.isActive,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return activePoll();
          } else {
            return inActivePoll();
          }
        } else {
          return UIGenerator.loading(message: "checking poll activity status");
        }
      },
    );
  }

  Widget activePoll() {
    return StreamBuilder(
      stream: this.widget.poll.getAnswerOfUser(this.widget.user.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print("--- UPDATED");
        if (snapshot.hasData) {
          print("snapshot has data");
          if (snapshot.data == Poll.NO_ANSWER_CODE) {
            print("no user answers found");
            setPendingAnswer();
            return UIGenerator.loading(message: "getting answer b");
          } else if ((snapshot.data as Answer).pending) {
            print("pending answer found");
            return getAnswerWidget();
          } else {
            print("completed answer found");
            return pollSummary();
          }
        }
        print("snapshot has no data");
        this.widget.poll.areTheirAnswers().then((value){
          if(!value){
            print("no answers at all, setting pending answer");
            setPendingAnswer();
          }
        });
        return UIGenerator.loading(message: "getting answer a");
      },
    );
  }

  Widget getAnswerWidget() {
     return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UIGenerator.subtitle(
                  "Currently polling"),
              SizedBox(
                height: 20,
              ),
              UIGenerator.heading(this.widget.poll.question)
            ],
          ),
        ),
      ],
    );
  }

  Widget pollSummary() {
    return Center(child: Text("poll summary"));
  }

  Future<void> setPendingAnswer() async {
    print("---- set pending answer -----");
    await this.widget.poll.submitAnswer(AnswerYES_NO(
        pending: true,
        answer: AnswerEnumYES_NO.YES,
        respondantId: this.widget.user.id));
    setState(() {

    });
  }

  Widget inActivePoll() {
    return pollSummary();
  }

  @override
  void initState() { 
    super.initState();
    this.widget.poll.answers.listen((data){
      print("answers updated ------");
    });

    this.widget.poll.getAnswerOfUser(this.widget.user.id).listen((data){
      print("user answers updated ------ ");
      print(data.toString());
    });
  }
}
