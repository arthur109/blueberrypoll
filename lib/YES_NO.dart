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
  const YesNoPoll({Key key, this.pollID, this.inSession}) : super(key: key);
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
          if (snapshot.hasData) {}
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
