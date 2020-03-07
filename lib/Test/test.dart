
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = Firestore.instance;



Future printDetails(String email) async{
  int matches = 0, won=0, lost=0;
  _firestore.collection("Match_Details").getDocuments().then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) {
      if(f.data['t1p1'] == email){
        matches++;
        won++;
      }
      else if(f.data['t1p2'] == email){
        matches++;
        won++;
      }
      else if(f.data['t2p1'] == email){
        matches++;
        lost++;
      }
      else if(f.data['t2p2'] == email){
        matches++;
        lost++;
      }

    });
  }).whenComplete((){
    print('--------------------- $email -------------------------');
    print('matches = $matches');
    print('won = $won');
    print('lost = $lost');
  });
}