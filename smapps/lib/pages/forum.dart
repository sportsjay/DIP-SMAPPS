import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:smapps/pages/courses.dart';
import 'package:smapps/pages/questions.dart';
import 'package:smapps/pages/answers.dart';

//Redux
import '../redux/store.dart';

class ForumScreen extends StatefulWidget {
  ForumScreen({Key key}) : super(key: key);
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  _switchForumScreen({String screenSelect = "courses"}) {
    switch (screenSelect) {
      case "courses":
        {
          return CourseScreen();
        }
        break;
      case "questions":
        {
          return QuestionScreen();
        }
      case "answer":
        {
          return AnswerScreen();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data from database //
    // return _switchForumScreen(screenSelect: "courses");
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.selectForumScreenState.screenSelect,
      builder: (context, screenSelect) {
        print("select screen: " + screenSelect);
        return _switchForumScreen(screenSelect: screenSelect);
      },
    );
  }
}
