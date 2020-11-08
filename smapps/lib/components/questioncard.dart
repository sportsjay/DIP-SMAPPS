import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_redux/flutter_redux.dart';
import 'package:smapps/redux/actions/actions.dart';
import 'package:smapps/constants/apiurl.dart';

//Redux
import 'package:smapps/redux/store.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard(
      {Key key,
      this.id = 0,
      this.username = "None",
      this.courseId = 0,
      this.question = "No Question",
      this.ratingCount = 0,
      this.answerCount = 0,
      this.ratingUser})
      : super(key: key);

  int id;
  int courseId;
  String username;
  String question;
  int ratingCount;
  int answerCount;
  List ratingUser;
  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool upVote = false;
  
  @override
  Widget build(BuildContext context) {
    // Set logic for upvote icon
    if (Redux.store.state.userLoginState.token != "null") {
      if (widget.ratingUser.contains(
          Jwt.parseJwt(Redux.store.state.userLoginState.token)['id'])) {
        upVote = true;
      } else {
        upVote = false;
      }
    }

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.selectForumScreenState,
      builder: (context, screenState) {
        return Card(
            margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(widget.question,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        )),
                    SizedBox(height: 40.0),
                    Row(children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          if (Redux.store.state.userLoginState.token !=
                              "null") {
                            setState(() {
                              if (upVote) {
                                upVote = false;
                              } else {
                                upVote = true;
                              }
                            });
                            final res = await http.post(
                                service_url.question_rate_URL +
                                    widget.id.toString(),
                                headers: {
                                  "Content-Type": "application/json",
                                  "auth-token":
                                      Redux.store.state.userLoginState.token
                                },
                                body: json.encode({"rate": upVote}));
                            try {
                              if (res.statusCode == 200) {
                                print("Question Liked");
                              } else {
                                throw ("Fail to like");
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
                                  return AlertDialog(
                                      content: Text("Login to like!"));
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
                      Icon(Icons.comment, color: Colors.black, size: 24.0),
                      SizedBox(width: 10),
                      Text(widget.answerCount.toString()),
                      SizedBox(width: 10),
                      Icon(
                        Icons.share,
                      ),
                      SizedBox(width: 40),
                      Text("ID: " + widget.id.toString()),
                      SizedBox(width: 20),
                      Text(
                        "By: " + widget.username,
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      )
                    ]),
                    RaisedButton(
                      child: Text("Answers"),
                      onPressed: () {
                        Redux.store
                            .dispatch(selectQuestionId(Redux.store, widget.id));
                        Redux.store.dispatch(selectForumScreenStateAction(
                            Redux.store, "answer"));
                      },
                    )
                  ]),
            ));
      },
    );
  }
}
