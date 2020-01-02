import 'dart:async';
import 'dart:ui';
import 'package:blueberrypoll/new_poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'ui_generator.dart';
import 'online_users_list.dart';

import 'session_info.dart';

class YesNoPoll extends StatefulWidget {
  final String pollID;
  final bool inSession;
  const YesNoPoll(this.pollID, this.inSession);
  @override
  _YesNoPollState createState() => _YesNoPollState();
}

class _YesNoPollState extends State<YesNoPoll> {
  Stream<QueryEvent> pollStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueryEvent>(
        stream: pollStream, // a Stream<int> or null
        builder: (BuildContext context, AsyncSnapshot<QueryEvent> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                UIGenerator.pollHeader(snapshot.data.snapshot.val(), widget.inSession),
                UIGenerator.pollManager(widget.pollID, snapshot.data.snapshot.val(), widget.inSession)
              ],
            );
          }else{
            return CupertinoActivityIndicator();
          }
        });
  }


 


  @override
  void initState() {
    super.initState();
    pollStream = SessionInfo.database
        .ref('${SessionInfo.organization}/polls/' + widget.pollID)
        .onValue;
  }
}
