import 'package:badminton_app/Routes/master_page.dart';

import 'pageOne_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../rounded_button.dart';
import 'package:badminton_app/ColorList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _pass;

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/pic1.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                _email = value;
              },
              decoration: kTextFieldDecoration.copyWith(labelText: 'Email ID'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
                _pass = value;
              },
              decoration: kTextFieldDecoration.copyWith(labelText: 'Password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                color: backgroundColor,
                text: 'Log In',
                onPress: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: _email, password: _pass);
                    if (user != null) {
                      print(user.user.email);
                      kEmail = user.user.email;
                      Navigator.of(context).pushNamedAndRemoveUntil(MasterPage.id, (Route<dynamic> route) => false);
                      //Navigator.of(context).pushReplacementNamed(PageOne.id);
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "Wrong Email Password combination",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
