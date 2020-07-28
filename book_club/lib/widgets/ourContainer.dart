import 'package:flutter/material.dart';
// CONTENITORE CHE USEREMO PER TUTTA L'APP
class OurContainer extends StatelessWidget {
  final Widget child; // arriva dal chiamante!

  const OurContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(
                4.0,
                4.0,
              ),
            ),
          ]),
      child: child,
    );
  }
}
