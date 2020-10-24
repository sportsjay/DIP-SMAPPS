import 'package:flutter/material.dart';
import 'courses.dart';
import 'questions.dart';

class ForumScreen extends StatefulWidget {
  ForumScreen({Key key, this.token}) : super(key: key);
  String token;
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  _switchForumScreen({String screenSelect="courses", token="null", courseId=0, questionId=0}) {
    switch (screenSelect) {
      case "courses":
        {
          return CourseScreen(token: token);
        }
        break;
      case "questions":
        {
          return QuestionScreen(token: token, courseId: courseId,);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data from database //
    return _switchForumScreen(screenSelect: "questions");
  }
}
