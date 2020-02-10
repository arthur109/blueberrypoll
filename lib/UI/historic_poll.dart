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

class HistoricPoll extends StatefulWidget {
  String pollId;
  DatabaseInterface database;
  String userId;
  HistoricPoll(this.pollId, this.userId, this.database);

  @override
  _HistoricPollState createState() => _HistoricPollState();
}

class _HistoricPollState extends State<HistoricPoll> {
  bool highlighted = false;
  Future<PollSnapshot> poll;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: FutureBuilder(
          future: poll,
          builder:
              (BuildContext context, AsyncSnapshot<PollSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
              String timeText = timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(snapshot.data.timestamp));
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
                      color: highlighted
                          ? UIGenerator.orange
                          : UIGenerator.lightGrey,
                      child: Cupertino.Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: UIGenerator.toUnits(31),
                            horizontal: UIGenerator.toUnits(40)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            UIGenerator.coloredBoldText(snapshot.data.question,
                                highlighted ? Colors.white : Colors.black),
                            SizedBox(
                              height: UIGenerator.toUnits(7),
                            ),
                            FutureBuilder(
                              future: getSubtitle(snapshot.data),
                              initialData: "...",
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return UIGenerator.coloredThinText(
                                    snapshot.data,
                                    highlighted
                                        ? Colors.white
                                        : UIGenerator.grey);
                              },
                            ),
                          ],
                        ),
                      )));
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(26)),
                child: UIGenerator.loading(),
                color: UIGenerator.lightGrey,
              );
            }
          }),
      onTap: showPollInfo,
    );
  }

  void showPollInfo() {
    final context = MainPage.navKey.currentState.overlay.context;
    
    Cupertino.showCupertinoDialog<Null>(
    context: context,
    // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Material(
        child: Row(
      children: <Widget>[
        Expanded(child: leftColumn()),
        SizedBox(width: UIGenerator.toUnits(500), child: rightColumn())
      ],
    ));

      //  return Cupertino.CupertinoAlertDialog<NUll(actions: <Widget>[],)
        
    },
  );
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
          exitButton(),
          // UIGenerator.coloredText("VIEWING HISTORIC POLL", Colors.black),
          Expanded(child: PollView(this.widget.pollId, UserP(id: this.widget.userId, database: this.widget.database), this.widget.database)),
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
           
            
            ParticipantsView(this.widget.pollId,
            this.widget.userId, this.widget.database)],
        ));
  }

  Widget exitButton(){
    return InkWell(
      onTap:(){ Navigator.of(context).pop();},
      child: Container(
          padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(7), horizontal: UIGenerator.toUnits(10)),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(UIGenerator.toUnits(6)))),
          child:Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Icon(Icons.arrow_back, color: Colors.white, size: UIGenerator.toUnits(20),), SizedBox(width: UIGenerator.toUnits(6),), UIGenerator.coloredText("Exit Summary View", Colors.white)],),
        ),);
  }

  Future<String> getSubtitle(PollSnapshot snapshot) async {
    String timeText =
        timeago.format(DateTime.fromMillisecondsSinceEpoch(snapshot.timestamp));
    String creatorName =
        await UserP(id: snapshot.creatorId, database: this.widget.database)
            .getName();
    String participantCount = snapshot.answers.length.toString();
    DateTime tempd = DateTime.fromMillisecondsSinceEpoch(snapshot.timestamp);
    String date = tempd.month.toString() +
        " / " +
        tempd.day.toString() +
        " / " +
        tempd.year.toString();
    return timeText +
        " by " +
        creatorName +
        " with " +
        participantCount +
        " participants - " +
        date;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    poll = new Poll(id: this.widget.pollId, database: this.widget.database)
        .getSnapshot();
  }
}
