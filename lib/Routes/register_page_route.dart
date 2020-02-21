import 'package:badminton_app/ColorList.dart';
import 'package:flutter/material.dart';
import 'package:badminton_app/constants.dart';
import 'package:badminton_app/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pageOne_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'register_page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email, _pass, _name;
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
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                _name = value;
              },
              decoration: kTextFieldDecoration.copyWith(labelText: 'Full Name'),
            ),
            SizedBox(
              height: 8.0,
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
              text: 'Register',
              onPress: () async {
                if (_name != null) {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: _email, password: _pass);
                    if (newUser != null) {
                      print(newUser.user.email);
                      kEmail = newUser.user.email;
                      kName = _name;
                      _firestore
                          .collection(kEmail)
                          .document('Details')
                          .setData({
                        'Name': kName,
                        'Password': _pass,
                        'Draw': 0,
                        'Lost': 0,
                        'Won': 0,
                        'Matches': 0,
                      });
                      _firestore
                          .collection('allUsers')
                          .document()
                          .setData({'Email': kEmail, 'Name': kName});
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          PageOne.id, (Route<dynamic> route) => false);
                      setState(() {});
                    }
                  } catch (e) {
                    print(e);
                    Fluttertoast.showToast(
                        msg: "Please enter a valid Email and Password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Full name can not be empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
