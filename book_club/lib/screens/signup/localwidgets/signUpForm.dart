import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// BOX BIANCO PER IL SIGN-UP
class OurSignUpForm extends StatefulWidget {
  // StatefulWidget per TextEditingController!!!!!

  @override
  _OurSignUpFormState createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // metodo che lancia il log
  _signUpUser(String email, String password, BuildContext context,
      String fullName) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      // chiamo signUpUser della funzione che passa il Provider!!!
      String _returnString =
          await _currentUser.signUpUser(email.trim(), password.trim(), fullName);
      // registro utente!!!
      if (_returnString == "success") {
        Navigator.pop(context); // torniamoIndietro
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

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
              prefix: Icon(Icons.person_outline),
              hintText: 'Full Name',
            ),
          ),
          SizedBox(height: 20.0),
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
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              prefix: Icon(Icons.lock_open),
              hintText: 'Confirm Password',
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              // controlliamo i controller dei testi di password
              if (_passwordController.text.trim() ==
                  _confirmPasswordController.text.trim()) {
                // nostra funzione che fa loggare!
                _signUpUser(
                  _emailController.text,
                  _passwordController.text,
                  context,
                  _fullNameController.text,
                );
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password do not match'),
                    duration: Duration(seconds: 4),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
