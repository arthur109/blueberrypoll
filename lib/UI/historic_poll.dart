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

class HistoricPoll extends StatefulWidget {
  String pollId;
  DatabaseInterface database;
  UserP user;
  HistoricPoll(this.pollId, this.user, this.database);

  @override
  _HistoricPollState createState() => _HistoricPollState();
}

class _HistoricPollState extends State<HistoricPoll> {
  bool highlighted = false;
  Poll poll;
  Future pollInfoFetchFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pollInfoFetchFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MouseRegion(
                onHover: (event) {
                  setState(() {
                    highlighted = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    highlighted = false;
                  });
                },
                child: Container(
                  color: UIGenerator.lightGrey,
                  child: Column(
                    children: <Widget>[],
                  )
                ));
          }else{
            return Container(
                  child: UIGenerator.loading(),
                  color: UIGenerator.lightGrey,
                );
          }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    poll = new Poll(id: this.widget.pollId, database: this.widget.database);
    pollInfoFetchFuture = poll.initializeConstantData();
  }
}
