import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

// STATO PER IL LOG-IN

class CurrentUser extends ChangeNotifier {
  // dati utente!
  String _uid;
  String _email;

  //essendo privati abbiamo bisogno di getters:
  String get getUid => _uid;
  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser(String email, String password) async {
    String retVal = "error"; // default, da qui provo a registrare

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error"; // default, da qui provo a registrare

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      retVal = "success"; // SUCCESSO!!

    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> loginWithGoogle() async {
    String retVal = "error"; // default, da qui provo a registrare

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      // 3 step di preparazione:
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

      // da qui viene creato il Google Account dentro Firebase! dell'utente!!
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.idToken);

      AuthResult _authResult =
          await _auth.signInWithCredential(credential); // fine!

      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      retVal = "success"; // SUCCESSO!!

    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }
}
