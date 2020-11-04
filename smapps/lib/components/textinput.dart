import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//Redux
import 'package:smapps/redux/store.dart';

class InputForm extends StatefulWidget {
  InputForm({Key key, this.api, this.discussionId, this.questionId})
      : super(key: key);

  final String api;
  final int discussionId;
  final int questionId;
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  String inputQuestion;
  String inputAnswer;
  bool isLoading = false;
  // Uint8List bytes;
  var bytes;

  // Post Image
  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }

  // Post Text-based queries
  _postQuery(api) async {
    // Function for question posting
    if (api == service_url.question_post_URL) {
      final res = await http.post(service_url.question_post_URL,
          headers: {
            "Content-Type": "application/json",
            "auth-token": Redux.store.state.userLoginState.token
          },
          body: json.encode({
            "discussionId": Redux.store.state.courseId.id,
            "text": inputQuestion,
          }));
      if (res.statusCode == 200) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text("Post Question Success!"));
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(json.decode(res.body)));
            });
      }
      // Function for answer posting
    } else if (api == service_url.answer_post_URL) {
      final res = await http.post(service_url.answer_post_URL,
          headers: {
            "Content-Type": "application/json",
            "auth-token": Redux.store.state.userLoginState.token
          },
          body: json.encode({
            "discussionId": Redux.store.state.courseId.id,
            "questionId": Redux.store.state.questionId.id,
            "text": inputAnswer
          }));
      if (res.statusCode == 200) {
        print(json.decode(res.body));
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text("Post Answer Success!"));
            });
      } else {
        print(json.decode(res.body));
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(json.decode(res.body)));
            });
      }
    }
  }

  // Returns specific input form for question or answer
  inputChoose() {
    // Question Form
    if (Redux.store.state.selectForumScreenState.screenSelect == "questions") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          TextField(
            maxLines: 4,
            onChanged: (value) {
              setState(() {
                inputQuestion = value;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
          ),
          SizedBox(height: 10),
          RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              print(inputQuestion);
              if (Redux.store.state.userLoginState.token == "null") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(content: Text("Please Login!"));
                    });
              } else {
                _postQuery(widget.api);
                print("post question");
              }
            },
          )
        ],
      );
    } else if (Redux.store.state.selectForumScreenState.screenSelect ==
        "answer") {
      // Answer Form
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          TextField(
            maxLines: 4,
            onChanged: (value) {
              setState(() {
                inputAnswer = value;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  if (Redux.store.state.userLoginState.token == "null") {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(content: Text("Please Login!"));
                        });
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    _postQuery(widget.api);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () async {
                  final _picker = ImagePicker();
                  PickedFile image =
                      await _picker.getImage(source: ImageSource.gallery);
                  bytes = await image.readAsBytes();
                },
              ),
              SizedBox(width: 20)
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: inputChoose());
  }
}
