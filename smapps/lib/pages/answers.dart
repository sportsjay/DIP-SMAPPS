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
        {'id': 0, 'text': "No questions found"}
      ];
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
        isLoading = false;
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
    _fetchAnswers(Redux.store.state.questionId.id);
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
              logoutButton(),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(3),
            itemCount: answerData.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == answerData.length) {
                return InputForm();
              } else {
                return AnswerCard(
                    id: answerData[index]['id'],
                    answer: answerData[index]['text'],
                    img: answerData[index]['img']);
              }
            },
          ),
        ));
      },
    );
  }
}
