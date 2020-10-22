import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  

  @override
  Widget build(BuildContext context){

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return(
     Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(onPressed: null,
                child: Text("Find out more!")
              ),
              // const SizedBox(width: 8),
              // TextButton(
              //   child: const Text('LISTEN'),
              //   onPressed: () {/* ... */},
              // ),
              const SizedBox(width: 8),
            ],
          ),
        ])
    );
  }
}