import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/UI/admin_page.dart';
import 'package:blueberrypoll/UI/historic_poll.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/poll_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';

import 'create_poll.dart';

class MainPage extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();

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
        SizedBox(width: UIGenerator.toUnits(500), child: rightColumn())
      ],
    ));
  }

  Widget leftColumn() {
    return Padding(
      padding: EdgeInsets.only(
          top: UIGenerator.toUnits(40),
          left: UIGenerator.toUnits(115),
          bottom: UIGenerator.toUnits(40),
          right: UIGenerator.toUnits(115)),
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
      stream: this.widget.database.getActivePollId().distinct(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return UIGenerator.loading();
        } else if ((snapshot.data as String) == "none") {
          if (creatingPoll) {
            return createPollScreen();
          }
          return lastTenPolls();
        } else {
          if (creatingPoll) {
            return cannotCreatePollScreen();
          }
          return viewPollScreen(snapshot.data);
        }
      },
    );
  }

  Widget lastTenPolls() {
    return FutureBuilder(
      future: Future.wait([this.widget.database.lastTenPolls(), this.widget.database.isAdmin(this.widget.user)]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> keys = List.from(snapshot.data[0].keys.toList().reversed);
          if (keys.length == 0) {
            return Center(
                child: UIGenerator.coloredBoldText(
                    "No polls have been created.", UIGenerator.grey));
          }
          return ListView.builder(
            itemCount: keys.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: UIGenerator.toUnits(100)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                UIGenerator.subtitle(
                                    "Here's the last 10 polls that occured"),
                                SizedBox(
                                  height: UIGenerator.toUnits(20),
                                ),
                                UIGenerator.heading("Recent Polls"),
                              ]),
                        ],
                      ),
                    )
                  ],
                );
              }
              return HistoricPoll(
                  keys[index - 1], this.widget.user.id, this.widget.database, snapshot.data[1]);
            },
          );
        } else {
          return UIGenerator.loading(message: "getting history");
        }
      },
    );
  }

  Widget rightColumn() {
    return Padding(
        padding: EdgeInsets.only(
            top: UIGenerator.toUnits(40),
            left: UIGenerator.toUnits(45),
            bottom: UIGenerator.toUnits(40),
            right: UIGenerator.toUnits(70)),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[menu(), Expanded(child: participants())],
        ));
  }

  Widget menu() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      StreamBuilder(
          stream: this.widget.database.getActivePollId(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == "none") {
                return newButton(true);
              } else {
                return FutureBuilder(
                  future:
                      Poll(id: snapshot.data, database: this.widget.database)
                          .getSnapshot(),
                  builder: (BuildContext context,
                      AsyncSnapshot<PollSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if ((DateTime.now().millisecondsSinceEpoch -
                              snapshot.data.timestamp) >
                          60000 * 10) {
                        return endPollButton();
                      }
                    }
                    return newButton(false);
                  },
                );
              }
            } else {
              return newButton(false);
            }
          }),
      FutureBuilder(
        future: this.widget.database.isAdmin(this.widget.user),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data) {
            return Cupertino.Padding(
              padding: const EdgeInsets.only(left: 16),
              child: adminSettingsButton(),
            );
          }
          return SizedBox(
            height: 0,
            width: 0,
          );
        },
      )
    ]);
  }

  Widget endPollButton() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.archive,
            size: UIGenerator.toUnits(20),
            color: UIGenerator.red,
          ),
          SizedBox(
            width: 7,
          ),
          UIGenerator.coloredText("End Current Poll", UIGenerator.red)
        ],
      ),
      onTap: () {
        this.widget.database.endCurrentPoll();
      },
    );
  }

  Widget newButton(bool active) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.add_circle,
            size: UIGenerator.toUnits(20),
            color: active ? Colors.black : UIGenerator.grey,
          ),
          SizedBox(
            width: 7,
          ),
          active
              ? UIGenerator.normalText("New Poll")
              : UIGenerator.fadedNormalText("New Poll")
        ],
      ),
      onTap: active
          ? () {
              setState(() {
                creatingPoll = true;
              });
            }
          : () {},
    );
  }

  Widget adminSettingsButton() {
    return InkWell(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.lock,
              size: UIGenerator.toUnits(20),
              color: Colors.black,
            ),
            SizedBox(
              width: 7,
            ),
            UIGenerator.normalText("Admin Controls")
          ],
        ),
        onTap: () {
          final context = MainPage.navKey.currentState.overlay.context;

          Cupertino.showCupertinoDialog<Null>(
            context: context,
            // barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AdminSettings(this.widget.database);
              //  return Cupertino.CupertinoAlertDialog<NUll(actions: <Widget>[],)
            },
          );
        });
  }

  Widget participants() {
    return StreamBuilder(
      stream: this.widget.database.getActivePollId(),
      initialData: "none",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print("-  - - ");
        print(snapshot.data);
        return ParticipantsView(snapshot.data == "none" ? null : snapshot.data,
            this.widget.user.id, this.widget.database);
      },
    );
  }

  Widget createPollScreen() {
    return CreatePollScreen(this.widget.user, this.widget.database, () {
      setState(() {
        creatingPoll = false;
      });
    });
  }

  Widget cannotCreatePollScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(100)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UIGenerator.subtitle("Action invalid"),
              SizedBox(
                height: UIGenerator.toUnits(20),
              ),
              UIGenerator.heading("Poll Already in Session")
            ],
          ),
        ),
        UIGenerator.label(
            "You cannot create a new poll because one is already in session."),
        SizedBox(
          height: UIGenerator.toUnits(45),
        ),
        UIGenerator.button("Continue", () {
          setState(() {
            creatingPoll = false;
          });
        })
      ],
    );
  }

  Widget viewPollScreen(String pollId) {
    return PollView(pollId, this.widget.user, this.widget.database);
  }
}
