import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smapps/constants/apiurl.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key key, this.courseId}) : super(key: key);

  int courseId;
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var questionData = List();
  var isLoading = false;
  _fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    final res = await http.get(service_url.get_question_URL);
  }

  @override
  void initState() {
    // get questions from database
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold());
  }
}
