import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/UI/participants_view.dart';
import 'package:blueberrypoll/UI/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePollScreen extends StatefulWidget {
  Function creationCallBack;
  DatabaseInterface database;
  UserP user;
  CreatePollScreen(this.user, this.database,  this.creationCallBack);
  @override
  _CreatePollScreenState createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  AnswerType answerType = AnswerType.YES_NO;
  bool isAnonymous = false;
  bool creatingPoll = false;
  final _formKey = GlobalKey<FormState>();
  final questionTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return this.creatingPoll ? UIGenerator.loading(message: "creating poll") : Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UIGenerator.subtitle("Everyone is waiting!"),
              SizedBox(
                height: 20,
              ),
              UIGenerator.heading("Start a New Poll")
            ],
          ),
        ),
        UIGenerator.label("POLL QUESTION"),
        SizedBox(
          height: 11,
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    color: Color.fromRGBO(243, 243, 247, 1)),
                padding: EdgeInsets.only(top: 8, left: 17, right: 17),
                child: TextFormField(
                  // initialValue: "Arthur F",
                  // autofocus: true,
                  style: UIGenerator.textFeildTextStyle(),
                  controller: questionTextboxController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a question, e.g. "Do you like cats?"';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 45,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: radioList(
                    "POLL ANSWER TYPE",
                    [
                      {'label': "Yes, No", 'value': AnswerType.YES_NO},
                      {'label': "Yes, No, No Opinion", 'value': AnswerType.YES_NO_NOOPINION},
                      {'label': "Text feild", 'value': AnswerType.TEXT_FEILD},
                      {'label': "Star Rating", 'value': AnswerType.STAR_RATING},
                    ],
                    answerType, (data) {
                      setState(() {
                        answerType = data;

                      });
            })),
            Expanded(
                child: radioList(
                    "PRIVACY",
                    [
                      {'label': "Show Names", 'value': false},
                      {'label': "Make Anonymous", 'value': true},
                    
                    ],
                    isAnonymous, (data) {
                      setState(() {
                        isAnonymous = data;
                      });
            })),          ],
        ),
        SizedBox(height: 45,),
        UIGenerator.button("Start Poll", startPoll)
      ],
    );
  }

  void startPoll() async{
    if(_formKey.currentState.validate()){
    setState(() {
      this.creatingPoll = true;
    });
    PollSnapshot newPoll = new PollSnapshot(
      question: questionTextboxController.value.text.trim(),
      answerType: answerType,
      isAnonymous: isAnonymous,
      creatorId: this.widget.user.id
    );

    Poll createdPoll = await this.widget.database.createPoll(newPoll);
    await createdPoll.setAsActive();

    this.widget.creationCallBack();
    
    }
  }

  Widget radioList(String label, List<Map<String, dynamic>> options,
      dynamic groupValue, Function func) {
    List<Widget> content = [
      UIGenerator.label(label),
      SizedBox(
        height: 12,
      )
    ];

    for (Map<String, dynamic> i in options) {
      content.add(Row(
        children: [
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: i["value"],
            groupValue: groupValue,
            onChanged: func,
            activeColor: Colors.black,
          ),
          SizedBox(
            width: 5,
          ),
          UIGenerator.coloredText(i["label"],
              i["value"] == groupValue ? Colors.black : Colors.black54)
        ],
      ));
    }

    return Column(
      children: content,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
