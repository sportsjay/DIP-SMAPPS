import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/apiurl.dart';

class ForumScreen extends StatefulWidget {
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List courseData;
  var isLoading = false;

  _fetchCourseCodes() async {
    setState(() {
      isLoading = true;
    });
    final res =
        await http.get(service_url.get_URL, headers: {"auth-token": ""});
    if (res.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      courseData = json.decode(res.body);
      print(courseData);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data from database //
    _fetchCourseCodes();
    return Scaffold(body: 
      Padding( 
        child:ListView(
          children: courseData,
    )));
  }
}
