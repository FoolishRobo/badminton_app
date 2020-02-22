
import 'package:badminton_app/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future deleteImage() async {
  final _firestore = Firestore.instance;

  StorageReference reference =
      FirebaseStorage.instance.ref().child(kName + kEmail);

  reference.delete().whenComplete(() {
    print('Image deleted');
  }).catchError((err) {
    print('Error in deleting : $err');
  });
  kImgUrl = null;

  await _firestore
      .collection(kEmail)
      .document('Details')
      .updateData({'imgUrl': null}).whenComplete(() {
    print('imgUrl deleted from firestore');
  });
}
