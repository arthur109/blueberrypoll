import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParticipantsView extends StatefulWidget {
  String pollId;
  DatabaseInterface database;
  ParticipantsView(this.pollId, this.database);
  @override
  _ParticipantsViewState createState() => _ParticipantsViewState();
}

class _ParticipantsViewState extends State<ParticipantsView> {
  @override
  Widget build(BuildContext context) {
    return this.widget.pollId == null ? userOnlineStatusInfo() : userAnswerInfo();
  }

  Widget userAnswerInfo(){

  }

  Widget userOnlineStatusInfo(){
    return StreamBuilder(
      stream: this.widget.database.allUsersStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        List<UserSnapshot> users = snapshot.data;
        if(users == null){
          return UIGenerator.loading(message: "fetching participants");
        }
        List<UserSnapshot> onlineUsers = List();
        for(UserSnapshot i in users){
          if(i.isOnline){
            onlineUsers.add(i);
          }
        }
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 100, bottom: 36),
            child: UIGenerator.subtitle("Participants ("+onlineUsers.length.toString()+")"),
          ),
          Expanded(
                      child: ListView.builder(
              shrinkWrap: true,
              itemCount: onlineUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: Mai,
                      children: <Widget>[
                        Expanded(flex: 3,child: UIGenerator.normalText(onlineUsers[index].name)),
                        Expanded(flex: 2, child: UIGenerator.fadedNormalText("Waiting for poll...")),
                      ],
                    );
                    // Text("hello");
              },
            ),
          ),
         
        ],
      );

      },
    );
    
  }

}