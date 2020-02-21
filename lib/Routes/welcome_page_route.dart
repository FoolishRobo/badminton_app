import 'package:badminton_app/Routes/login_page_route.dart';
import 'pageOne_route.dart';
import 'register_page_route.dart';
import 'package:flutter/material.dart';
import '../rounded_button.dart';
import '../constants.dart';
import 'package:badminton_app/ColorList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomePage extends StatefulWidget {

  static String id = 'welcome_screen';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  void getCurrentUser() async{
    try{
      FirebaseUser user = await _auth.currentUser();
      if(user != null){
        kEmail = user.email;
        //updateValues();
        Navigator.of(context).pushReplacementNamed(PageOne.id);
        //Navigator.pop(context);
        //Navigator.pushNamed(context, PageOne.id);
        print(user.email);
      }
    }
    catch(e){
      print(e);
    }
  }
  
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/pic1.png'),
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              
              Expanded(
                child: Column(
                  children: <Widget>[
                    RoundedButton(
                      color: backgroundColor,
                      text: 'Login',
                      onPress: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                    ),
                    RoundedButton(
                      color: backgroundColor,
                      text: 'Register',
                      onPress: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
