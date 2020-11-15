import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/pages/login.dart';

//Redux
import 'package:smapps/redux/store.dart';
import 'package:smapps/redux/actions/actions.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var isLoading = false;
  var parsed_token;

  String isLoggedToken;
  int user_id;
  String username = "-----";
  int points = -1;
  List posts;

  _logoutSubmit() async {
    setState(() {
      isLoading = true;
    });
    final res = await http.post(service_url.logout_URL);
    if (res.statusCode == 200) {
      setState(() {
        isLoggedToken = "null";
        Redux.store.dispatch(loginUser(Redux.store, isLoggedToken));
        isLoading = false;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text("Logout Failed"));
          });
      setState(() {
        isLoggedToken = "null";
        isLoading = false;
      });
    }
  }

  // fetch user info
  _fetchUserInfo() async {
    if (Redux.store.state.userLoginState.token == "null") {
      setState(() {
        isLoading = true;
        username = "unknown";
        points = -1;
        isLoading = false;
      });
    } else {
      try {
        setState(() {
          isLoading = true;
          parsed_token = Jwt.parseJwt(Redux.store.state.userLoginState.token);
          user_id = parsed_token['id'];
        });
        final res = await http.get(service_url.get_user_URL + '$user_id',
            headers: {'auth-token': Redux.store.state.userLoginState.token});
        setState(() {
          final body = json.decode(res.body)[0];
          username = body['username'];
          points = body['points'];
          isLoading = false;
        });
      } catch (error) {
        print("Error fetching: " + error);
      }
    }
  }

  @override
  void initState() {
    // get questions from database
    super.initState();
    _fetchUserInfo();
  }

  Widget logoutButton() {
    if (Redux.store.state.userLoginState.token != "null") {
      return IconButton(
        icon: Icon(Icons.logout, color: Colors.white, size: 25),
        onPressed: () {
          print("logout");
          _logoutSubmit();
        },
      );
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    TextStyle styleText = TextStyle(
        color: Colors.black,
        letterSpacing: 2.0,
        fontSize: 28.0,
        fontWeight: FontWeight.bold);

    Widget loadingPage() {
      return Container(
        child: Center(child: Text("Loading!")),
      );
    }

    Widget profilePage() {
      return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Profile"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.refresh, color: Colors.white, size: 35),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                print("refresh");
                Redux.store.dispatch(refreshApplication(Redux.store, false));
                setState(() {
                  isLoading = false;
                });
              },
            ),
            actions: <Widget>[
              logoutButton(),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          // backgroundImage: AssetImage('assets/chelsea2012.jpg'),
                          radius: 60.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('Points: ' + points.toString(), style: styleText),
                      SizedBox(height: 20.0),
                      Text('Username',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                          )),
                      SizedBox(height: 10.0),
                      Text(username, style: styleText),
                      SizedBox(height: 30.0),
                      Text('Academic Year',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                          )),
                      SizedBox(height: 10.0),
                      Text('Year 3', style: styleText),
                      SizedBox(height: 30.0),
                      Row(children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10.0),
                        Text('$username@e.ntu.edu.sg',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                            ))
                      ])
                    ])),
          ));
    }

    return StoreConnector<AppState, String>(
        converter: (store) => store.state.userLoginState.token,
        builder: (context, token) {
          if (isLoading) {
            return loadingPage();
          }
          if (token == "null") {
            return LoginScreen();
          } else {
            return profilePage();
          }
        });
  }
}
