import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/UI/historic_poll_info.dart';
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
  bool isAdmin;
  HistoricPoll(this.pollId, this.userId, this.database, this.isAdmin);

  @override
  _HistoricPollState createState() => _HistoricPollState();
}

class _HistoricPollState extends State<HistoricPoll> {
  bool highlighted = false;
  Poll poll;
  Stream<PollSnapshot> pollSnapshotStream;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: StreamBuilder(
          stream: pollSnapshotStream,
          builder:
              (BuildContext context, AsyncSnapshot<PollSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if(snapshot.hasData){
                if((snapshot.data.isHidden == true) && (!this.widget.isAdmin)){
                  return showNothing();
                }
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
                            Cupertino.Row(
                              children: <Cupertino.Widget>[
                                (snapshot.data.isHidden == true)
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            right: UIGenerator.toUnits(8)),
                                        child: Icon(
                                          Icons.visibility_off,
                                          color: highlighted
                                              ? Colors.white
                                              : Colors.black,
                                          size: UIGenerator.toUnits(20),
                                        ),
                                      )
                                    : Container(),
                                UIGenerator.coloredBoldText(
                                    snapshot.data.question,
                                    highlighted ? Colors.white : Colors.black),
                              ],
                            ),
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
              }else{
                return showNothing();
              }
            } else {
              return Container(
                padding:
                    EdgeInsets.symmetric(vertical: UIGenerator.toUnits(26)),
                child: UIGenerator.loading(),
                color: UIGenerator.lightGrey,
              );
            }
          }),
      onTap: showPollInfo,
    );
  }

  Widget showNothing(){
    return SizedBox(width: 0, height: 0,);
  }
  void showPollInfo() async {
    final context = MainPage.navKey.currentState.overlay.context;

    Cupertino.showCupertinoDialog<bool>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return HistoricPollInfoView(this.widget.pollId, this.widget.userId,
            this.widget.database, this.widget.isAdmin);
        //  return Cupertino.CupertinoAlertDialog<NUll(actions: <Widget>[],)
      },
    );
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
    poll = new Poll(id: this.widget.pollId, database: this.widget.database);

    pollSnapshotStream = poll.allInfoStream.asBroadcastStream();
    pollSnapshotStream.listen((PollSnapshot event) {
      print("snapshot updated: " + event.question);
    });
  }
}
