import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';

class UIGenerator {
  static Color green = Color.fromRGBO(132, 210, 132, 1);
  static Color red = Color.fromRGBO(242, 122, 110, 1);
  static Color yellow = Color.fromRGBO(248, 204, 70, 1);
  static Color orange = Color.fromRGBO(250, 160, 138, 1);
  static Color grey = Color.fromRGBO(190, 190, 203, 1);
  static Color lightGrey = Color.fromARGB(255, 246, 246, 250);
  static double width;

  static double toUnits(double value){
    return ((value/1920)*width).roundToDouble();
  }
  static Widget logo() {
    return Row(
      children: <Widget>[
        Text(
          "blueberry",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: UIGenerator.toUnits(24),
              fontStyle: FontStyle.normal,
              fontFamily: 'MontserratAlternates'),
        ),
        Text(
          "poll",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: UIGenerator.toUnits(24),
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
          fontSize: UIGenerator.toUnits(42),
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
          fontSize: UIGenerator.toUnits(18),
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
        children: <Widget>[disabled ? UIGenerator.fadedNormalText(current.toString()) : UIGenerator.normalText(current.toString()), SizedBox(width: UIGenerator.toUnits(8)), Expanded(child: UIGenerator.progressBar(current, total, color, disabled, showAmount: false))],);
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
                    width: UIGenerator.toUnits(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(UIGenerator.toUnits(100))),
                      color: color,
                    ))),
            Expanded(
                flex: total - current,
                child: Container(
                  width: UIGenerator.toUnits(15),
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
          fontSize: UIGenerator.toUnits(18),
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
          fontSize: UIGenerator.toUnits(20),
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
          fontSize: UIGenerator.toUnits(22),
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static TextStyle textFeildTextStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: UIGenerator.toUnits(26),
        fontStyle: FontStyle.normal,
        fontFamily: 'Muli');
  }

  static Widget label(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(91, 91, 111, 1),
          fontWeight: FontWeight.bold,
          fontSize: UIGenerator.toUnits(15),
          letterSpacing: UIGenerator.toUnits(2),
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
            Cupertino.CupertinoActivityIndicator(
            ),
            SizedBox(
              height: UIGenerator.toUnits(12),
            ),
            Text(
              message,
              style: TextStyle(
                  color: Color.fromRGBO(91, 91, 111, 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: UIGenerator.toUnits(15),
                  letterSpacing: UIGenerator.toUnits(2),
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Muli'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Cupertino.CupertinoActivityIndicator(),
    );
  }

  static Widget button(String text, Function func) {
    return InkWell(
        onTap: func,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(14), horizontal: UIGenerator.toUnits(30)),
          decoration: BoxDecoration(
              color: UIGenerator.orange,
              borderRadius: BorderRadius.all(Radius.circular(UIGenerator.toUnits(6)))),
          child: coloredText(text, Colors.white),
        ));
  }

  static Widget coloredBoldText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: UIGenerator.toUnits(22),
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static Widget coloredThinText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.normal,
          fontSize: UIGenerator.toUnits(18),
          fontStyle: FontStyle.normal,
          fontFamily: 'Muli'),
    );
  }

  static Widget buttonOutlined(String text, Function func) {
    return InkWell(
        onTap: func,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: UIGenerator.toUnits(14), horizontal: UIGenerator.toUnits(30)),
          decoration: BoxDecoration(
            border: Border.all(color: UIGenerator.orange, width: UIGenerator.toUnits(2)),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(UIGenerator.toUnits(6)))),
          child: coloredText(text, UIGenerator.orange),
        ));
  }

  static Widget StarRatingAnswerDisplay(int value, bool disabled){
    Widget highlighted = Icon(Icons.star, color: disabled ?  UIGenerator.grey : UIGenerator.yellow,);
    Widget notHighlighted = Icon(Icons.star_border, color:  UIGenerator.grey);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      UIGenerator.coloredText(value.toString(), disabled ? UIGenerator.grey : UIGenerator.yellow),
      SizedBox(width: 6,),
      1 <= value ? highlighted : notHighlighted,
      SizedBox(width: 8,),
      2 <= value ? highlighted : notHighlighted,
      SizedBox(width: 8,),
      3 <= value ? highlighted : notHighlighted,
      SizedBox(width: 8,),
      4 <= value ? highlighted : notHighlighted,
      SizedBox(width: 8,),
      5 <= value ? highlighted : notHighlighted
    ],);
  }

  
}
