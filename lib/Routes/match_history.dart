import 'package:flutter/material.dart';
import 'package:badminton_app/ColorList.dart';
import 'package:badminton_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

final _firestore = Firestore.instance;
String sort = 'date';

class MatchHistory extends StatefulWidget {
  static String id = 'all_matches_route';
  @override
  _MatchHistoryState createState() => _MatchHistoryState();
}

class _MatchHistoryState extends State<MatchHistory> {
  //static Timer timer;
  //static Duration durations = wait();

  String dropdownValue = 'Date';
  List <String> spinnerItems = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Date',
    'Updated by',
  ] ;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text(
          'Matche Hisotry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            DropdownButton(
              value: dropdownValue,
              icon: Icon(
                Icons.sort,
                color: blueIconColor,
              ),
              iconSize: 24,
              elevation: 5,
              style: TextStyle(color: textColor, fontSize: 18),
              underline: Container(
                height: 0,
              ),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                  updateSortingValue(dropdownValue);
                });
              },
              items:
                  spinnerItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            MessageStream(_firestore, wait()),
          ],
        ),
      ),
    );
  }

   Timer timer;
   Duration duration = Duration();
   wait() {
    if (timer == null || !timer.isActive) {
      timer = Timer(Duration(microseconds: 1000), () {
        duration = Duration();
      });
    }
    duration += Duration(milliseconds: 100);
    return duration;
  }

}




void updateSortingValue(String dropdownValue){
  if(dropdownValue == 'Player 1'){
    sort = 't1p1';
  }
  else if(dropdownValue == 'Player 2'){
    sort = 't1p2';
  }
  else if(dropdownValue == 'Player 3'){
    sort = 't2p1';
  }
  else if(dropdownValue == 'Player 4'){
    sort = 't2p2';
  }
  else if(dropdownValue == 'Date'){
    sort = 'date';
  }
  else if(dropdownValue == 'Updated by'){
    sort = 'Updated By';
  }
}

class MessageStream extends StatefulWidget {

  final Firestore _firestore;
  final Duration time;

  MessageStream(this._firestore,this.time);
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._firestore
          .collection("Match_Details")
          .orderBy(sort, descending: true)
          .snapshots(), //arranging messages based on date
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: backgroundColor,
            ),
          );
        }
        final messages = snapshot.data.documents;
        print('message = $messages');
        print('message length = ${messages.length}');
        List<MatchScoreCard> matchScoreCard = <MatchScoreCard>[];
        for (var message in messages) {
          final t1p1 = message.data['t1p1'];
          final t1p2 = message.data['t1p2'];
          final t2p1 = message.data['t2p1'];
          final t2p2 = message.data['t2p2'];
          final date = message.data['date'];
          final wScore = message.data['winningScore'];
          final lScore = message.data['lossingScore'];
          final updatedBy = message.data['Updated By'];
//          print('------------------------------------------------');
//          print('t1p1 = $t1p1');
//          print('t1p2 = $t1p2');
//          print('t2p1 = $t2p1');
//          print('t2p2 = $t2p2');
//          print('Date = $date');
//          print('wScore = $wScore');
//          print('lScore = $lScore');
//          print('updated by = $updatedBy');
          final scoreCardDetails = MatchScoreCard(
            t1p1: t1p1,
            t1p2: t1p2,
            t2p1: t2p1,
            t2p2: t2p2,
            date: date,
            wSore: wScore,
            lSore: lScore,
            updatedBy: updatedBy,
            time: widget.time,
          );
          matchScoreCard.add(scoreCardDetails);
        }
        return Expanded(
          child: ListView(
            children: matchScoreCard,
          ),
        );
      },
    );
  }
}

class MatchScoreCard extends StatefulWidget {
  const MatchScoreCard({
    @required this.t1p1,
    @required this.t1p2,
    @required this.t2p1,
    @required this.t2p2,
    @required this.wSore,
    @required this.lSore,
    @required this.date,
    @required this.updatedBy,
    @required this.time,
  });

  final t1p1, t1p2, t2p1, t2p2, wSore, lSore, date, updatedBy;
  final Duration time;

  @override
  _MatchScoreCardState createState() => _MatchScoreCardState();
}

class _MatchScoreCardState extends State<MatchScoreCard> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation animation;
  Timer timer;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: -1, end: 0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));
    timer = Timer(widget.time, animationController.forward);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child){
      return Transform(
        transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
              boxShadow: [
                BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
                BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${widget.wSore}  :  ${widget.lSore}',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        userName[userEmail.indexOf(widget.t1p1)],
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userName[userEmail.indexOf(widget.t2p1)],
                        style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        userName[userEmail.indexOf(widget.t1p2)],
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userName[userEmail.indexOf(widget.t2p2)],
                        style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.date,
                        style: TextStyle(color: textColor, fontSize: 12),
                      ),
                      Text(
                        'Update by : ${userName[userEmail.indexOf(widget.updatedBy)]}',
                        style: TextStyle(color: textColor, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  },
    );
  }
}
