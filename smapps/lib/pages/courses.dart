import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/apiurl.dart';
//component
import '../components/coursecard.dart';


class CourseScreen extends StatefulWidget {
  CourseScreen({Key key, this.token});

  String token;
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
    });
    final res = await http.get(service_url.get_course_URL);
    if (res.statusCode != 200) {
      setState(() {
        isLoading = false;
        courseData.add({'id': 0, 'name': "Course Not Available"});
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
    // TODO: implement initState
    super.initState();
    _fetchCourseCodes();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data from database //
    return Scaffold(
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: courseData.length,
            itemBuilder: (BuildContext context, int index) {
              return CourseCard(
                  id: courseData[index]['id'], name: courseData[index]['name']);
            }));
  }
}
