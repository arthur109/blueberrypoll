import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/UI/main_page.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/poll_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoricPollInfoView extends StatefulWidget {
  String pollId;
  DatabaseInterface database;
  String userId;
  bool isAdmin;
  HistoricPollInfoView(this.pollId, this.userId, this.database, this.isAdmin);

  @override
  _HistoricPollInfoViewState createState() => _HistoricPollInfoViewState();
}

class _HistoricPollInfoViewState extends State<HistoricPollInfoView> {
  Poll poll;
  Stream<PollSnapshot> isHiddenStream;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: <Widget>[
        Expanded(child: leftColumn()),
        SizedBox(width: UIGenerator.toUnits(500), child: rightColumn())
      ],
    ));
  }

  Widget leftColumn() {
    return Padding(
      padding: EdgeInsets.only(
          top: UIGenerator.toUnits(40),
          left: UIGenerator.toUnits(115),
          bottom: UIGenerator.toUnits(40),
          right: UIGenerator.toUnits(115)),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buttonBar(),
          // UIGenerator.coloredText("VIEWING HISTORIC POLL", Colors.black),
          Expanded(
              child: PollView(
                  this.widget.pollId,
                  UserP(id: this.widget.userId, database: this.widget.database),
                  this.widget.database)),
        ],
      ),
    );
  }

  Widget rightColumn() {
    return Padding(
        padding: EdgeInsets.only(
            top: UIGenerator.toUnits(40),
            left: UIGenerator.toUnits(45),
            bottom: UIGenerator.toUnits(40),
            right: UIGenerator.toUnits(70)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ParticipantsView(
                this.widget.pollId, this.widget.userId, this.widget.database)
          ],
        ));
  }

  Widget buttonBar() {
    return Row(
      children: <Widget>[
        exitButton(),
        SizedBox(
          width: UIGenerator.toUnits(24),
        ),
        this.widget.isAdmin ? hidenToggleButton() : Container(),
        SizedBox(
          width: UIGenerator.toUnits(24),
        ),
        this.widget.isAdmin ? deleteButton() : Container()
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget exitButton() {
    return InkWell(
      
       borderRadius:
                BorderRadius.all(Radius.circular(UIGenerator.toUnits(6))),
        
      hoverColor: UIGenerator.orange,
      onTap: () {
        Navigator.of(context).pop(false);
      },
      child: Ink(
        padding: EdgeInsets.symmetric(
            vertical: UIGenerator.toUnits(7),
            horizontal: UIGenerator.toUnits(10)),
        decoration: BoxDecoration(
            color: Colors.black,
             borderRadius:
                BorderRadius.all(Radius.circular(UIGenerator.toUnits(7))),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: UIGenerator.toUnits(20),
            ),
            SizedBox(
              width: UIGenerator.toUnits(6),
            ),
            UIGenerator.coloredText("Exit Summary View", Colors.white)
          ],
        ),
      ),
    );
  }

  Widget deleteButton() {
    return InkWell(
       borderRadius:
                BorderRadius.all(Radius.circular(UIGenerator.toUnits(6))),
      hoverColor: UIGenerator.orange,
      onTap: () async {
        await this.widget.database.deletePoll(this.widget.pollId);
        Navigator.of(context).pop(true);
      },
      child: Ink(
        
        padding: EdgeInsets.symmetric(
            vertical: UIGenerator.toUnits(7),
            horizontal: UIGenerator.toUnits(10)),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius:
                BorderRadius.all(Radius.circular(UIGenerator.toUnits(7)))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: UIGenerator.toUnits(20),
            ),
            SizedBox(
              width: UIGenerator.toUnits(6),
            ),
            UIGenerator.coloredText("Delete Poll", Colors.white)
          ],
        ),
      ),
    );
  }

  Widget hidenToggleButton() {
    return StreamBuilder(
        stream: isHiddenStream,
        builder: (BuildContext context, AsyncSnapshot<PollSnapshot> snapshot) {
          if (snapshot.hasData) {
            bool isHidden = (snapshot.data.isHidden == true);
            return InkWell(
               borderRadius:
                BorderRadius.all(Radius.circular(UIGenerator.toUnits(6))),
              hoverColor: UIGenerator.orange,
              onTap: isHidden ? unhidePoll : hidePoll,
              child: Ink(
                padding: EdgeInsets.symmetric(
                    vertical: UIGenerator.toUnits(7),
                    horizontal: UIGenerator.toUnits(10)),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                        Radius.circular(UIGenerator.toUnits(7)))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      isHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                      size: UIGenerator.toUnits(20),
                    ),
                    SizedBox(
                      width: UIGenerator.toUnits(6),
                    ),
                    UIGenerator.coloredText(
                        isHidden ? "Unhide Poll" : "Hide Poll",
                        Colors.white)
                  ],
                ),
              ),
            );
          } else {
            return UIGenerator.loading(message: "getting info...");
          }
        });
  }

  void hidePoll() {
    poll.setHiddenState(true);
  }

  void unhidePoll() {
    poll.setHiddenState(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    poll = new Poll(id: this.widget.pollId, database: this.widget.database);
    isHiddenStream = poll.allInfoStream;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
