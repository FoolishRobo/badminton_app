import 'package:flutter/material.dart';
import 'ColorList.dart';


// Widget for displaying username and emain of players in the AddMatchDetail.dart page

class UserList extends StatelessWidget {
  String name,email;

  UserList({this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),),
              Text(email,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
