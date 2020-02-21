import 'package:flutter/material.dart';
import 'package:badminton_app/constants.dart';
import 'package:badminton_app/ColorList.dart';

class Leaderboard extends StatefulWidget {
  static String id = 'leaderboard_route';
  @override
  _LeadeboardState createState() => _LeadeboardState();
}

class _LeadeboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              listWidget(text: 'Matches Played',info: 'Sorts players based on number of matches played',),
              SizedBox(
                height: 20,
              ),
              listWidget(text: 'Matches Won',info: 'Sorts players based on number of matches won',),
              SizedBox(
                height: 20,
              ),
              listWidget(text: 'Matches Lost',info: 'Sorts players based on number of matches lost',),
              SizedBox(
                height: 20,
              ),
              listWidget(text: 'Winning Percentage',info: 'Sorts players based on winning percentage',),
              SizedBox(
                height: 20,
              ),
              listWidget(text: 'Loosing Percentage',info: 'Sorts players based on loosing percentage',),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class listWidget extends StatelessWidget {
  String text, info;

  listWidget({this.text, this.info});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.info,size: 12,color: Colors.white,),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      info,
                      style: TextStyle(fontSize: 12,
                      color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
