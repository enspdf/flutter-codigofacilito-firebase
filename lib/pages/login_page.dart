import 'package:app_firebase/classes/auth_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final AuthFirebase auth;
  final VoidCallback onSignIn;

  LoginPageState createState() => new LoginPageState();
}

enum FormType { login, register }

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  FormType formType = FormType.login;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: formLogin(),
          ),
        ),
      ),
    );
  }

  List<Widget> formLogin() {
    return [
      padded(
          child: TextFormField(
        controller: emailController,
        decoration:
            InputDecoration(icon: Icon(Icons.person), labelText: "Correo"),
        autocorrect: false,
      )),
      padded(
          child: TextFormField(
        controller: passwordController,
        decoration:
            InputDecoration(icon: Icon(Icons.lock), labelText: "Contraseña"),
        autocorrect: false,
        obscureText: true,
      )),
      Column(
        children: buttonWidget(),
      )
    ];
  }

  List<Widget> buttonWidget() {
    switch (formType) {
      case FormType.login:
        return [
          styleButton("Iniciar Sesión", validateSubmit),
          FlatButton(
            child: Text("No tienes una cuenta? Registrate"),
            onPressed: () => updateFormType(FormType.register),
          )
        ];
      case FormType.register:
        return [
          styleButton("Crear Cuenta", validateSubmit),
          FlatButton(
            child: Text("Iniciar Sesión"),
            onPressed: () => updateFormType(FormType.login),
          )
        ];
    }
  }

  void updateFormType(FormType form) {
    formKey.currentState.reset();
    setState(() {
      formType = form;
    });
  }

  void validateSubmit() {
    (formType == FormType.login)
        ? widget.auth.signIn(emailController.text, passwordController.text)
        : widget.auth.createUser(emailController.text, passwordController.text);
    widget.onSignIn();
  }

  Widget styleButton(String text, VoidCallback onPressed) {
    return RaisedButton(
      onPressed: onPressed,
      color: Colors.blue,
      textColor: Colors.white,
      child: Text(text),
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
