import 'package:badminton_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:badminton_app/ColorList.dart';


class AllUserDetails extends StatefulWidget {
  static String id = 'all_user_details';
  @override
  _AllUserDetailsState createState() => _AllUserDetailsState();
}

class _AllUserDetailsState extends State<AllUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All User Details'),
        elevation: 1,
      ),
      backgroundColor: backgroundColor,
      body: ListView.builder(
        itemCount: userEmail.length,
        itemBuilder: (context, index){
          return playerCard(
            userImgUrl: userImgUrl[index],
            name: userName[index],
            matches: userMPLayed[index],
            won: userMWon[index],
            lost: userMLost[index],
          );
        },
      ),
    );
  }

  Widget playerCard({String userImgUrl, String name, int matches, int won, int lost}){
    return DrawerHeader(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: blackShade,
                  offset: Offset(2, 2),
                  blurRadius: 2),
              BoxShadow(
                  color: whiteShade,
                  offset: Offset(-2, -2),
                  blurRadius: 2),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 24, top: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: <Widget>[
                    userImgUrl!=null?CircleAvatar(
                      radius: 41,
                      backgroundColor: textColor,
                      child: ClipOval(
                        child: Image.network(
                          userImgUrl,
                          height: 76,
                          width: 76,
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
                    ):
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: textColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: blackShade,
                                    offset: Offset(2, 2),
                                    blurRadius: 2),
                                BoxShadow(
                                    color: whiteShade,
                                    offset: Offset(-2, -2),
                                    blurRadius: 2),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Matches     ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$matches',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: blackShade,
                                    offset: Offset(2, 2),
                                    blurRadius: 2),
                                BoxShadow(
                                    color: whiteShade,
                                    offset: Offset(-2, -2),
                                    blurRadius: 2),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Won            ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$won',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: blackShade,
                                    offset: Offset(2, 2),
                                    blurRadius: 2),
                                BoxShadow(
                                    color: whiteShade,
                                    offset: Offset(-2, -2),
                                    blurRadius: 2),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Lost             ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$lost',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
