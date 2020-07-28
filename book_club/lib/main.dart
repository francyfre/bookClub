import 'package:book_club/screens/login/login.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: OurTheme().buildTheme(), // () creoInstanza
        home: OurLogin(),
      ),
    );
  }
}
