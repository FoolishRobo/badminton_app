import 'package:badminton_app/ColorList.dart';
import 'package:badminton_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MyProfile extends StatefulWidget {
  static String id = 'my_profile';
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('My Profile'),
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
                    kName,
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
          Text('$matches',
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
              Text(first?'$won'
                  :(matches != 0
                  ?(((won/matches)*100).toStringAsFixed(1))+' %'
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
              Text(first?'${lost}'
                  :(matches!=0
                  ?(((lost/matches)*100).toStringAsFixed(1))+' %'
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
//    return Center(
//      child: kImgUrl!=null
//          ?CircleAvatar(
//        radius: 84,
//        backgroundColor: Colors.blue,
//        child: CircleAvatar(
//          radius: 80,
//          child: CachedNetworkImage(
//            imageUrl: kImgUrl,
//            imageBuilder: (context, imageProvider) => Container(
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: imageProvider,
//                    fit: BoxFit.cover,
//                    colorFilter:
//                    ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
//              ),
//            ),
//            placeholder: (context, url) => CircularProgressIndicator(),
//            errorWidget: (context, url, error) => Icon(Icons.error),
//          ),
//            //NetworkImage(kImgUrl,),
//        ),
//      )
//          :CircleAvatar(
//        radius: 84,
//        backgroundColor: Colors.blue,
//        child: CircleAvatar(
//          radius: 80,
//          child: Icon(Icons.person,size: 120, color: blueIconColor,),
//        ),
//      ),
//    );
    if (kImgUrl == null || kImgUrl == '') {
      return CircleAvatar(
        radius: 84,
        backgroundColor: backgroundColor,
        child: CircleAvatar(
          radius: 80,
          backgroundColor: textColor,
          child: Icon(Icons.person, size: 40),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 84,
        backgroundColor: textColor,
        child: ClipOval(
          child: Image.network(
            kImgUrl,
            height: 160,
            width: 160,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.white),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
