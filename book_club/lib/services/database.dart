import 'package:book_club/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// CLASSE CHE LAVORA CON IL DATABASE, PER CREARE UTENTI, GRUPPI ETCETC

class OurDatabase {
  final Firestore _firestore = Firestore.instance;

  // creazione utente, dentro il database... oltre che già fatto in authentications
  Future<String> createUser(OurUser user) async {
    String retVal = 'error';

    try {
      // creaimo la collezzione users con dentro l'utente con chiave il suo id
      await _firestore.collection('users').document(user.uid).setData({
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

  // avere le info di un determinato utente, dando l'uid
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

  // creazione di gruppi!
  Future<String> createGroup(String groupName, String userUid) async {
    String retVal = 'error';
    List<String> members = List();

    try {
      members.add(userUid); // metto me stesso
      // add perchè voglio un ritorno!
      DocumentReference _docRef = await _firestore.collection('groups').add({
        'name': groupName,
        'leader': userUid, // me
        'members': members, // listaVuotaFraCuiMe
        'groupCreated': Timestamp.now(),
      });

      // DocumentReference ridà l'id del documento creato!
      // Inserisco nel database al mio id, il gruppo di cui faccio parte!
      await _firestore.collection('users').document(userUid).updateData({
        'groupId': _docRef.documentID,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  // metodo per entrare in un gruppo
  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = 'error';
    List<String> members = List();

    try {
      members.add(userUid);

      await _firestore.collection("groups").document(groupId).updateData({
        'merbers': FieldValue.arrayUnion(members),
        // AGGIORNA LA LISTA ESISTENTE CON IL NUOVO ME DENTRO UNA LISTA
      });
       // Inserisco nel database al mio id, il gruppo di cui faccio parte!
      await _firestore.collection('users').document(userUid).updateData({
        'groupId':groupId,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
