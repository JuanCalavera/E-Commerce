import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            textColor: Colors.white,
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Form(
            key: _formKey,
            child: ListView(padding: EdgeInsets.all(16.0), children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "Email Inválido";
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(
                  hintText: "Senha",
                ),
                obscureText:
                    true, // Para não aparecer a senha digitada pelo usuário na tela
                validator: (text) {
                  if (text.isEmpty || text.length < 6) return "Senha Inválida";
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty)
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Insira um e-mail para recuperação"),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                      ));
                      else{
                        model.recoverPass(_emailController.text);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Confira seu e-mail"),
                        backgroundColor: Theme.of(context).primaryColor,
                        duration: Duration(seconds: 2),
                      ));
                      }
                  },
                  child: Text(
                    "Esqueceu a Senha!?",
                    textAlign: TextAlign.right,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_formKey.currentState.validate()) {}
                  model.signIn(
                      email: _emailController.text,
                      pass: _passController.text,
                      onSuccess: _onSuccess,
                      onFail: _onFail);
                },
              ),
            ]),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Email ou senha incorretos"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
