import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIGenerator {
  static Color green = Color.fromRGBO(132, 210, 132, 1);
  static Color red = Color.fromRGBO(242, 122, 110, 1);
  static Color yellow = Color.fromRGBO(248, 204, 70, 1);

  static Widget logo() {
    return Row(
      children: <Widget>[
        Text(
          "blueberry",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontFamily: 'MontserratAlternates'),
        ),
        Text(
          "poll",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontFamily: 'MontserratAlternates'),
        ),
      ],
    );
  }

  static Widget heading(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 42,
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static Widget normalText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black,
          // fontWeight: FontWeight.w900,
          fontSize: 18,
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static progressBar(int current, int total, Color color, bool disabled, {bool showAmount = false}) {
    if(showAmount){
      return Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[disabled ? UIGenerator.fadedNormalText(current.toString()) : UIGenerator.normalText(current.toString()), SizedBox(width: 8), Expanded(child: UIGenerator.progressBar(current, total, color, disabled, showAmount: false))],);
    }
    if(disabled){
      color = Color.fromRGBO(190, 190, 203, 1);
    }
    return Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: current,
                child: Container(
                    width: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: color,
                    ))),
            Expanded(
                flex: total - current,
                child: Container(
                  width: 15,
                ))
          ],
        ),
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Color.fromRGBO(243, 243, 247, 1),
        ));
  }

  static Widget fadedNormalText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black54,
          // fontWeight: FontWeight.w900,
          fontSize: 18,
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static Widget coloredText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static Widget subtitle(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(144, 144, 157, 1),
          fontWeight: FontWeight.bold,
          fontSize: 22,
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static TextStyle textFeildTextStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 26,
        fontStyle: FontStyle.normal,
        fontFamily: 'Muli');
  }

  static Widget label(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(91, 91, 111, 1),
          fontWeight: FontWeight.bold,
          fontSize: 15,
          letterSpacing: 2,
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static Widget loading({String message}) {
    if (message != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoActivityIndicator(),
            SizedBox(
              height: 12,
            ),
            Text(
              message,
              style: TextStyle(
                  color: Color.fromRGBO(91, 91, 111, 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 2,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Muli'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }

  static Widget button(String text, Function func) {
    return InkWell(
        onTap: func,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          decoration: BoxDecoration(
              color: Color.fromRGBO(250, 160, 138, 1),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: coloredText(text, Colors.white),
        ));
  }
}
