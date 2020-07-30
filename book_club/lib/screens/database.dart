import 'package:book_club/models/user.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OurDatabase {
  final Firestore _firestore = Firestore.instance;

  // creazione utente
  Future<String> createUser(OurUser user) async {
    String retVal = 'error';

    try {
      // creaimo la collezzione users con dentro l'utente con chiave il suo id
      await _firestore.collection('users').document(user.uid).setData({
        // data da inserire
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser(); // utente da restituire popolato giusto

    try {
      // ritorna un documento, GIUSTO! solo uno
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('users').document(uid).get();

      retVal.uid = uid;
      retVal.fullName = _docSnapshot.data['fullName'];
      retVal.email = _docSnapshot.data['email'];
      retVal.accountCreated = _docSnapshot.data['accountCreated'];
      retVal.groupId = _docSnapshot.data['groupId'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(String groupName, String userUid) async {
    String retVal = 'error';
    List<String> members = List();

    try {
      members.add(userUid); // metto me stesso
      // add perchè voglio un ritorno!
      DocumentReference _docRef = await _firestore.collection('groups').add({
        'name': groupName,
        'leader': userUid,
        'members': members,
        'groupCreated': Timestamp.now(),
      });

      // aggiorniamo il dato dell'utente in che gruppo è!!!
      await _firestore.collection('users').document(userUid).updateData({
        'groupId': _docRef.documentID,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = 'error';

    try {
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
