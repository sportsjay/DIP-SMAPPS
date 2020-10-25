import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  InputForm({Key key, this.api}) : super(key: key);

  final String api;
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField()
      ],
    );
  }
}
