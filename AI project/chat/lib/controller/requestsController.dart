import 'package:chat/models/userDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Requests {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> sendRequest(String uid, String frndUid) async {
    bool check = false;
    String id;
    try {
      print(frndUid);
      final isFrnd = await _firestore
          .collection('user')
          .doc(uid)
          .collection('friends')
          .where('userDocId', isEqualTo: frndUid)
          .get();
      for (var exist in isFrnd.docs) {
        id = exist.id;
      }

      if (id == null) {
        print(' in if ');
        await _firestore
            .collection('user')
            .doc(frndUid)
            .collection('requests')
            .doc()
            .set({'userDocId': uid});
        return 'sent';
      } else {
        check = false;
        return 'already';
      }
    } catch (e) {
      return 'failed';
    }
  }

  Future<bool> acceptRequest(context, String userDocId, String frndUid,
      String reqUid, String myName) async {
    await _firestore
        .collection('user')
        .doc(userDocId)
        .collection('requests')
        .doc(reqUid)
        .delete();
    print('first Done');
    final msgDocId = _firestore.collection('messages').doc();
    await msgDocId.set({'dateTime': DateTime.now().toString()});
    String name;
    final userData = await _firestore.collection('user').doc(frndUid).get();
    name = userData.data()['name'];
    await _firestore
        .collection('user')
        .doc(userDocId)
        .collection('friends')
        .doc()
        .set(
      {'userDocId': frndUid, 'messageDocId': msgDocId.id, 'name': name},
    );
    print('second Done');
    await _firestore
        .collection('user')
        .doc(frndUid)
        .collection('friends')
        .doc()
        .set(
      {'userDocId': userDocId, 'messageDocId': msgDocId.id, 'name': myName},
    );
    return true;
  }
}
