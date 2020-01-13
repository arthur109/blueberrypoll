import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_poll.dart';

class MainPage extends StatefulWidget {
  DatabaseInterface database;
  UserP user;
  MainPage(this.database, this.user);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool creatingPoll = false;
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: <Widget>[
        Expanded(child: leftColumn()),
        SizedBox(width: 500, child: rightColumn())
      ],
    ));
  }

  Widget leftColumn() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 115, bottom: 40, right: 115),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UIGenerator.logo(),
          Expanded(child: getCorrectScreen()),
        ],
      ),
    );
  }

  Widget getCorrectScreen() {
    return StreamBuilder(
      stream: this.widget.database.getActivePollId(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if ((snapshot.data as String) == "none") {
          if (creatingPoll) {
            return createPollScreen();
          }
          return lastTenPolls();
        } else {
          if (creatingPoll) {
            return cannotCreatePollScreen();
          }
          return viewPollScreen();
        }
      },
    );
  }

  Widget lastTenPolls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UIGenerator.subtitle(
                  "Here's the last 10 polls you participated in"),
              SizedBox(
                height: 20,
              ),
              UIGenerator.heading("Recent Polls")
            ],
          ),
        )
      ],
    );
  }

  Widget rightColumn() {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 45, bottom: 40, right: 70),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[menu(), Expanded(child: participants())],
        ));
  }

  Widget menu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[newButton()],
    );
  }

  Widget newButton() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.add_circle,
            size: 20,
          ),
          SizedBox(
            width: 7,
          ),
          UIGenerator.normalText("New Poll")
        ],
      ),
      onTap: () {
        setState(() {
          creatingPoll = true;
        });
      },
    );
  }

  Widget participants() {
    return ParticipantsView(null, this.widget.database);
  }

  Widget createPollScreen() {
    return CreatePollScreen(this.widget.user, this.widget.database, (){
      setState(() {
        creatingPoll = false;
      });
    });
  }

  Widget cannotCreatePollScreen() {
    return Center(
      child: Text("cannot create poll"),
    );
  }

  Widget viewPollScreen() {
    return Center(
      child: Text("viewing poll"),
    );
  }
}
