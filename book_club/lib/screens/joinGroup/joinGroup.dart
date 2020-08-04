import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurJoinGroup extends StatefulWidget {
  @override
  _OurJoinGroupState createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {

  void _joinGroup(BuildContext context, String groupId) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    String _returnString = await OurDatabase()
        .joinGroup(groupId, _currentUser.getCurentUser.uid);

    if (_returnString == "success") {
      // se tutto a posto torniamo all'inizio!
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OurRoot()),
        (route) => false,
      );
    }
  }

  TextEditingController _groupIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupIdController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Id",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _joinGroup(context, _groupIdController.text),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}