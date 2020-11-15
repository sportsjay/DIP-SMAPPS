import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//Redux
import 'package:smapps/redux/store.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.isLoggedToken});
  final String isLoggedToken;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String isLoggedToken;
  String username;
  String password;
  bool _obscureText = true;
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
        Redux.store.dispatch(loginUser(Redux.store, isLoggedToken));
        Redux.store.dispatch(refreshApplication(Redux.store, true));
        username = "";
        password = "";
        isLoading = false;
      });
      setState(() {
        Redux.store.dispatch(refreshApplication(Redux.store, false));
        Redux.store
            .dispatch(selectForumScreenStateAction(Redux.store, "courses"));
      });
    } else {
      final res = await http.post(service_url.register_URL,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'username': username, 'password': password}));
      if (res.statusCode == 200) {
        setState(() {
          isLoggedToken = json.decode(res.body)['token'];
        });
        setState(() {
          username = "";
          password = "";
          isLoading = false;
        });
      } else {
        String err = res.body;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(err));
            });
        setState(() {
          isLoggedToken = "null";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userLoginState.token,
      builder: (context, token) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Login'),
              centerTitle: true,
            ),
            // backgroundColor: Colors.blue[300],
            body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 100),
                          child: Text("Welcome Back",
                              textScaleFactor: 2,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 30, bottom: 10),
                                  child: Text(
                                    'Username',
                                  ),
                                ),
                                TextField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200]),
                                    style: TextStyle(
                                      height: 2,
                                    ),
                                    onChanged: (inputUserName) {
                                      setState(() {
                                        username = inputUserName;
                                      });
                                    }),
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 30, top: 10, bottom: 10),
                                    child: Text('Password')),
                                TextField(
                                    obscureText: _obscureText,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(30)),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      suffixIcon: IconButton(
                                          icon: _obscureText
                                              ? Icon(Icons.visibility_off)
                                              : Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          }),
                                    ),
                                    style: TextStyle(
                                      height: 2,
                                    ),
                                    onChanged: (inputPassword) {
                                      setState(() {
                                        password = inputPassword;
                                      });
                                    }),
                                SizedBox(height: 20),
                                Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 40,
                                    child: RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.black87,
                                        onPressed: () {
                                          _loginSubmit();
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: Text("Login/Register"),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                  ),
                                ),
                              ]),
                        ),
                      ])),
            );
      },
    );
  }
}
