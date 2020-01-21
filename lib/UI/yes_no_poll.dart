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
  Stream userAnswerStream;
  PollSummaryYES_NO summary;

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
      stream: this.userAnswerStream,
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
        this.widget.poll.areTheirAnswers().then((value) {
          if (!value) {
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
              UIGenerator.subtitle("Currently polling"),
              SizedBox(
                height: 20,
              ),
              UIGenerator.heading(this.widget.poll.question)
            ],
          ),
        ),
        UIGenerator.label("YOUR ANSWER"),
        SizedBox(
          height: 11,
        ),
        ClipRRect(
            borderRadius: new BorderRadius.circular(30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      this.widget.poll.submitAnswer(AnswerYES_NO(
                          pending: false,
                          answer: AnswerEnumYES_NO.YES,
                          respondantId: this.widget.user.id));
                    },
                    hoverColor: Color.fromRGBO(235, 235, 237, 1),
                    child: Ink(
                      color: Color.fromARGB(255, 246, 246, 250),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: UIGenerator.coloredText(
                            "Yes", Color.fromARGB(255, 91, 91, 111)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      this.widget.poll.submitAnswer(AnswerYES_NO(
                          pending: false,
                          answer: AnswerEnumYES_NO.NO,
                          respondantId: this.widget.user.id));
                    },
                    hoverColor: Color.fromRGBO(235, 235, 237, 1),
                    child: Ink(
                      color: Color.fromARGB(255, 246, 246, 250),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: UIGenerator.coloredText(
                            "No", Color.fromARGB(255, 91, 91, 111)),
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget pollSummary() {
    if (summary != null) {
      bool canViewResults =
          (summary.areResultsVisible || summary.hasResultVisibilityPrivilege);
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
                UIGenerator.subtitle(canViewResults
                    ? "Viewing results for the poll"
                    : "Waiting for results to be revealed for the poll"),
                SizedBox(
                  height: 20,
                ),
                UIGenerator.heading(this.widget.poll.question)
              ],
            ),
          ),
          UIGenerator.label("TOTAL TALLY FROM " +
              summary.totalCount.toString() +
              " PARTICIPANTS"),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  canViewResults
                      ? UIGenerator.normalText(
                          "Yes")
                      : UIGenerator.fadedNormalText("Yes"),
                       SizedBox(
                      height: 35,
                    ),
                  canViewResults
                      ? UIGenerator.normalText(
                          "No")
                      : UIGenerator.fadedNormalText("No"),
                       SizedBox(
                      height: 35,
                    ),
                  UIGenerator.fadedNormalText("Still Answering...")
                ],
              ),
              SizedBox(width: 36,),
              Expanded(
                              child: Column(
                  children: <Widget>[
                    UIGenerator.progressBar(canViewResults ? summary.yesCount : 0,
                        summary.totalCount, UIGenerator.green, !canViewResults,
                        showAmount: true),
                    SizedBox(
                      height: 35,
                    ),
                    UIGenerator.progressBar(canViewResults ? summary.noCount : 0,
                        summary.totalCount, UIGenerator.red, !canViewResults,
                        showAmount: true),
                    SizedBox(
                      height: 35,
                    ),
                    UIGenerator.progressBar(summary.pendingCount,
                        summary.totalCount, UIGenerator.yellow, true,
                        showAmount: true),
                  ],
                ),
              )
            ],
          ),
        ],
      );
    }
    return UIGenerator.loading(message: "getting results");
  }

  Future<void> setPendingAnswer() async {
    print("---- set pending answer -----");
    await this.widget.poll.submitAnswer(AnswerYES_NO(
        pending: true,
        answer: AnswerEnumYES_NO.YES,
        respondantId: this.widget.user.id));
    setState(() {});
  }

  Widget inActivePoll() {
    return pollSummary();
  }

  @override
  void initState() {
    super.initState();

    this.userAnswerStream =
        this.widget.poll.getAnswerOfUser(this.widget.user.id);

    // this.widget.poll.answers.listen((data) {
    //   print("answers updated ------");
    // });

    this.widget.poll.getSummaryStream(this.widget.user.id).listen((data) {
      print("poll summary updated ------ ");
      print(data.toString());
      setState(() {
        summary = data;
      });
    });

    // this.widget.poll.getAnswerOfUser(this.widget.user.id).listen((data) {
    //   print("user answers updated ------ ");
    //   print(data.toString());
    // });
  }
}
