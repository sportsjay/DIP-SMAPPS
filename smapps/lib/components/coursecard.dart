import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  CourseCard({Key key, this.id, this.name, this.token}) : super(key: key);

  int id;
  String token;
  String name;

  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    // final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    // courseName = arguments['courseName'];
    // courseId = arguments['courseId'];
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: Icon(Icons.school),
        title: Text(widget.name),
        subtitle: Text('Null'),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
              onPressed: () {
                print("redirect");
                Navigator.pushNamed(context, '/home',
                    arguments: {'isLoggedToken': widget.token});
              },
              child: Text("Find out more!")),
          const SizedBox(width: 8),
        ],
      ),
    ]);
  }
}
