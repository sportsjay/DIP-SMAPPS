import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//Component
import 'package:smapps/components/answercard.dart';
import 'package:smapps/components/textinput.dart';

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
  String questionTitle = "No Question";
  bool isLoading = false;
  String isLoggedToken;

  _logoutSubmit() async {
    setState(() {
      isLoading = true;
    });
    final res = await http.post(service_url.logout_URL);
    if (res.statusCode == 200) {
      setState(() {
        isLoggedToken = "null";
        Redux.store.dispatch(loginUser(Redux.store, isLoggedToken));
        isLoading = false;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text("Logout Failed"));
          });
      setState(() {
        isLoggedToken = "null";
        isLoading = false;
      });
    }
  }

  _fetchAnswers(int questionId) async {
    setState(() {
      print("fetching answers");
      isLoading = true;
      answerData = [
        {
          'id': 0,
          'text': "No answers found",
          'username': "None",
          'rating': 0,
          'userRate': [0]
        }
      ];
    });
    final question_title_res =
        await http.get(service_url.get_question_URL + questionId.toString());
    try {
      if (question_title_res.statusCode == 200) {
        setState(() {
          questionTitle = json.decode(question_title_res.body)[0]['text'];
        });
      } else {
        throw ("Error fetching question title");
      }
    } catch (err) {
      print(err);
    } finally {
      final res = await http.get(
          service_url.get_answer_URL + "question/" + questionId.toString());
      try {
        if (res.statusCode == 200) {
          setState(() {
            answerData = json.decode(res.body);
            if (answerData.length == 0) {
              answerData = [
                {
                  'id': 0,
                  'text': "No questions found",
                  'username': "None",
                  'rating': 0,
                  'userRate': [0]
                }
              ];
            }
            isLoading = false;
          });
          print("fetch answers successful");
        } else {
          setState(() {
            isLoading = false;
          });
          throw ("fail to fetch answers");
        }
      } catch (err) {
        print(err);
      }
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
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left,
                  color: Colors.white, size: 35),
              onPressed: () {
                print("back");
                Redux.store.dispatch(
                    selectForumScreenStateAction(Redux.store, "questions"));
              },
            ),
            actions: <Widget>[
              Redux.store.state.userLoginState.token != "null"
                  ? IconButton(
                      icon: Icon(Icons.arrow_downward,
                          color: Colors.white, size: 25),
                      onPressed: () {
                        print("logout");
                        _logoutSubmit();
                      },
                    )
                  : Container(),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(3),
            itemCount: answerData.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                    alignment: Alignment.topCenter,
                    child: Text(questionTitle),
                    height: 50,
                    color: Colors.black54);
              }
              if (index == answerData.length + 1) {
                return InputForm(api: service_url.answer_post_URL);
              } else {
                return AnswerCard(
                    id: answerData[index - 1]['id'],
                    answer: answerData[index - 1]['text'],
                    img: answerData[index - 1]['img'],
                    ratingCount: answerData[index - 1]['rating'],
                    username: answerData[index - 1]['username'],
                    ratingUser: answerData[index - 1]['userRate']);
              }
            },
          ),
        ));
      },
    );
  }
}
