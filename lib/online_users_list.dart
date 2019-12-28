import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';

import 'session_info.dart';

class OnlineUsersList extends StatefulWidget {
  @override
  _OnlineUsersListState createState() => _OnlineUsersListState();
}

class _OnlineUsersListState extends State<OnlineUsersList> {
  DatabaseReference ref =
      SessionInfo.database.ref(SessionInfo.organization + "/users");

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: 100,
          maxWidth: 500
        ),
        child: StreamBuilder<QueryEvent>(
          stream: ref
              .orderByChild('online')
              .equalTo(true)
              .onValue, // a Stream<int> or null
          builder: (BuildContext context, AsyncSnapshot<QueryEvent> snapshot) {
            if (snapshot.hasData) {
              Map values = snapshot.data.snapshot.val();
              return new ListView.builder(
                shrinkWrap: true,
                itemCount: values.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = values.keys.elementAt(index);
                  return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(values[key]['name'] + "   "),
                    Text(
                      'Waiting for a poll...',
                      style: TextStyle(color: Colors.black54),
                    )
                  ]);
                },
              );
              // return Text("Participants Loaded");
            } else {
              return Text("Loading participants...");
            }
          },
        ));
  }
}
