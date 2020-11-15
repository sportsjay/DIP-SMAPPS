import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
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
  String inputText;
  bool isLoading = false;
  Uint8List bytes;
  PickedFile image;
  String filename;
  final _picker = ImagePicker();

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
            "text": inputText,
          }));
      if (res.statusCode == 200) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text("Post Question Success!"));
            });
        Redux.store
            .dispatch(selectForumScreenStateAction(Redux.store, "courses"));
        Future.delayed(Duration(milliseconds: 500), () {
          Redux.store
              .dispatch(selectForumScreenStateAction(Redux.store, "questions"));
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
      if (bytes.toString().length > 1000) {
        final uri = Uri.parse(service_url.answer_post_w_img_URL);
        final req = http.MultipartRequest('POST', uri);
        req.headers.addAll({
          "Content-Type": "multipart/form-data",
          "auth-token": Redux.store.state.userLoginState.token
        });
        req.files.add(http.MultipartFile.fromBytes('img', bytes.toList(),
            filename: filename.split("/").last,
            contentType: new MediaType('image', 'jpeg')));
        req.fields.addAll({
          "text": inputText,
          "discussionId": Redux.store.state.courseId.id.toString(),
          "questionId": Redux.store.state.questionId.id.toString()
        });
        final res = await req.send();
        if (res.statusCode == 200) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text("Post Answer Success: 1"));
              });
          Redux.store
              .dispatch(selectForumScreenStateAction(Redux.store, "questions"));
          Future.delayed(Duration(milliseconds: 500), () {
            Redux.store
                .dispatch(selectForumScreenStateAction(Redux.store, "answers"));
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text(res.reasonPhrase));
              });
        }
      } else {
        final res = await http.post(service_url.answer_post_URL,
            headers: {
              "Content-Type": "application/json",
              "auth-token": Redux.store.state.userLoginState.token
            },
            body: json.encode({
              "discussionId": Redux.store.state.courseId.id.toString(),
              "questionId": Redux.store.state.questionId.id.toString(),
              "text": inputText,
            }));
        if (res.statusCode == 200) {
          print(json.decode(res.body));
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text("Post Answer Success: 2"));
              });
          Redux.store
              .dispatch(selectForumScreenStateAction(Redux.store, "questions"));
          Future.delayed(Duration(milliseconds: 500), () {
            Redux.store.dispatch(
                selectForumScreenStateAction(Redux.store, "answers"));
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
  }

  // Returns specific input form for question or answer
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            Redux.store.state.selectForumScreenState.screenSelect == "answer"
                ? Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        image =
                            await _picker.getImage(source: ImageSource.gallery);
                        bytes = await image.readAsBytes();
                        setState(() {
                          filename = image.path;
                          print(filename);
                          isLoading = false;
                        });
                      },
                      icon: Icon(Icons.attach_file),
                    ),
                  )
                : Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 6,
              child: Container(
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      inputText = text;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Write your message here',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(Icons.subdirectory_arrow_left_rounded),
                onPressed: () {
                  if (Redux.store.state.userLoginState.token == "null") {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(content: Text("Please Login!"));
                        });
                  } else {
                    _postQuery(widget.api);
                    print("post completed");
                  }
                },
              ),
            )
          ],
        ),
        bytes.toString().length > 4
            ? Text(
                "File size: " + bytes.toString().length.toString() + " bytes")
            : Container()
      ],
    );
  }
}
