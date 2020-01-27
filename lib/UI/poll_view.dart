import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/star_rating_poll.dart';
import 'package:blueberrypoll/UI/text_feild_poll.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:blueberrypoll/UI/yes_no_noopinion.dart';
import 'package:blueberrypoll/UI/yes_no_poll.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';

import 'create_poll.dart';

class PollView extends StatefulWidget {
  String pollId;
  DatabaseInterface database;
  UserP user;
  PollView(this.pollId, this.user, this.database);
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  Poll poll;
  Future pollInfoFetchFuture;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pollInfoFetchFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (poll.answerType == AnswerType.YES_NO) {
            return YesNoPoll(this.poll, this.widget.user, this.widget.database);
          } else  if (poll.answerType == AnswerType.YES_NO_NOOPINION) {
            return YesNoNoOpinionPoll(this.poll, this.widget.user, this.widget.database);
          } else  if (poll.answerType == AnswerType.TEXT_FEILD) {
            return TextFeildPoll(this.poll, this.widget.user, this.widget.database);
          }else  if (poll.answerType == AnswerType.STAR_RATING) {
            return StarRatingPoll(this.poll, this.widget.user, this.widget.database);
          } else {
            return Text("poll type not implemented - "+poll.answerType.toString());
          }
        }
        return UIGenerator.loading(message: "fetching poll info");
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    poll = new Poll(id: this.widget.pollId, database: this.widget.database);
    pollInfoFetchFuture = poll.initializeConstantData();
  }
}
