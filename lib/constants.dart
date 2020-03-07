import 'package:flutter/material.dart';
import 'package:badminton_app/ColorList.dart';

String kImgUrl;
String kEmail='Database Error';
String kName='Database Error';
String kMatchesPlayed = 'Database Error';
String kMatchesWon = 'Database Error';
String kMatchesLost = 'Database Error';
String kMatchesDraw = 'Database Error';

String t1p1,t1p2,t2p1,t2p2,date;
String t1p1email, t1p2email, t2p1email, t2p2email;
String winningScore, loosingScore;

var userName = new List();
var userEmail = new List();
var userMPLayed = new List();
var userMWon = new List();
var userMLost = new List();
var userImgUrl = new List();

int matches, won, lost, draw,match_counter;

bool refreshAllUserDetailsIsUpdating = true;
//bool isLoading = false;


const kButtonTextSize = 20.0;

const kTextFieldDecoration = InputDecoration(
  labelText: '',
  labelStyle: TextStyle(
    color: textColor,
  ),
  hintText: '',
  hintStyle: TextStyle(
    color: textColor,
  ),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: textColor, width: 1.0) ,
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: textColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);


const kSendButtonTextStyle = TextStyle(
  color: backgroundColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  color: backgroundColor,
  boxShadow: [
    BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
    BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
  ],
);
