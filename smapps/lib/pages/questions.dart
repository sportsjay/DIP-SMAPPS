import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//Component
import 'package:smapps/components/questioncard.dart';
import 'package:smapps/components/textinput.dart';

//Redux
import 'package:smapps/redux/store.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key key}) : super(key: key);
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var questionData = [];
  int courseId = 0;
  bool isLoading = false;
  String isLoggedToken;

  _logoutSubmit() async {
    setState(() {
      print("fetching questions");
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

  _fetchQuestions(int courseId) async {
    setState(() {
      print("fetching questions");
      questionData = [
        {
          'id': 0,
          'text': "No questions found",
          'username': "None",
          'rating': 0,
          'countAnswer': 0
        }
      ];
      isLoading = true;
    });
    final res = await http.get(
        service_url.get_question_URL + "discussion/" + courseId.toString());
    if (res.statusCode == 200) {
      setState(() {
        questionData = json.decode(res.body);
        if (questionData.length == 0) {
          questionData = [
            {
              'id': 0,
              'text': "No questions found",
              'username': "None",
              'rating': 0,
              'countAnswer': 0
            }
          ];
        }
      });
      print("fetch questions successful");
    } else {
      print("fail to fetch questions");
      setState(() {
        isLoading = false;
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
    Widget logoutButton() {
      if (Redux.store.state.userLoginState.token != "null") {
        return IconButton(
          icon: Icon(Icons.logout, color: Colors.white, size: 25),
          onPressed: () {
            print("logout");
            _logoutSubmit();
          },
        );
      } else {
        return Container();
      }
    }

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.selectForumScreenState.screenSelect,
      builder: (context, screenSelect) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Questions"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.keyboard_arrow_left,
                    color: Colors.white, size: 35),
                onPressed: () {
                  print("back");
                  Redux.store.dispatch(
                      selectForumScreenStateAction(Redux.store, "courses"));
                },
              ),
              actions: <Widget>[
                logoutButton(),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(3),
              itemCount: questionData.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == questionData.length) {
                  return InputForm(
                      api: service_url.question_post_URL,
                      discussionId: Redux.store.state.courseId.id);
                } else {
                  return QuestionCard(
                    id: questionData[index]['id'],
                    question: questionData[index]['text'],
                    username: questionData[index]['username'],
                    answerCount: questionData[index]['countAnswers'],
                    ratingCount: questionData[index]['rating'],
                  );
                }
              },
            ));
      },
    );
  }
}
