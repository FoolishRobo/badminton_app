import 'package:badminton_app/ColorList.dart';
import 'package:badminton_app/Routes/leaderboard_route.dart';
import 'package:badminton_app/Routes/match_history.dart';
import 'package:badminton_app/Routes/dashboard_route.dart';
import 'package:badminton_app/Routes/live_chat_route.dart';
import 'match_details_route.dart';
import 'package:badminton_app/refresh_all_details.dart';
import 'package:badminton_app/Routes/welcome_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badminton_app/constants.dart';
import 'dart:async';

class PageOne extends StatefulWidget {
  static String id = 'pageOne';
  @override
  _PageOneState createState() => _PageOneState();
}

final _firestore = Firestore.instance;

class _PageOneState extends State<PageOne> {
  bool loading = true;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setState(() {
      refreshAllDetails();
    });
    updateDetailsForPageOne().whenComplete((){
      setState(() {
        loading = false;
      });
    });
  }

  Future<Null> updateDetailsForPageOne() async {
    // getting match details of the logged in user
    _firestore.collection(kEmail).getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print('${f.data}');
        setState(() {
          matches = f.data['Matches'];
          won = f.data['Won'];
          lost = f.data['Lost'];
          draw = f.data['Draw'];
          kName = f.data['Name'];
        });
      });
    });

    //adding all the users into the list of userName and userEmail
    userName.clear();
    userEmail.clear();
    _firestore
        .collection('allUsers')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        //print('UsernameId data = ${f.data['Name']}');
        userName.add(f.data['Name']);
        //print('${f.data['Name']} added to the userName list');
        //print('UsernameId data = ${f.data['Email']}');
        userEmail.add(f.data['Email']);
        //print('${f.data['Email']} added to the userEmail list');
      });
    });

    //getting the number of matches played in match_counter
    await _firestore
        .collection('Match_Counter')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print('f = ${f.data}');
        match_counter = f.data['Number'];
        print('Match Counter = $match_counter');
      });
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print('loggedin.email = ${loggedInUser.email}');
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                loading = true;
                refreshAllDetails().whenComplete((){
                  setState(() {
                    loading = false;
                  });
                });
              });
            },
//            child: Icon(
//              Icons.autorenew,
//              size: 30,
//            ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(30),boxShadow: [
                BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
                BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
              ],
              ),
            child: Icon(
              Icons.autorenew,
              size: 30,
              ),
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: InkWell(
              onTap: () {
                _auth.signOut();
                kEmail = 'Database error';
                Navigator.pop(context);
                Navigator.pushNamed(context, WelcomePage.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(30),boxShadow: [
                    BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
                    BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
                  ],
                  ),
                  child: Icon(
                    Icons.block,
                    color: Colors.redAccent[100],
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'SBI BADMINTON',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loading? Center(child: CircularProgressIndicator()):Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      kName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            ListViewContainer(
                                number: matches.toString(),
                                text: 'Matches Played'),
                            SizedBox(width: 5,),
                            ListViewContainer(
                                number: won.toString(), text: 'Matches Won'),
                            SizedBox(width: 5,),
                            ListViewContainer(
                                number: lost.toString(), text: 'Matches Lost'),
                            SizedBox(width: 5,),
                            ListViewContainer(
                                number: draw.toString(), text: 'Matches Draw'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), //Top Part
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
//                  Material(
//                    borderRadius: BorderRadius.circular(30),
//                    color: whiteShade,
//                    child: Container(
//                      height: 8,
//                      width: 150,
//                    ),
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
                  BottomButtons(
                    text: 'Live Chat',
                    onClick: () {
                      Navigator.pushNamed(context, LiveChat.id);
                    },
                    color: backgroundColor,
                    icon1: Icons.chat,
                    icon2: Icons.arrow_forward_ios,
                  ), //Live Chat
                  SizedBox(
                    height: 10,
                  ),
                  BottomButtons(
                    text: 'My Dashboard',
                    onClick: () {
                      Navigator.pushNamed(context, MyDashboard.id);
                    },
                    color: backgroundColor,
                    icon1: Icons.dashboard,
                    icon2: Icons.arrow_forward_ios,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BottomButtons(
                    text: 'Add Match Details',
                    onClick: () {
                      //Navigator.pushNamed(context, Test.id);
                      Navigator.pushNamed(context, MatchDetails.id);
                    },
                    color: backgroundColor,
                    icon1: Icons.add_circle_outline,
                    icon2: Icons.arrow_forward_ios,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BottomButtons(
                    text: 'Matche History',
                    onClick: () {
                      Navigator.pushNamed(context, MatchHistory.id);
                    },
                    color: backgroundColor,
                    icon1: Icons.web,
                    icon2: Icons.arrow_forward_ios,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ), //Bottom Part
        ],
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  String text;
  Function onClick;
  Color color;
  IconData icon1;
  IconData icon2;
  BottomButtons({this.text, this.onClick, this.color, this.icon1, this.icon2});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
              BoxShadow(color: whiteShade, offset: Offset(-4, -4), blurRadius: 2),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  icon1,
                  color: blueIconColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  icon2,
                  color: blueIconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListViewContainer extends StatelessWidget {
  String text, number;

  ListViewContainer({this.number, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 160,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
            BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                number,
                style: TextStyle(
                  color: textColor,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
