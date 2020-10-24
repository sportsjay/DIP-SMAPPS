import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';

import '../constants/apiurl.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.token}) : super(key: key);
  String token;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var isLoading = false;
  var parsed_token;

  int user_id;
  String username="-----";
  int points=-1;
  List posts;
  // fetch user info
  _fetchUserInfo() async {
    setState(() {
      isLoading = true;
      parsed_token = Jwt.parseJwt(widget.token);
      user_id = parsed_token['id'];
    });
    final res = await http.get(service_url.get_user_URL + '$user_id',
        headers: {'auth-token': widget.token});
    setState(() {
      final body = json.decode(res.body)[0];
      username = body['username'];
      points = body['points'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    // get questions from database
    super.initState();
    _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [Text(username), Text("Points: $points")],
            ));
  }
}
