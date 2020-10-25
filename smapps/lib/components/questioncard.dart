import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:smapps/constants/apiurl.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard(
      {Key key,
      this.id = 0,
      this.username = "None",
      this.courseId = 0,
      this.question = "No Question",
      this.upVote = false,
      this.ratingCount = 0,
      this.answerCount = 0})
      : super(key: key);

  int id;
  int courseId;
  String username;
  String question;
  bool upVote;
  int ratingCount;
  int answerCount;
  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
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
                  Icon(Icons.comment, color: Colors.black, size: 24.0),
                  Text(widget.answerCount.toString()),
                  SizedBox(width: 10),
                  Icon(
                    Icons.share,
                  ),
                  SizedBox(width: 100),
                  Text("ID: " + widget.id.toString()),
                  SizedBox(width: 20),
                  Text(
                    widget.username,
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  )
                ])
              ]),
        ));
  }
}
