import 'dart:async';
import 'dart:ui';
import 'package:blueberrypoll/new_poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'online_users_list.dart';

import 'session_info.dart';

class UIGenerator {
  static Widget title(String text) {
    return Text(text);
  }

  static Widget subtitle(String text) {
    return Text(text);
  }

  static Widget pollHeader(Map pollInfo, bool inSession) {
    String subtitleText;
    if (inSession) {
      if (isCreator(pollInfo)) {
        subtitleText = "Viewing results for the poll";
      } else {
        if (alreadyAnsweredPoll(pollInfo["answers"])) {
          if (pollInfo["results_visible"]) {
            subtitleText = "Viewing results for the poll";
          } else {
            subtitleText = "Waiting for results to be revealed for the poll";
          }
        } else {
          subtitleText = "Currently polling";
        }
      }
    } else {
      if (isCreator(pollInfo)) {
        subtitleText = "Viewing results for the poll";
      } else {
        if (pollInfo["results_visible"]) {
          subtitleText = "Viewing results for the poll";
        } else {
          subtitleText = "Waiting for results to be revealed for the poll";
        }
      }
    }

    return Column(
      children: <Widget>[subtitle(subtitleText), title(pollInfo["question"])],
    );
  }

  static Widget pollManager(String pollID, Map pollInfo, bool inSession) {
    if (isCreator(pollInfo)) {
      return Row(
        children: <Widget>[
          resultsVisibleToggleButton(pollID, pollInfo),
          resetPollButton(pollID)
        ],
      );
    } else {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  static bool alreadyAnsweredPoll(List<Map> answers) {
    for (Map i in answers) {
      if (i['respondant'] == SessionInfo.userID) {
        return true;
      }
    }
    return false;
  }

  static Widget resetPollButton(String pollID) {
    return CupertinoButton(
      child: Text("Reset Poll"),
      onPressed: () {
        SessionInfo.database
            .ref(SessionInfo.organization + '/polls/' + pollID + '/answers')
            .set([]);
      },
    );
  }

  static Widget resultsVisibleToggleButton(String pollID, Map pollInfo) {
    if (pollInfo["results_visible"]) {
      return CupertinoButton.filled(
        child: Text("Hide Results from Participants"),
        onPressed: () {
          SessionInfo.database
              .ref(SessionInfo.organization +
                  '/polls/' +
                  pollID +
                  '/results_visible')
              .set(false);
        },
      );
    }
    return CupertinoButton.filled(
      child: Text("Show Results to Participants"),
      onPressed: () {
        SessionInfo.database
            .ref(SessionInfo.organization +
                '/polls/' +
                pollID +
                '/results_visible')
            .set(true);
      },
    );
  }

  static Widget endPollButton(String pollID, bool inSession) {
    if (inSession) {
      return CupertinoButton.filled(
        child: Text("End Poll"),
        onPressed: () {
          SessionInfo.database
              .ref(SessionInfo.organization + '/poll_in_session/')
              .set("none");
        },
      );
    }

    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  static bool isCreator(Map pollInfo) {
    return pollInfo["creator"] == SessionInfo.userID;
  }
}
