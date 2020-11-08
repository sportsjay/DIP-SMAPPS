import 'dart:typed_data';

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
        req.files.add(http.MultipartFile.fromBytes('img', bytes.toList()));
        req.fields.addAll({
          "discussionId": Redux.store.state.courseId.id.toString(),
          "questionId": Redux.store.state.questionId.id.toString(),
          "text": inputText,
          "img": filename
        });

        final res = await req.send();
        if (res.statusCode == 200) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text("Post Answer Success!"));
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
  }

  // Returns specific input form for question or answer
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: null,
              icon: Icon(Icons.attach_file),
            ),
            Flexible(
              child: Container(
                width: 250,
                height: 40,
                child: TextField(
                  textAlignVertical: TextAlignVertical.
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Write your message here',
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: null,
            )
          ],
        ),
      ],
    );
    // return Container(
    //     child: Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //     SizedBox(height: 10),
    //     TextField(
    //       maxLines: 4,
    //       onChanged: (value) {
    //         setState(() {
    //           inputText = value;
    //         });
    //       },
    //       decoration: InputDecoration(
    //           border: OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
    //     ),
    //     SizedBox(height: 10),
    //     Redux.store.state.selectForumScreenState.screenSelect == "questions"
    //         ? Container(
    //             child: RaisedButton(
    //               child: Text("Submit"),
    //               onPressed: () {
    //                 print(inputText);
    //                 if (Redux.store.state.userLoginState.token == "null") {
    //                   showDialog(
    //                       context: context,
    //                       builder: (context) {
    //                         return AlertDialog(content: Text("Please Login!"));
    //                       });
    //                 } else {
    //                   _postQuery(widget.api);
    //                   print("post question");
    //                 }
    //               },
    //             ),
    //           )
    //         : Container(
    //             child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: <Widget>[
    //                 RaisedButton(
    //                   child: Text("Submit"),
    //                   onPressed: () {
    //                     print(inputText);
    //                     if (Redux.store.state.userLoginState.token == "null") {
    //                       showDialog(
    //                           context: context,
    //                           builder: (context) {
    //                             return AlertDialog(
    //                                 content: Text("Please Login!"));
    //                           });
    //                     } else {
    //                       _postQuery(widget.api);
    //                       print("post answer");
    //                     }
    //                   },
    //                 ),
    //                 IconButton(
    //                   icon: Icon(Icons.image),
    //                   onPressed: () async {
    //                     setState(() {
    //                       isLoading = true;
    //                     });
    //                     image =
    //                         await _picker.getImage(source: ImageSource.gallery);
    //                     bytes = await image.readAsBytes();
    //                     setState(() {
    //                       filename = image.path;
    //                       isLoading = false;
    //                     });
    //                   },
    //                 ),
    //                 SizedBox(width: 20),
    //                 Text("file size: " +
    //                     (bytes.toString().length > 4
    //                         ? bytes.toString().length.toString() + " bytes"
    //                         : "None")),
    //                 bytes.toString().length > 4
    //                     ? IconButton(
    //                         icon: Icon(Icons.cancel),
    //                         onPressed: () {
    //                           setState(() {
    //                             bytes = null;
    //                           });
    //                         },
    //                       )
    //                     : Container()
    //               ]))
    //   ],
    // ));
  }
}
