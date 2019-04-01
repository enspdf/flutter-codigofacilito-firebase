import 'package:app_firebase/classes/auth_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({this.onSignIn, this.authFirebase});

  final VoidCallback onSignIn;
  final AuthFirebase authFirebase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () => signOut(),
            child: Text("Cerrar Sesión"),
          ),
        ],
        title: Text("Home"),
      ),
    );
  }

  void signOut() {
    authFirebase.signOut();
    onSignIn();
  }
}
