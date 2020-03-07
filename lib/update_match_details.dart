import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = Firestore.instance;

Future updatePlayerDetails() async{
//  print('t1p1 = $t1p1');
//  print('t1p2 = $t1p2');
//  print('t2p1 = $t2p1');
//  print('t2p2 = $t2p2');
//  print('winningScore = $winningScore');
//  print('lossingScore = $loosingScore');
//  print('date = $date');
//  print('Match number = $match_counter');

///mapping username with useEmail
  t1p1email = userEmail[userName.indexOf(t1p1)]; // mapping userName with userEmail
  t1p2email = userEmail[userName.indexOf(t1p2)]; // mapping userName with userEmail
  t2p1email = userEmail[userName.indexOf(t2p1)];  // mapping userName with userEmail
  t2p2email = userEmail[userName.indexOf(t2p2)]; // mapping userName with userEmail

//  print('t1p1 = $t1p1  emaill = $t1p1email');
//  print('t1p2 = $t1p2  emaill = $t1p2email');
//  print('t2p1 = $t2p1  emaill = $t2p1email');
//  print('t2p2 = $t2p2  emaill = $t2p2email');


  await getMatchNumber();
  await updateMatchDetails();
  await updateMatchCounter(match_counter);
  await updateAllPlayerDetails();
}

Future getMatchNumber()async{
  //print('matchCounter before update = $match_counter');
  await _firestore
      .collection('Match_Counter')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) {
      match_counter = f.data['Number'];
    });
  });
}


Future updateAllPlayerDetails() async{
  await updateT1P1MatchPlayed();
  await updateT1P1MatchWon();

  await updateT1P2MatchPlayed();
  await updateT1P2MatchWon();


  await updateT2P1MatchPlayed();
  await updateT2P1MatchLost();

  await updateT2P2MatchPlayed();
  await updateT2P2MatchLost();
}

Future updateT1P1MatchPlayed()async{
  //t1p1 updating
  int t1p1match;
  try{ // geting t1p1match - Matches
    await _firestore
        .collection(t1p1email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t1p1match = f.data['Matches'];
        //print('t1p1match = $t1p1match');
      });
    }).whenComplete(() async {
      try{//updating t1p1match - Matches
        await _firestore.collection(t1p1email).document('Details').updateData(
            {'Matches': (t1p1match+1)}).whenComplete((){
          //print('Match updated');
          //return true;
        });
      }
      catch(e){
        print(e);
      }
    });
  }
  catch(e){
    print(e);
  }
  //return false;
}

Future updateT1P1MatchWon()async{
  int t1p1won;
  try { //getting t1p1won - Won
    await _firestore
        .collection(t1p1email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t1p1won = f.data['Won'];
        //print('t1p1won = $t1p1won');
      });
    }).whenComplete(() async{
      try{//updating t1p1won - Won
        await _firestore.collection(t1p1email).document('Details').updateData(
            {'Won': (t1p1won+1)});
        //print('Won updated');
      }
      catch(e){
        print(e);
      }
    });
  }
  catch(e){
    print(e);
  }
}


Future updateT1P2MatchPlayed()async{
  //t1p2
  int t1p2match;
  try{ // geting t1p2match - Matches
    await _firestore
        .collection(t1p2email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t1p2match = f.data['Matches'];
        //print('t1p2match = $t1p2match');
      });
    }).whenComplete(()async{
      try{//updating t1p1match - Matches
        await _firestore.collection(t1p2email).document('Details').updateData(
            {'Matches': (t1p2match+1)});
        //print('Match updated');
      }
      catch(e){
        print(e);
      }
    });
  }
  catch(e){
    print(e);
  }
}

Future updateT1P2MatchWon()async{
  int t1p2won;
  try { //getting t1p2won - Won
    await _firestore
        .collection(t1p2email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t1p2won = f.data['Won'];
        //print('t1p2won = $t1p2won');
      });
    }).whenComplete(()async{
      try{//updating t1p1won - Won
        await _firestore.collection(t1p2email).document('Details').updateData(
            {'Won': (t1p2won+1)});
        //print('Won updated');
      }
      catch(e){
        print(e);
      }
    });
  }
  catch(e){
    print(e);
  }
}



Future updateT2P1MatchPlayed()async{
  ///t2p1 updating
  int t2p1match;
  try{ /// getting t2p1match - Matches
    await _firestore
        .collection(t2p1email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t2p1match = f.data['Matches'];
        //print('t2p1match = $t2p1match');
      });
    }).whenComplete(()async{
      try{///updating t2p1match - Matches
        await _firestore.collection(t2p1email).document('Details').updateData(
            {'Matches': (t2p1match+1)});
        //print('t2p1 Match updated');
      }
      catch(e){
      }
    });
  }
  catch(e){}

}

Future updateT2P1MatchLost()async{
  int t2p1lost;
  ///getting t2p1 lost
  try{
    await _firestore
        .collection(t2p1email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t2p1lost = f.data['Lost'];
        //print('t2p1lost = $t2p1lost');
      });
    }).whenComplete(()async{
      try{///updating t1p1match - Matches
        await _firestore.collection(t2p1email).document('Details').updateData(
            {'Lost': (t2p1lost+1)});
        //print('t2p1 Lost updated');
      }
      catch(e){}
    });
  }
  catch(e){}
}


Future updateT2P2MatchPlayed()async{
  //t2p2 updating
  int t2p2match;
  try{ // geting t2p2match - Matches
    await _firestore
        .collection(t2p2email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t2p2match = f.data['Matches'];
        //print('t2p2match = $t2p2match');
      });
    }).whenComplete(()async{
      //update t2p2
      try{//updating t2p2match - Matches
        await _firestore.collection(t2p2email).document('Details').updateData(
            {'Matches': (t2p2match+1)});
        //print('t2p2 Match updated');
      }
      catch(e){}
    });
  }
  catch(e){}
}

Future updateT2P2MatchLost()async{
  int t2p2lost;
  try{
    await _firestore
        .collection(t2p2email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        t2p2lost = f.data['Lost'];
        //print('t2p2lost = $t2p2lost');
      });
    }).whenComplete(()async{
      try{//updating t2p2match - Matches
        await _firestore.collection(t2p2email).document('Details').updateData(
            {'Lost': (t2p2lost+1)});
        //print('t2p2 Lost updated');
      }
      catch(e){}
    });
  }
  catch(e){}
}

Future updateMatchCounter(int updatedCounter) async{
  //print('updatedMatchcounter before increment $updatedCounter');
  updatedCounter = updatedCounter + 1;
  //print('updatedcounter after increment $updatedCounter');
  try {
    await _firestore.collection('Match_Counter').document('1').setData(
        {'Number': updatedCounter});
    //print("MatchCounter updated !");
  }
  catch(e){
    //print(e);
  }
}

Future updateMatchDetails() async {
  try {
    await _firestore
        .collection('Match_Details')
        .document(match_counter.toString())
        .setData({
      't1p1': t1p1email,
      't1p2': t1p2email,
      't2p1': t2p1email,
      't2p2': t2p2email,
      'lossingScore': loosingScore,
      'winningScore': winningScore,
      'date': date,
      'Updated By': kEmail,
      'mNo': match_counter,
    });
    //print('Data Succesfully Updated');
  } catch (e) {
    //print(e.toString());
  }
}
