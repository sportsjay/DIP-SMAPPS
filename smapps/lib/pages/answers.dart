import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//Component
import 'package:smapps/components/answercard.dart';

//Redux
import 'package:smapps/redux/store.dart';

class AnswerScreen extends StatefulWidget {
  AnswerScreen({Key key}) : super(key: key);

  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  var answerData = [];
  int questionId = 0;

  _fetchAnswers(int questionId) async {
    setState(() {
      print("fetching questions");
    });
    final res = await http
        .get(service_url.get_answer_URL + "question/" + questionId.toString());
    if (res.statusCode == 200) {
      setState(() {
        answerData = json.decode(res.body);
        if (answerData.length == 0) {
          answerData = [
            {'id': 0, 'text': "No questions found"}
          ];
        }
      });
      print("fetch questions successful");
    } else {
      print("fail to fetch questions");
      setState(() {
        answerData = [
          {'id': 0, 'text': "No questions found"}
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAnswers(Redux.store.state.questionId.id);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.questionId.id,
      builder: (context, id) {
        return (Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Answer"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left,
                    color: Colors.white, size: 35),
                onPressed: () {
                  print("back");
                  Redux.store.dispatch(
                      selectForumScreenStateAction(Redux.store, "questions"));
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
            itemCount: answerData.length,
            itemBuilder: (BuildContext context, int index) {
              return AnswerCard(
                  id: answerData[index]['id'],
                  answer: answerData[index]['text'],
                  img: answerData[index]['img']);
            },
          ),
        ));
      },
    );
  }
}
