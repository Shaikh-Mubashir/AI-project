import 'package:chat/models/userDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Requests {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> acceptRequest(
      context, String userDocId, String frndUid, String reqUid) async {
    await _firestore
        .collection('user')
        .doc(Provider.of<UserDetails>(context, listen: false).getUserDocID)
        .collection('requests')
        .doc(reqUid)
        .delete();
    print('first Done');
    final msgDocId = _firestore.collection('messages').doc();
    await msgDocId.set({'dateTime': DateTime.now().toString()});

    await _firestore
        .collection('user')
        .doc(userDocId)
        .collection('friends')
        .doc()
        .set({'userDocId': frndUid, 'messageDocId': msgDocId.id});
    print('second Done');
    await _firestore
        .collection('user')
        .doc(frndUid)
        .collection('friends')
        .doc()
        .set({'userDocId': userDocId, 'messageDocId': msgDocId.id});
    return true;
  }
}
