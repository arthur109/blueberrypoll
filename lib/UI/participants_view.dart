import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';

class ParticipantsView extends StatefulWidget {
  String pollId;
  String userId;
  DatabaseInterface database;
  ParticipantsView(this.pollId, this.userId, this.database);
  @override
  _ParticipantsViewState createState() => _ParticipantsViewState();
}

class _ParticipantsViewState extends State<ParticipantsView> {
  String prevId;
  Poll poll;
  Future pollInfoFetchFuture;
  Stream pollSnapshotStream;

  @override
  Widget build(BuildContext context) {
    if(this.widget.pollId != this.prevId){
      initPoll();
    }

    return this.widget.pollId != null
        ? userAnswerInfo()
        : userOnlineStatusInfo();
  }

  Widget userAnswerInfo() {
    print("User Answer Info Widget");
    print(this.widget.pollId);
    return FutureBuilder(
      future: pollInfoFetchFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: pollSnapshotStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                PollSnapshot info = snapshot.data;
                bool showResults = (this.poll.isCreator(this.widget.userId) ||
                    info.areResultsVisible);
                bool showNames = !info.isAnonymous;
                List<Answer> answers = info.answers;

                return Expanded(
                                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: UIGenerator.toUnits(100), bottom: UIGenerator.toUnits(26)),
                        child: UIGenerator.subtitle(
                            "Participants (" + answers.length.toString() + ")"),
                      ),
                      Expanded(
                        child: Cupertino.ListView.builder(
                          shrinkWrap: true,
                          itemCount: answers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(10)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                // mainAxisAlignment: Mai,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: showNames
                                        ? StreamBuilder(
                                            stream: UserP(
                                                    id: answers[index].respondantId,
                                                    database: this.widget.database)
                                                .name,
                                            initialData: "...",
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              return Container(
                                                child: UIGenerator.normalText(
                                                    snapshot.data),
                                              );
                                            },
                                          )
                                        : UIGenerator.normalText("Anonymous"),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: 
                                      answers[index].pending ?  UIGenerator.fadedNormalText("answering poll...") : showResults ? displayAnswer(answers[index]) : UIGenerator.fadedNormalText("answer hidden")),
                                ],
                              ),
                            );
                            // Text("hello");
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return UIGenerator.loading(message: "fetching answers b");
              }
            },
          );
        }
        return UIGenerator.loading(message: "fetching answers a");
      },
    );
  }

  Widget displayAnswer(Answer globalAnswer){
    if(globalAnswer.type == AnswerType.YES_NO){
      AnswerYES_NO answer = globalAnswer as AnswerYES_NO;
      if(answer.answer == AnswerEnumYES_NO.YES){
        return UIGenerator.coloredText("Yes", UIGenerator.green);
      }else if(answer.answer == AnswerEnumYES_NO.NO){
        return UIGenerator.coloredText("No", UIGenerator.red);
      }
    }else if(globalAnswer.type == AnswerType.YES_NO_NOOPINION){
      AnswerYES_NO_NOOPINION answer = globalAnswer as AnswerYES_NO_NOOPINION;
      if(answer.answer == AnswerEnumYES_NO_NOOPINION.YES){
        return UIGenerator.coloredText("Yes", UIGenerator.green);
      }else if(answer.answer == AnswerEnumYES_NO_NOOPINION.NO){
        return UIGenerator.coloredText("No", UIGenerator.red);
      }else if(answer.answer == AnswerEnumYES_NO_NOOPINION.NOOPINION){
        return UIGenerator.coloredText("No Opinion", UIGenerator.yellow);
      }
    }else if(globalAnswer.type == AnswerType.STAR_RATING){
      AnswerSTAR_RATING answer = globalAnswer as AnswerSTAR_RATING;
      if(answer.answer == AnswerEnumSTAR_RATING.ONE){
        return UIGenerator.StarRatingAnswerDisplay(1, false);
      } else if(answer.answer == AnswerEnumSTAR_RATING.TWO){
        return UIGenerator.StarRatingAnswerDisplay(2, false);
      } else if(answer.answer == AnswerEnumSTAR_RATING.THREE){
        return UIGenerator.StarRatingAnswerDisplay(3, false);
      } else if(answer.answer == AnswerEnumSTAR_RATING.FOUR){
        return UIGenerator.StarRatingAnswerDisplay(4, false);
      } else if(answer.answer == AnswerEnumSTAR_RATING.FIVE){
        return UIGenerator.StarRatingAnswerDisplay(5, false);
      }
    }else if(globalAnswer.type == AnswerType.TEXT_FEILD){
      AnswerTEXT_FEILD answer = globalAnswer as AnswerTEXT_FEILD;
      return UIGenerator.normalText(answer.answer);
    } 
  }

  Widget userOnlineStatusInfo() {
    return StreamBuilder(
      stream: this.widget.database.allUsersStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<UserSnapshot> users = snapshot.data;
        if (users == null) {
          return UIGenerator.loading(message: "fetching participants");
        }
        List<UserSnapshot> onlineUsers = List();
        for (UserSnapshot i in users) {
          if (i.isOnline) {
            onlineUsers.add(i);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: UIGenerator.toUnits(100), bottom: UIGenerator.toUnits(26)),
              child: UIGenerator.subtitle(
                  "Participants (" + onlineUsers.length.toString() + ")"),
            ),
            Expanded(
              child: Cupertino.ListView.builder(
                shrinkWrap: true,
                itemCount: onlineUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: Mai,
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child:
                                UIGenerator.normalText(onlineUsers[index].name)),
                        Expanded(
                            flex: 2,
                            child: UIGenerator.fadedNormalText(
                                "Waiting for poll...")),
                      ],
                    ),
                  );
                  // Text("hello");
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void initPoll(){
    prevId = this.widget.pollId;
    if (this.widget.pollId != null) {
      print("-- initializing poll --");
      poll = new Poll(id: this.widget.pollId, database: this.widget.database);
      pollInfoFetchFuture = poll.initializeConstantData();
      pollSnapshotStream = this.poll.allInfoStream;
    }else{
      print("poll not initilized");
      print(this.widget.pollId);
    }
  }

  @override
  void initState() {
    print("----------------- initiated ----------");
    // TODO: implement initState
    super.initState();
    initPoll();
  }
}
