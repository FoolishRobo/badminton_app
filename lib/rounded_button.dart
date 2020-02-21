import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:badminton_app/ColorList.dart';

class RoundedButton extends StatelessWidget {

  final Color color;
  final Function onPress;
  final String text;

  RoundedButton({this.color, this.text, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
            BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
          ],
        ),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: kButtonTextSize,
            ),
          ),
        ),
      ),
    );
  }
}
