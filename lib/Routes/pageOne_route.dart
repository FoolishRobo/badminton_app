import 'dart:io';

import 'package:badminton_app/Routes/all_user_details.dart';
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
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

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
          print('kImageUrl = $kImgUrl');
          _firestore
              .collection(kEmail)
              .document('Details')
              .updateData({'imgUrl': kImgUrl}).whenComplete(() async {
            await prefs.setString(kName + kEmail, kImgUrl);
          }).catchError((err) {
            print('error occures = $err');
          });
        });
      }
    }).whenComplete(() {});
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

  _deleteImage(BuildContext context, bool pop,
      {bool deleteFromFirebaseAndStorage = true}) async {
    print('Deleting Image');
    if (deleteFromFirebaseAndStorage) {
      deleteImageFromFireStoreAndFirebaseStorage();
    }
    await prefs.remove(kName + kEmail);
    setState(() {
      kImgUrl = null;
      newProfileImage = null;
    });
    if (pop) {
      Navigator.of(context).pop();
    }
  }

  Future<void> chooseFromGalleryOrCameraAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    color: textColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Get image from',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
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
                      child: InkWell(
                        onTap: () {
                          _selectImageFromGallery(context).whenComplete(() {
                            uploadImage(newProfileImage);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.photo,
                                color: blueIconColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Gallary'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
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
                      child: InkWell(
                        onTap: () {
                          _captureImageFromCamera(context).whenComplete(() {
                            uploadImage(newProfileImage);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                color: blueIconColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Camera'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
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
                      child: InkWell(
                        onTap: () {
                          _deleteImage(context, true,
                              deleteFromFirebaseAndStorage: true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: blueIconColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Delete Picture'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
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
                _deleteImage(context, false,
                    deleteFromFirebaseAndStorage: false);
                kEmail = 'Database error';
                _auth.signOut();
                //Navigator.pop(context);
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
          : HomePage(),
      drawer: SafeArea(
        child: Drawer(
          elevation: 16,
          child: ListView(
            children: <Widget>[
              drawerHeader(),
              ListTile(
                contentPadding: EdgeInsets.all(8),
                title: Material(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('All Users',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AllUserDetails.id);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.all(8),
                title: Material(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Log Out',
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  _deleteImage(context, false,
                      deleteFromFirebaseAndStorage: false);
                  kEmail = 'Database error';
                  _auth.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, WelcomePage.id);

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerHeader() {
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
              BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
              BoxShadow(
                  color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  kName,
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
                    Stack(
                      children: <Widget>[
                        getProfilePic(),
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
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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

  Widget getProfilePic() {
    if ((kImgUrl == null || kImgUrl == '') &&
        (newProfileImage == null || !newProfileImage.existsSync())) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: backgroundColor,
        child: CircleAvatar(
          radius: 38,
          backgroundColor: textColor,
          child: Icon(Icons.person, size: 40),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 41,
        backgroundColor: textColor,
        child: ClipOval(
          child: newProfileImage == null
              ? Image.network(
                  kImgUrl,
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
                )
              : Image.file(
                  newProfileImage,
                  height: 76,
                  width: 76,
                  fit: BoxFit.cover,
                ),
        ),
      );
    }
  }

  Future _selectImageFromGallery(BuildContext context) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
//    File tempImageCompressed = await FlutterImageCompress.compressAndGetFile(
//      '${tempImage.uri}', '${tempImage.uri}',
//      quality: 88,
//      rotate: 180,
//    );
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
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          mainHeader(),
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
              test();
            },
            child: Container(
              height: 60,
              width: 60,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  void test()async{
    List data = new List();
    List<Map> data1 = new List<Map>();
    await _firestore
        .collection('Match_Details')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        //data.add(f.data);
        //data.add(f.data['t1p1']);

        data1.add({'t1p1' : f.data['t1p1'],
          't1p2' : f.data['t1p2'],
          't2p1' : f.data['t2p1'],
          't2p2' : f.data['t2p2'],
          'mNo' : f.data['mNol'],
        });

        //sleep(Duration(milliseconds: 500));
      });
    }).whenComplete((){
      //data1.add({});
      for(var dataa in data1)
        {
          print(dataa['t1p1']);
        }
      print(data1.length);
    });

    sleep(Duration(seconds: 5));
    //print(data);
  }

  void printless(data){
    print(data);
  }

  Widget getProfilePic() {
    print('kImgUrl = $kImgUrl');
    if (kImgUrl == null || kImgUrl == '') {
      return CircleAvatar(
        radius: 40,
        backgroundColor: backgroundColor,
        child: CircleAvatar(
          radius: 38,
          backgroundColor: textColor,
          child: Icon(Icons.person, size: 40),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: whiteShade,
        child: CircleAvatar(
          radius: 58,
          child: ClipOval(
            child: Image.network(
              kImgUrl,
              height: 112,
              width: 112,
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
            )
          ),
        ),
      );
    }
  }

  Widget mainHeader(){
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: blackShade, offset: Offset(8, 8), blurRadius: 8),
                BoxShadow(
                    color: whiteShade, offset: Offset(-8, -8), blurRadius: 8),
              ],
            ),
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Matches Played',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text('$matches',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Matches Won',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text('$won',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        getProfilePic(),
      ],
    );
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
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            //color: color,
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
  final String text, number;

  ListViewContainer({this.number, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width/2.3 ,
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
