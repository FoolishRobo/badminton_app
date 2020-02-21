import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = Firestore.instance;
Future<Null> refreshAllDetails() async {
  print('Hi Im inside the refresh function');
  // getting match details of the logged in user
  await _firestore.collection(kEmail).getDocuments().then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) {
      print('${f.data}');
      //setState(() {
        matches = f.data['Matches'];
        won = f.data['Won'];
        lost = f.data['Lost'];
        draw = f.data['Draw'];
        kName = f.data['Name'];
      //});
    });
  });

  //adding all the users into the list of userName and userEmail
  userName.clear();
  userEmail.clear();
  await _firestore.collection('allUsers').getDocuments().then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f){
      //print('UsernameId data = ${f.data['Name']}');
      userName.add(f.data['Name']);
      //print('${f.data['Name']} added to the userName list');
      //print('UsernameId data = ${f.data['Email']}');
      userEmail.add(f.data['Email']);
      //print('${f.data['Email']} added to the userEmail list');
    });
  });
  print(userEmail);
  for(var players in userEmail)
    {
     await _firestore.collection(players).getDocuments().then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f){
          print('---------------------Leader Board------------------');
          print('User Email id = $players');
          userMPLayed.add(f.data['Matches']);
          print('${f.data['Matches']} added to the userMPlayed list');
          userMWon.add(f.data['Won']);
          print('${f.data['Won']} added to the userMWon list');
          userMLost.add(f.data['Lost']);
          print('${f.data['Lost']} added to the userMLost list');
        });
      });
    }

  //getting the number of matches played in match_counter
  await _firestore
      .collection('Match_Counter')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) {
      print('f = ${f.data}');
      match_counter = f.data['Number'];
      print('Match Counter = $match_counter');
    });
  });
}