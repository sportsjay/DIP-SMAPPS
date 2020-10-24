import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard({Key key, this.username, this.courseId, this.question});
  int courseId;
  String username;
  String question;
  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: Icon(Icons.school),
        title: Text(widget.username),
        subtitle: Text(widget.question),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
              onPressed: () {
                print("redirect");
              },
              child: Text("Answers")),
          const SizedBox(width: 8),
        ],
      ),
    ]);
  }
}
