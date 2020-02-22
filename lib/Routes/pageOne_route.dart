import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:badminton_app/ColorList.dart';
import 'package:badminton_app/Routes/match_history.dart';
import 'package:badminton_app/Routes/dashboard_route.dart';
import 'package:badminton_app/Routes/live_chat_route.dart';
import 'match_details_route.dart';
import 'package:badminton_app/refresh_all_details.dart';
import 'package:badminton_app/Routes/welcome_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badminton_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badminton_app/modify_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageOne extends StatefulWidget {
  static String id = 'pageOne';
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> with SingleTickerProviderStateMixin {
  SharedPreferences prefs;
  bool isLoading = false;
  File newProfileImage;
  bool loading = true;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    refreshCurrentUserDetails().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
    refreshAllDetails();
  }
  Future uploadImage(File avatarImageFile) async {
    print('------------------- inside uploadImage --------------------');
    final _firestore = Firestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    StorageReference reference =
    FirebaseStorage.instance.ref().child(kName + kEmail);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    await uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          kImgUrl = downloadUrl;
          print('Photourl = $kImgUrl');
          _firestore
              .collection(kEmail)
              .document('Details')
              .updateData({'imgUrl': kImgUrl}).whenComplete(() async {
            await prefs.setString('imgUrl', kImgUrl);
            print('Uploaded to storage, firestore and added to sharedPrefs');
          }).catchError((err) {
            print('error occures = $err');
          });
        });
      }
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.image) {
          _handleImage(response);
        }
      });
    } else {
      _handleError(response);
    }
  }

  _handleError(LostDataResponse response) {
    print('Error geting picture ${response.exception}');
  }

  _handleImage(LostDataResponse response) {
    newProfileImage = response.file;
  }

  void getCurrentUser() async {
    prefs = await SharedPreferences.getInstance();
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

  Future _selectImageFromGallery(BuildContext context) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfileImage = tempImage;
    });
    Navigator.of(context).pop();
  }

  Future _captureImageFromCamera(BuildContext context) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      newProfileImage = tempImage;
    });
    Navigator.of(context).pop();
  }

  _deleteImage(BuildContext context) async {
    deleteImage().whenComplete(() async {
      await prefs.remove('imgUrl').whenComplete(() {
        setState(() {
          kImgUrl = null;
          print('SharedPref deleted = $kImgUrl');
        });

      });
    });
    bool deletedOrNot = await prefs.remove('imgUrl').catchError((err) {
      print('SharedPref delete error : $err');
    });
    print('deletedOrNot = $deletedOrNot');
    Navigator.of(context).pop();
  }

  Future<void> chooseFromGalleryOrCameraAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Get image from',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _selectImageFromGallery(context).whenComplete(() {
                        uploadImage(newProfileImage);
                      });
                    },
                    child: Text('Gallary'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      _captureImageFromCamera(context).whenComplete(() {
                        uploadImage(newProfileImage);
                      });
                    },
                    child: Text('Camera'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      _deleteImage(context);
                    },
                    child: Text('Delete picture'),
                  ),
                ],
              ),
            ),
          );
        });
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
                refreshCurrentUserDetails().whenComplete(() {
                  setState(() {
                    loading = false;
                  });
                });
                refreshAllDetails();
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
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: blackShade, offset: Offset(2, 2), blurRadius: 2),
                    BoxShadow(
                        color: whiteShade,
                        offset: Offset(-2, -2),
                        blurRadius: 2),
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
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ListViewContainer(
                                      number: won.toString(),
                                      text: 'Matches Won'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ListViewContainer(
                                      number: lost.toString(),
                                      text: 'Matches Lost'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ListViewContainer(
                                      number: draw.toString(),
                                      text: 'Matches Draw'),
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
      drawer: SafeArea(
        child: Drawer(
          elevation: 5,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: textColor,
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        kName,
                        style: TextStyle(
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              getPorfilePic(),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    chooseFromGalleryOrCameraAlert(context);
                                  },
                                  child: Opacity(
                                    opacity: newProfileImage != null ? 0.8 : 1,
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: whiteShade,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget getPorfilePic() {
    print('--------------------------- getProfPic ---------------------------');
    print('kImgUrl == null = ${kImgUrl == null}');
    print("kImgUrl == '' = ${kImgUrl == ''}");
    print('newProfileImage == null = ${newProfileImage == null}');
    //print('!newProfileImage.existsSync() = ${!newProfileImage.existsSync()}');
    print('newProfileImage==null = ${newProfileImage == null}');
    if((kImgUrl == null || kImgUrl == '') && (newProfileImage == null || !newProfileImage.existsSync()) ){
      return CircleAvatar(
        radius: 40,
        backgroundColor: backgroundColor,
        child: CircleAvatar(
          radius: 38,
          backgroundColor: textColor,
          child: Icon(Icons.person, size: 40),
        ),
      );
    }
    else{
      return CircleAvatar(
        radius: 40,
        backgroundColor: whiteShade,
        child: ClipOval(
          child: newProfileImage==null?Image.network(
            kImgUrl,
            height: 76,
            width: 76,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
              if (loadingProgress == null)
                return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ): Image.file(newProfileImage,height: 76,width: 76, fit: BoxFit.cover,),
        ),
      );
    }
  }
}



class BottomButtons extends StatelessWidget {
  final String text;
  final Function onClick;
  final Color color;
  final IconData icon1;
  final IconData icon2;
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
              BoxShadow(
                  color: whiteShade, offset: Offset(-4, -4), blurRadius: 2),
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
