import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/apiurl.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.isLoggedToken});
  String isLoggedToken;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String isLoggedToken;
  String username;
  String password;

  bool isLoading = false;

  _loginSubmit() async {
    setState(() {
      isLoading = true;
    });
    // fetch login api //
    final res = await http.post(service_url.login_URL,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': username, 'password': password}));
    if (res.statusCode == 200) {
      setState(() {
        isLoggedToken = json.decode(res.body)['token'];
      });
      Navigator.pushNamed(context, '/home',
          arguments: {'isLoggedToken': isLoggedToken});
      setState(() {
        username = "";
        password = "";
        isLoading = false;
      });
    } else {
      setState(() {
        isLoggedToken = "null";
        isLoading = false;
      });
      String err = res.body;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(err));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text('Login'),
        ),
        // backgroundColor: Colors.blue[300],
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('USERNAME'),
              SizedBox(height: 8.0),
              TextField(
                  style: TextStyle(
                    height: 1,
                  ),
                  onChanged: (inputUserName) {
                    setState(() {
                      username = inputUserName;
                    });
                  }),
              SizedBox(height: 4.0),
              Text('PASSWORD'),
              TextField(
                  style: TextStyle(
                    height: 1,
                  ),
                  onChanged: (inputPassword) {
                    setState(() {
                      password = inputPassword;
                    });
                  }),
              Center(
                  child: RaisedButton(
                      onPressed: () {
                        _loginSubmit();
                      },
                      child: Text("Login"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))))
            ])));
  }
}
