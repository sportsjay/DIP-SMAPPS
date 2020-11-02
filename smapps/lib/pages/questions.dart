import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//Component
import 'package:smapps/components/questioncard.dart';

//Redux
import 'package:smapps/redux/store.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key key}) : super(key: key);
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var questionData = [];
  int courseId = 0;

  _fetchQuestions(int courseId) async {
    setState(() {
      print("fetching questions");
    });
    final res = await http.get(
        service_url.get_question_URL + "discussion/" + courseId.toString());
    if (res.statusCode == 200) {
      setState(() {
        questionData = json.decode(res.body);
        if (questionData.length == 0) {
          questionData = [
            {'id': 0, 'text': "No questions found"}
          ];
        }
      });
      print("fetch questions successful");
    } else {
      print("fail to fetch questions");
      setState(() {
        questionData = [{'id': 0, 'text': "No questions found"}];
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchQuestions(Redux.store.state.courseId.id);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.selectForumScreenState.screenSelect,
      builder: (context, screenSelect) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Questions"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left,
                    color: Colors.white, size: 35),
                onPressed: () {
                  print("back");
                  Redux.store.dispatch(
                      selectForumScreenStateAction(Redux.store, "courses"));
                },
              ),
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white, size: 35),
                onPressed: () {
                  print("logout");
                },
              )
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(3),
            itemCount: questionData.length,
            itemBuilder: (BuildContext context, int index) {
              return QuestionCard(
                  id: questionData[index]['id'],
                  question: questionData[index]['text']);
            },
          ),
        );
      },
    );
  }
}
