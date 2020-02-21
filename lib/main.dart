import 'package:badminton_app/Routes/dashboard_route.dart';
import 'Routes/match_details_route.dart';
import 'Routes/pageOne_route.dart';
import 'package:badminton_app/Routes/welcome_page_route.dart';
import 'package:flutter/material.dart';
import 'ColorList.dart';
import 'Routes/welcome_page_route.dart';
import 'Routes/login_page_route.dart';
import 'Routes/register_page_route.dart';
import 'Routes/live_chat_route.dart';
import 'Routes/leaderboard_route.dart';
import 'package:badminton_app/Test/test.dart';
import 'package:badminton_app/Routes/match_history.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static String id = 'MainPageId';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: textColor,
          ),
        ),
        primaryIconTheme: IconThemeData(
          color: textColor,
        ),
        fontFamily: 'Dosis',
        backgroundColor: backgroundColor,
      ),
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id:(context) => WelcomePage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        PageOne.id: (context) => PageOne(),
        LiveChat.id: (context) => LiveChat(),
        MatchDetails.id: (context) => MatchDetails(),
        MyDashboard.id: (context) => MyDashboard(),
        MatchHistory.id: (context) => MatchHistory(),
        Leaderboard.id: (context) => Leaderboard(),
      },
    );
  }
}
