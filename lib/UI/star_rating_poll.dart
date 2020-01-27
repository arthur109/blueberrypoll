import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'create_poll.dart';

class StarRatingPoll extends StatefulWidget {
  Poll poll;
  DatabaseInterface database;
  UserP user;
  StarRatingPoll(this.poll, this.user, this.database);
  @override
  _StarRatingPollState createState() => _StarRatingPollState();
}

class _StarRatingPollState extends State<StarRatingPoll> {
  Stream userAnswerStream;
  Stream participantIsActiveStream;
  PollSummarySTAR_RATING summary;
  int starHovered = 0;
  // = PollSummarySTAR_RATING(noCount: 0, pendingCount: 0, yesCount: 0, totalCount: 0);

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
      stream: participantIsActiveStream,
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
          return Cupertino.ListView(
        shrinkWrap: true,
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
            borderRadius: new BorderRadius.circular(8.0),
            child: Row(
              children: <Widget>[
                StarRatingButton(1, () {
                  this.widget.poll.submitAnswer(AnswerSTAR_RATING(
                      respondantId: this.widget.user.id,
                      pending: false,
                      answer: AnswerEnumSTAR_RATING.ONE));
                }),
                SizedBox(
                  width: 3,
                ),
                StarRatingButton(2, () {
                  this.widget.poll.submitAnswer(AnswerSTAR_RATING(
                      respondantId: this.widget.user.id,
                      pending: false,
                      answer: AnswerEnumSTAR_RATING.TWO));
                }),
                SizedBox(
                  width: 3,
                ),
                StarRatingButton(3, () {
                  this.widget.poll.submitAnswer(AnswerSTAR_RATING(
                      respondantId: this.widget.user.id,
                      pending: false,
                      answer: AnswerEnumSTAR_RATING.THREE));
                }),
                SizedBox(
                  width: 3,
                ),
                StarRatingButton(4, () {
                  this.widget.poll.submitAnswer(AnswerSTAR_RATING(
                      respondantId: this.widget.user.id,
                      pending: false,
                      answer: AnswerEnumSTAR_RATING.FOUR));
                }),
                SizedBox(
                  width: 3,
                ),
                StarRatingButton(5, () {
                  this.widget.poll.submitAnswer(AnswerSTAR_RATING(
                      respondantId: this.widget.user.id,
                      pending: false,
                      answer: AnswerEnumSTAR_RATING.FIVE));
                }),
              ],
            ))
      ],
    );
  }

  Widget pollSummary() {
    if (summary != null) {
      bool canViewResults =
          (summary.areResultsVisible || summary.hasResultVisibilityPrivilege);
      return Cupertino.ListView(
        shrinkWrap: true,
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
                  UIGenerator.StarRatingAnswerDisplay(5, !canViewResults),
                  SizedBox(
                    height: 35,
                  ),
                  UIGenerator.StarRatingAnswerDisplay(4, !canViewResults),
                  SizedBox(
                    height: 35,
                  ),
                  UIGenerator.StarRatingAnswerDisplay(3, !canViewResults),
                  SizedBox(
                    height: 35,
                  ),
                  UIGenerator.StarRatingAnswerDisplay(2, !canViewResults),
                  SizedBox(
                    height: 35,
                  ),
                  UIGenerator.StarRatingAnswerDisplay(1, !canViewResults),
                  SizedBox(
                    height: 35,
                  ),
                  UIGenerator.fadedNormalText("Still Answering..."),
                ],
              ),
              SizedBox(
                width: 36,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    UIGenerator.progressBar(
                        canViewResults ? summary.fiveCount : 0,
                        summary.totalCount,
                        UIGenerator.yellow,
                        !canViewResults,
                        showAmount: true),
                    SizedBox(
                      height: 35,
                    ),
                    UIGenerator.progressBar(
                        canViewResults ? summary.fourCount : 0,
                        summary.totalCount,
                        UIGenerator.yellow,
                        !canViewResults,
                        showAmount: true),
                    SizedBox(
                      height: 35,
                    ),
                    UIGenerator.progressBar(
                        canViewResults ? summary.threeCount : 0,
                        summary.totalCount,
                        UIGenerator.yellow,
                        !canViewResults,
                        showAmount: true),
                    SizedBox(
                      height: 35,
                    ),
                    UIGenerator.progressBar(
                        canViewResults ? summary.twoCount : 0,
                        summary.totalCount,
                        UIGenerator.yellow,
                        !canViewResults,
                        showAmount: true),
                    SizedBox(
                      height: 35,
                    ),
                    UIGenerator.progressBar(
                        canViewResults ? summary.oneCount : 0,
                        summary.totalCount,
                        UIGenerator.yellow,
                        !canViewResults,
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
          SizedBox(
            height: 75,
          ),
          summary.hasResultVisibilityPrivilege
              ? SummaryButtonBar(summary.isActive, summary.areResultsVisible)
              : SizedBox(
                  height: 0,
                  width: 0,
                )
        ],
      );
    }
    return UIGenerator.loading(message: "waiting for first answer...");
  }

  Widget SummaryButtonBar(bool isActive, bool areResultsVisible) {
    return Row(
      children: <Widget>[
        areResultsVisible
            ? UIGenerator.button("Hide Results from Participants", () {
                this.widget.poll.setResultVisibility(false);
              })
            : UIGenerator.button("Show Results to Participants", () {
                this.widget.poll.setResultVisibility(true);
              }),
        SizedBox(
          width: 20,
        ),
        UIGenerator.buttonOutlined("Reset Poll", () {
          this.widget.poll.clearAnswers().then((data) {
            setState(() {
              summary = null;
            });
          });
        }),
        Expanded(child: Container()),
        isActive
            ? UIGenerator.button("End Poll", () {
                this.widget.database.endCurrentPoll();
              })
            : Container()
      ],
    );
  }

  Future<void> setPendingAnswer() async {
    print("---- set pending answer -----");
    await this.widget.poll.submitAnswer(AnswerSTAR_RATING(
        pending: true,
        answer: AnswerEnumSTAR_RATING.ONE,
        respondantId: this.widget.user.id));
    setState(() {});
  }

  Widget StarRatingButton(int value, Function func) {
    bool selected = (value <= this.starHovered);
    return Expanded(
      child: InkWell(
        onTap: func,
        onHover: (data) {
          setState(() {
            this.starHovered = value;
          });
        },
        child: Container(
          color: selected
              ? UIGenerator.yellow.withOpacity(0.3)
              : Color.fromARGB(255, 246, 246, 250),
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: selected
                ? Icon(
                    Icons.star,
                    color: UIGenerator.yellow,
                    size: 32,
                  )
                : Icon(Icons.star_border,
                    color: Color.fromARGB(255, 91, 91, 111), size: 32),
          ),
        ),
      ),
    );
  }

  Widget inActivePoll() {
    return pollSummary();
  }

  @override
  void initState() {
    super.initState();
    // this.summary.hasResultVisibilityPrivilege = false;

    this.userAnswerStream =
        this.widget.poll.getAnswerOfUser(this.widget.user.id);

    this.participantIsActiveStream = this.widget.poll.isActiveStream();

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
