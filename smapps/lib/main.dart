import 'package:flutter/material.dart';

import 'pages/login.dart';

import 'pages/profile.dart';
import 'pages/home.dart';
import 'pages/questions.dart';
import 'pages/answers.dart';

void main() {
  runApp(MaterialApp(routes: {
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    // '/forum': (context) => ForumScreen(),
    // '/questions': (context) => QuestionScreen(),
    // '/answers': (context) => AnswerScreen()
  }));
}
