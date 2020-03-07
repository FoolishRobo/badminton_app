import 'package:badminton_app/ColorList.dart';
import 'package:badminton_app/constants.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  static String id = 'user_profile';

  final int index;

  UserProfile({this.index});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('${userName[widget.index]}\'s Profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 40),
            child: Column(
              children: <Widget>[

                getHeaderProfileBar(),

                SizedBox(height: 20),

                Center(
                  child: Text(
                    userName[widget.index],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 40,),

                getMatchesCard(),

                SizedBox(height: 20,),

                bottomCardsOne(true),

                SizedBox(height: 20,),

                bottomCardsOne(false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getMatchesCard(){
    return Container(
      height: MediaQuery.of(context).size.height*.18,
      width: MediaQuery.of(context).size.height*.4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: blackShade,
              offset: Offset(4, 4),
              blurRadius: 8),
          BoxShadow(
              color: whiteShade,
              offset: Offset(-4, -4),
              blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${userMPLayed[widget.index]}',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text('Matches Played',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomCardsOne(bool first){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*.18,
          width: MediaQuery.of(context).size.height*.18,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: blackShade,
                  offset: Offset(4, 4),
                  blurRadius: 8),
              BoxShadow(
                  color: whiteShade,
                  offset: Offset(-4, -4),
                  blurRadius: 8),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(first?'${userMWon[widget.index]}'
                  :(userMPLayed[widget.index] != 0
                    ?(((userMWon[widget.index]/userMPLayed[widget.index])*100).toStringAsFixed(1))+' %'
                    :'0 %'),
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(first?'Matches Won':'Win Percentage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height*.18,
          width: MediaQuery.of(context).size.height*.18,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: blackShade,
                  offset: Offset(4, 4),
                  blurRadius: 8),
              BoxShadow(
                  color: whiteShade,
                  offset: Offset(-4, -4),
                  blurRadius: 8),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(first?'${userMLost[widget.index]}'
                :(userMPLayed[widget.index]!=0
                  ?(((userMLost[widget.index]/userMPLayed[widget.index])*100).toStringAsFixed(1))+' %'
                  :'0 %'),
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(first?'Matches Lost':'Lost Percentage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getHeaderProfileBar(){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: blackShade,
                  offset: Offset(4, 4),
                  blurRadius: 12),
              BoxShadow(
                  color: whiteShade,
                  offset: Offset(-4, -4),
                  blurRadius: 12),
            ],
          ),
        ),
        getProfilePicture(),
      ],
    );
  }

  Widget getProfilePicture(){
    return Center(
      child: userImgUrl[widget.index]!=null
          ?CircleAvatar(
            radius: 84,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(userImgUrl[widget.index]),
            ),
          )
          :CircleAvatar(
            radius: 84,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              radius: 80,
              child: Icon(Icons.person,size: 120, color: blueIconColor,),
            ),
          ),
    );
  }
}
