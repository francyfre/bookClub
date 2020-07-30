import 'package:book_club/screens/home/home.dart';
import 'package:book_club/screens/login/login.dart';
import 'package:book_club/screens/noGroup/noGroup.dart';
import 'package:book_club/screens/splashScreen/splashScreen.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// PAGINA BASE DOVE APPRODIAMO SE LOGGATI

// due stati possibili, loggato o no, AuthStatus nostro creato ora qui
enum AuthStatus { unknown, notLoggedIn, notInGroup, inGroup }

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown; // dafault

  // Called when a dependency of this State object changes.
  // AD OGNI AGGIORNAMENTO DELLO STATO GENERALE, RIPRENDE LO STATO VECCHIO
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // get the state, check currentUser and set AuthState based on state
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp(); // nostro metodo
    if (_returnString == 'success') {
      // controlliamo che non sia in un gruppo, abbia il groupId
      if (_currentUser.getCurentUser.groupId != null) {
        setState(() {
          _authStatus = AuthStatus.inGroup; // siamo nel gruppo
        });
      } else {
        setState(() {
          _authStatus = AuthStatus.notInGroup; // non siamo nel gruppo
        });
      }
    } else {
      // NON SIAMO PROPRIUO LOGGATI, ERRORE
      setState(() {
        _authStatus = AuthStatus.notLoggedIn; // siamo loggati
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    // ottima soluzione
    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;
      case AuthStatus.notInGroup:
        retVal = OurNoGroup();
        break;
      case AuthStatus.inGroup:
        retVal = HomeScreen();
        break;
      default:
    }

    return retVal;
  }
}
