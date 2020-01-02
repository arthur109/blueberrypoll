import 'dart:async';
import 'dart:ui';
import 'package:blueberrypoll/YES_NO.dart';
import 'package:blueberrypoll/new_poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'home_page.dart';
import 'online_users_list.dart';

import 'session_info.dart';

class CurrentPollViewer extends StatefulWidget {
  @override
  CurrentPollViewerState createState(){
    print("state created--------");
    return CurrentPollViewerState();
    }
}

class CurrentPollViewerState extends State<CurrentPollViewer> {

   Stream<QueryEvent> pollInSessionStream = SessionInfo.database
            .ref(SessionInfo.organization + "/poll_in_session")
            .onValue.asBroadcastStream();

  int counter = 0;

  @override
  Widget build(BuildContext context) {
       return StreamBuilder<QueryEvent>(
        stream: pollInSessionStream, // a Stream<int> or null
        builder: (BuildContext context, AsyncSnapshot<QueryEvent> snapshot) {
          counter ++;
          print("--- Poll in Session Changed");
          print(counter);
          if (snapshot.hasData) {
            print("stream has data");
            String pollID = snapshot.data.snapshot.val();
            if (pollID == "none") {
              return noPollInSession();
            } else {
              return StreamBuilder<QueryEvent>(
                  stream: SessionInfo.database
                      .ref(SessionInfo.organization +
                          "/polls/" +
                          pollID +
                          '/type')
                      .onValue, // a Stream<int> or null
                  builder: (BuildContext context,
                      AsyncSnapshot<QueryEvent> snapshot) {
                    if (snapshot.hasData) {
                      String pollType = snapshot.data.snapshot.val();
                      if (pollType == AnswerType.YES_NO.toString()) {
                        return YesNoPoll(pollID, true);
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
            print(snapshot.data);
            print("no data in stream");
            return noPollInSession();
          }
        });
  }

   Widget noPollInSession() {
    return Text("No Poll In Session Widget");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("state init----------");
  }

}