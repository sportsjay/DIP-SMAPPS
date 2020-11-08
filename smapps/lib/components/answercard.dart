import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smapps/redux/actions/actions.dart';
import 'package:smapps/constants/apiurl.dart';

//Redux
import 'package:smapps/redux/store.dart';

class AnswerCard extends StatefulWidget {
  AnswerCard(
      {Key key,
      this.id = 0,
      this.username = "None",
      this.courseId = 0,
      this.answer = "No Answer",
      this.ratingCount = 0,
      this.img,
      this.ratingUser})
      : super(key: key);
  int id;
  int courseId;
  String username;
  String answer;
  int ratingCount;
  String img;
  List ratingUser;
  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  bool upVote = false;

  @override
  Widget build(BuildContext context) {
    // Set logic for upvote icon
    print(widget.ratingUser);
    if (Redux.store.state.userLoginState.token != "null") {
      if (widget.ratingUser.contains(
          Jwt.parseJwt(Redux.store.state.userLoginState.token)['username'])) {
        setState(() {
          upVote = true;
        });
      } else {
        upVote = false;
      }
    }

    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.answer),
          SizedBox(height: 40.0),
          Row(verticalDirection: VerticalDirection.down, children: <Widget>[
            IconButton(
              onPressed: () async {
                if (Redux.store.state.userLoginState.token != "null") {
                  setState(() {
                    if (upVote) {
                      upVote = false;
                    } else {
                      upVote = true;
                    }
                  });
                  final res = await http.post(
                      service_url.answer_rate_URL + widget.id.toString(),
                      headers: {
                        "Content-Type": "application/json",
                        "auth-token": Redux.store.state.userLoginState.token
                      },
                      body: json.encode({"rate": upVote}));
                  try {
                    if (res.statusCode == 200) {
                      print("Answer Liked");
                    }
                    if (res.statusCode == 400) {
                      throw (res.body);
                    }
                  } catch (err) {
                    print(err);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(content: Text(err));
                        });
                    setState(() {
                      upVote = false;
                    });
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(content: Text("Login to like!"));
                      });
                }
              },
              // Select which icon base on logic settled true/false
              icon: upVote == false
                  ? Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 24.0,
                    )
                  : Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24.0,
                    ),
            ),
            Text(
              widget.ratingCount.toString(),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.share,
            ),
            SizedBox(width: 40),
            Text("ID: " + widget.id.toString()),
            SizedBox(width: 20),
            Text("user:"),
            SizedBox(width: 20),
            Text(
              widget.username,
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            widget.img != null
                ? Image.network(service_url.get_photo_URL + widget.img)
                : Container()
          ])
        ],
      ),
    );
  }
}
