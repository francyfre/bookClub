import 'package:book_club/screens/login/localwidgets/loginForm.dart';
import 'package:book_club/screens/signup/localwidgets/signUpForm.dart';
import 'package:flutter/material.dart';

class OurSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              // dentro ListView per permettere l'uscita della testiera senza errori
              child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  BackButton(),
                ],
              ),
              SizedBox(height: 40.0),
              OurSignUpForm(),
            ],
          ))
        ],
      ),
    );
  }
}
