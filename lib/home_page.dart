import 'dart:async';
import 'dart:ui';
import 'package:blueberrypoll/YES_NO.dart';
import 'package:blueberrypoll/new_poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'online_users_list.dart';
import 'poll_in_session_viewer.dart';

import 'session_info.dart';

class HomePage extends StatefulWidget {
  static StreamController<bool> creatingPollStream =
      StreamController<bool>.broadcast();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CurrentPollViewer currentPollViewer = new CurrentPollViewer();

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
          return currentPollViewer;
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

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = SessionInfo.database.ref(
        SessionInfo.organization + '/users/' + SessionInfo.userID + '/online');
    ref.set(true);
    ref.onDisconnect().set(false);
  }
}
