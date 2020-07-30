import 'package:book_club/models/user.dart';
import 'package:book_club/screens/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

// STATO PER IL LOG-IN

class CurrentUser extends ChangeNotifier {
  OurUser _currentUser;

  // dati utente! non più qui ma dentro l'oggetto OurUser
  //String _uid;
  //String _email;

  //essendo privati abbiamo bisogno di getters:
  OurUser get getCurentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  // metodo per sapere se l'utente è connesso
  Future<String> onStartUp() async {
    String retVal = 'error';

    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      if (_firebaseUser != null) {
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        if (_currentUser != null) {
          retVal = 'success';
        }
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  // metodo per signOut
  Future<String> signOut() async {
    String retVal = 'error';

    try {
      await _auth.signOut();
      _currentUser =
          OurUser(); // non NULL ma nuova versione; ci pensa lui a mettere tutto a null
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error"; // default, da qui provo a registrare
    OurUser _user = OurUser();

    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // creiamo l'utente appena loggato
      _user.uid = _authResult.user.uid;
      _user.email = _authResult.user.email;
      _user.fullName = fullName;

      // e lo mandiamo al database
      String _returnString = await OurDatabase().createUser(_user);
      if (_returnString == 'success') {
        retVal = 'success';
      }

      retVal = 'success';
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error"; // default, da qui provo a registrare
    OurUser _user = OurUser();

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // recuperiamo l'utente appena sinIn per conferma
      _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) {
        retVal = 'success';
      }
    } on PlatformException catch (e) {
      retVal = e.message; // ritorno l'errore!

    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  // LOG CON GOOGLE!!
  Future<String> loginUserWithGoogle() async {
    String retVal = "error"; // default, da qui provo a registrare

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    OurUser _user = OurUser();

    try {
      // 3 step di preparazione:
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

      // da qui viene creato il Google Account dentro Firebase! dell'utente!!
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.idToken,
      );

      AuthResult _authResult =
          await _auth.signInWithCredential(credential); // fine!

      // se nuovo utente, creaimo l'oggetto OurUser!!
      if (_authResult.additionalUserInfo.isNewUser) {
        // creiam l'oggetto OurUser
        _user.uid = _authResult.user.uid;
        _user.email = _authResult.user.email;
        _user.fullName = _authResult.user.displayName;
        //_user.accountCreated = Timestamp.now();
        OurDatabase().createUser(_user); // mettiamoNelDatabase
      }

      // recupero le info sull'oggetto creato, per conferma avvenuta
      // e lo mettiamo nella variabile di classe _currentUser
      _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) {
        retVal = 'success';
      }
    } on PlatformException catch (e) {
      retVal = e.message; // ritorno l'errore!
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }
}
