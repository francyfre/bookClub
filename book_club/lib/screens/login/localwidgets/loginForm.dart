import 'package:book_club/screens/home/home.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// BOX BIANCO PER IL LOG IN

// ENUM per due differenti logIn... quindi identificarli
enum LoginType {
  email,
  google,
}

class OurLoginForm extends StatefulWidget {
  @override
  _OurLoginFormState createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // METODO PER LOGIN che manda al metodo giusto, sia per emailAndPassword che GoogleSignIn
  _loginUser({
    @required LoginType type,
    String email,
    String password,
    BuildContext context,
  }) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString;

      // qui si differenziano i casi di logIn (emailAndPassword e GoogleSignIn)
      switch (type) {
        case LoginType.email:
          _returnString =
              await _currentUser.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _currentUser.loginUserWithGoogle();
          break;
        default:
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OurRoot()),
            (route) => false);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // METODO PER LOGIN CON GOOGLE con google_sign_in e GoogleFingerPrint
  Widget _googleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _loginUser(
          // manda al logIn con il google type
          type: LoginType.google,
          context: context,
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/google_logo.png"),
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Sign In with Google',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // nostroContenitore!
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              'Log In',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefix: Icon(Icons.alternate_email),
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefix: Icon(Icons.lock_outline),
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 100.0,
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              _loginUser(
                type: LoginType.email,
                email: _emailController.text,
                password: _passwordController.text,
                context: context,
              );
            },
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurSignUp(),
                ),
              );
            },
            child: Text('Dont have an account? SignUP here!'),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //?
          ),
          _googleButton(),
        ],
      ),
    );
  }
}
