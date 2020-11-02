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
      });
      setState(() {
        username = "";
        password = "";
        isLoading = false;
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
            body: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('USERNAME'),
                      SizedBox(height: 8.0),
                      TextField(
                          style: TextStyle(
                            height: 2,
                          ),
                          onChanged: (inputUserName) {
                            setState(() {
                              username = inputUserName;
                            });
                          }),
                      SizedBox(height: 8.0),
                      Text('PASSWORD'),
                      TextField(
                          style: TextStyle(
                            height: 2,
                          ),
                          onChanged: (inputPassword) {
                            setState(() {
                              password = inputPassword;
                            });
                          }),
                      SizedBox(height: 8.0),
                      Center(
                          child: RaisedButton(
                              onPressed: () {
                                _loginSubmit();
                              },
                              child: Text("Login/Register"),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))))
                    ])));
      },
    );
  }
}
