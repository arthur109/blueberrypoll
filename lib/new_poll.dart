import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase/firebase.dart';

import 'session_info.dart';

class NewPollMenu extends StatefulWidget {
  @override
  _NewPollMenuState createState() => _NewPollMenuState();
}

class _NewPollMenuState extends State<NewPollMenu> {
  final TextEditingController _controller = new TextEditingController();

  AnswerType answerType = AnswerType.YES_NO;
  PrivacyType privacyType = PrivacyType.SHOW_NAMES;
  DatabaseReference ref =
      SessionInfo.database.ref(SessionInfo.organization + "/poll_in_session");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: StreamBuilder<QueryEvent>(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<QueryEvent> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.snapshot.val().toString() == "none") {
              return newPollMenu();
            } else {
              return cannotCreatePoll();
            }
          } else {
            return Text("Loading Poll Info...");
          }
        },
      ),
    );
  }
// HomePage.creatingPollStream.sink.add(true);

  Widget cannotCreatePoll() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("You cannot create a new poll because one is already in session."),
        SizedBox(
          height: 8,
        ),
        RaisedButton(
          child: Text("OK"),
          color: Colors.orange,
          onPressed: () {
            HomePage.creatingPollStream.sink.add(false);
          },
        )
      ],
    );
  }

  Widget newPollMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Start a New Poll"),
        SizedBox(
          height: 16,
        ),
        Text("Poll Question"),
        TextField(
          controller: _controller,
        ),
        SizedBox(
          height: 36,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text("Poll Answer Type"),
                    RadioListTile<AnswerType>(
                      title: const Text('Yes, No'),
                      value: AnswerType.YES_NO,
                      groupValue: answerType,
                      onChanged: (AnswerType value) {
                        setState(() {
                          answerType = value;
                        });
                      },
                    ),
                    RadioListTile<AnswerType>(
                      title: const Text('Yes, No, No Opinion'),
                      value: AnswerType.YES_NO_NOOPINION,
                      groupValue: answerType,
                      onChanged: (AnswerType value) {
                        setState(() {
                          answerType = value;
                        });
                      },
                    ),
                    RadioListTile<AnswerType>(
                      title: const Text('Text Feild'),
                      value: AnswerType.TEXT_FEILD,
                      groupValue: answerType,
                      onChanged: (AnswerType value) {
                        setState(() {
                          answerType = value;
                        });
                      },
                    ),
                    RadioListTile<AnswerType>(
                      title: const Text('Star Rating'),
                      value: AnswerType.STAR_RATING,
                      groupValue: answerType,
                      onChanged: (AnswerType value) {
                        setState(() {
                          answerType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text("Privacy"),
                    RadioListTile<PrivacyType>(
                      title: const Text('Show Names'),
                      value: PrivacyType.SHOW_NAMES,
                      groupValue: privacyType,
                      onChanged: (PrivacyType value) {
                        setState(() {
                          privacyType = value;
                        });
                      },
                    ),
                    RadioListTile<PrivacyType>(
                      title: const Text('Make Anonymous'),
                      value: PrivacyType.ANONYMOUS,
                      groupValue: privacyType,
                      onChanged: (PrivacyType value) {
                        setState(() {
                          privacyType = value;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        RaisedButton(
          child: Text("Start Poll"),
          color: Colors.orange,
          onPressed: () async {
            print("poll " +
                (await createPoll(_controller.text.toString().trim(),
                    answerType, privacyType)) +
                " created");
            HomePage.creatingPollStream.sink.add(false);
          },
        )
      ],
    );
  }

  Future<String> createPoll(
      String question, AnswerType answerType, PrivacyType privacyType) async {
    Map poll = {
      "question": question,
      "type": answerType.toString(),
      "creator": SessionInfo.userID,
      "results_visible": false,
      "timestamp": new DateTime.now().millisecondsSinceEpoch,
      "anonymous": privacyType.toString(),
      "answers": []
    };

    String newPollID = SessionInfo.database
        .ref(SessionInfo.organization + '/polls')
        .push()
        .key;

    await SessionInfo.database
        .ref(SessionInfo.organization + '/polls/' + newPollID)
        .set(poll);

    await SessionInfo.database
        .ref(SessionInfo.organization + '/poll_in_session')
        .set(newPollID);

    return newPollID;
  }
}
