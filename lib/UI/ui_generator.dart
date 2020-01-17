import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIGenerator {
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
