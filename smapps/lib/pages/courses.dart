import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
import 'package:smapps/redux/actions/actions.dart';

//component
import 'package:smapps/components/coursecard.dart';

//Redux
import 'package:smapps/redux/store.dart';

class CourseScreen extends StatefulWidget {
  CourseScreen({Key key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  var courseData = [];
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

  _fetchCourseCodes() async {
    print("fetch course");
    setState(() {
      isLoading = true;
    });
    final res = await http.get(service_url.get_course_URL);
    if (res.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      courseData = json.decode(res.body);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCourseCodes();
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

    return StoreConnector<AppState, int>(
      converter: (store) => store.state.courseId.id,
      builder: (context, id) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Courses"),
              centerTitle: true,
              actions: <Widget>[
                logoutButton(),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            body: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: courseData.length,
                itemBuilder: (BuildContext context, int index) {
                  return CourseCard(
                      id: courseData[index]['id'],
                      name: courseData[index]['name'],
                      description: courseData[index]['description'],
                      countQuestions: courseData[index]['countQuestions']);
                }));
      },
    );
  }
}
