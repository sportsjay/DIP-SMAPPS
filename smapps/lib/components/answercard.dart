import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
      this.upVote = false,
      this.ratingCount = 0,
      this.img = "null"})
      : super(key: key);
  int id;
  int courseId;
  String username;
  String answer;
  bool upVote;
  int ratingCount;
  String img;
  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  @override
  Widget build(BuildContext context) {
    // Set logic for upvote icon
    final Widget iconTrue = Icon(
      Icons.favorite_border,
      color: Colors.red,
      size: 24.0,
    );
    final Widget iconFalse = Icon(
      Icons.favorite,
      color: Colors.red,
      size: 24.0,
    );
    _iconSelect({upVote: false}) {
      bool checkUpVote = widget.upVote;
      if (checkUpVote) {
        // final res = await http.post(
        //     service_url.get_question_URL + widget.id.toString() + '/rate',
        //     headers: {"Content-Type": "application/json"},
        //     body: {"rate":-1});
        return iconFalse;
      } else {
        // final res = await http.post(
        //     service_url.get_question_URL + widget.id.toString() + '/rate',
        //     headers: {"Content-Type": "application/json"},
        //     body: {"rate":1});
        return iconTrue;
      }
    }

    _chooseCard(String img) {
      if (img == null) {
        return // Card without img
            Card(
          margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(widget.answer),
              SizedBox(height: 40.0),
              Row(children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.upVote) {
                        widget.upVote = false;
                        // trigger upvote API
                      } else {
                        widget.upVote = true;
                        // trigger downvote API
                      }
                    });
                  },
                  // Select which icon base on logic settled true/false
                  icon: _iconSelect(upVote: widget.upVote),
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
                )
              ])
            ],
          ),
        );
      } else {
        return // Card with image
            Card(
          margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Answer"),
              SizedBox(height: 40.0),
              Row(children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.upVote) {
                        widget.upVote = false;
                        // trigger upvote API
                      } else {
                        widget.upVote = true;
                        // trigger downvote API
                      }
                    });
                  },
                  // Select which icon base on logic settled true/false
                  icon: _iconSelect(upVote: widget.upVote),
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
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                )
              ]),
              Image.network(service_url.get_photo_URL + widget.img)
            ],
          ),
        );
      }
    }

    return _chooseCard(widget.img);
  }
}
