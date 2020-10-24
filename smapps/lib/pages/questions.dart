import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key key, this.courseId, this.token}) : super(key: key);
  int courseId;
  String token;

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
    if (res.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      questionData = [
        {'id': 0, 'text': "No questions found"}
      ];
    } else {
      setState(() {
        questionData = json.decode(res.body);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // get questions from database
    super.initState();
    _fetchQuestions();
    print("fetched questions");
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: questionData.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(questionData[index]['text']);
        },
      ),
    ));
  }
}
