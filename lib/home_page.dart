import 'dart:async';
import 'dart:ui';
import 'package:blueberrypoll/new_poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'online_users_list.dart';

import 'session_info.dart';

class HomePage extends StatefulWidget {
  static StreamController<bool> creatingPollStream =
      StreamController<bool>.broadcast();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QueryEvent> pollInSessionStream = SessionInfo.database
            .ref(SessionInfo.organization + "/poll_in_session")
            .onValue.asBroadcastStream();


  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: mainPanel()),
        Column(
          children: <Widget>[
            newPollButton(),
            OnlineUsersList(),
          ],
        )
      ],
    ));
  }

  Widget mainPanel() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: HomePage.creatingPollStream.stream.distinct(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return NewPollMenu();
        } else {
          return showPoll();
        }
      },
    );
  }

  Widget newPollButton() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(Icons.add_circle),
          SizedBox(width: 8),
          Text("New Poll")
        ],
      ),
      onTap: () => setState(() {
        HomePage.creatingPollStream.sink.add(true);
      }),
    );
  }

  Widget showPoll() {
    return StreamBuilder<QueryEvent>(
        stream: pollInSessionStream, // a Stream<int> or null
        builder: (BuildContext context, AsyncSnapshot<QueryEvent> snapshot) {
          if (snapshot.hasData) {
            String pollId = snapshot.data.snapshot.val();
            if (pollId == "none") {
              return noPollInSession();
            } else {
              return StreamBuilder<QueryEvent>(
                  stream: SessionInfo.database
                      .ref(SessionInfo.organization +
                          "/polls/" +
                          pollId +
                          '/type')
                      .onValue, // a Stream<int> or null
                  builder: (BuildContext context,
                      AsyncSnapshot<QueryEvent> snapshot) {
                    if (snapshot.hasData) {
                      String pollType = snapshot.data.snapshot.val();
                      if (pollType == AnswerType.YES_NO.toString()) {
                        return Text("yes no poll");
                      } else if (pollType ==
                          AnswerType.YES_NO_NOOPINION.toString()) {
                        return Text("yes no opinion poll");
                      } else if (pollType == AnswerType.TEXT_FEILD.toString()) {
                        return Text("text feild poll");
                      } else if (pollType ==
                          AnswerType.STAR_RATING.toString()) {
                        return Text("star rating poll");
                      }
                    } else {
                      return CupertinoActivityIndicator();
                    }
                  });
            }
          } else {
            return noPollInSession();
          }
        });
  }

  Widget noPollInSession() {
    return Text("No Poll In Session Widget");
  }

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = SessionInfo.database.ref(
        SessionInfo.organization + '/users/' + SessionInfo.userID + '/online');
    ref.set(true);
    ref.onDisconnect().set(false);
  }
}
