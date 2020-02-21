import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:badminton_app/ColorList.dart';

class MyDashboard extends StatefulWidget {
  static String id = 'dashboard';
  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text(
          'SBI BADMINTON',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  boxedWidget(value: matches.toString(), text: 'Matches Played',),
                  SizedBox(
                    width: 20,
                  ),
                  boxedWidget(value: won.toString(), text: 'Matches Won',),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  boxedWidget(value: lost.toString(), text: 'Matches Lost',),
                  SizedBox(
                    width: 20,
                  ),
                  boxedWidget(value: draw.toString(), text: 'Matches Draw',),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  boxedWidget(value: ((won/matches)*100).toStringAsFixed(1), text: 'Winning Percentage', suffix: '%',),
                  SizedBox(
                    width: 20,
                  ),
                  boxedWidget(value: ((lost/matches)*100).toStringAsFixed(1), text: 'Loosing Percentage', suffix: '%',),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class boxedWidget extends StatelessWidget {
  String value, text, suffix;
  boxedWidget({this.value,this.text, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height / 5),
      width: (MediaQuery.of(context).size.width / 2.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
          BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: value, style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textColor
                  ),),
                  suffix != null?
                  TextSpan(text: suffix, style: TextStyle(fontSize: 20, color: textColor))
                      : TextSpan(text: ''),
                ],
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: textColor
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
