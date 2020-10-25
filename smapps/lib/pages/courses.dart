import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smapps/constants/apiurl.dart';
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
  var courseData = List();
  var isLoading = false;

  _fetchCourseCodes() async {
    print("fetch course");
    setState(() {
      isLoading = true;
      courseData.add({'id': 0, 'name': "Course Not Available"});
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
    return StoreConnector<AppState, int>(
      converter: (store) => store.state.courseId.id,
      builder: (context, id) {
        return Scaffold(
            body: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: courseData.length,
                itemBuilder: (BuildContext context, int index) {
                  return CourseCard(
                      id: courseData[index]['id'],
                      name: courseData[index]['name']);
                }));
      },
    );
  }
}
