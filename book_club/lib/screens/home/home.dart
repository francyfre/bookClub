import 'package:book_club/screens/noGroup/noGroup.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  
  // metodo per cambio pagina
  void _goToNoGroup(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OurNoGroup()));
  }

  // metodo per logout
  void _signOut(BuildContext context) async {
    CurrentUser _currentUser =
        Provider.of<CurrentUser>(context, listen: false); // recuperoUtente
    String _returnString = await _currentUser.signOut(); // chiamo signOut

    if (_returnString == 'success') {
      // torniamo indietro
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ListView per tutti i post o libri
      body: ListView(
        children: <Widget>[
          SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            // nostroContainer
            child: OurContainer(
              child: Column(
                children: <Widget>[
                  Text(
                    "Harry Potter and the Sorcerer's Stone",
                    style: TextStyle(fontSize: 30, color: Colors.grey[600]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Due In: ',
                          style:
                              TextStyle(fontSize: 30, color: Colors.grey[600]),
                        ),
                        Text(
                          '8 Days',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Finished Book',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Next Book Revealed In:",
                      style: TextStyle(fontSize: 30, color: Colors.grey[600]),
                    ),
                    Text(
                      '22 Hours',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: RaisedButton(
              child: Text(
                'BookClub History',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _goToNoGroup(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: RaisedButton(
              child: Text('SignOut'),
              onPressed: () => _signOut(context),
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
