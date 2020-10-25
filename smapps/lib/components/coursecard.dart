import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smapps/redux/actions/actions.dart';

//Redux
import 'package:smapps/redux/store.dart';

class CourseCard extends StatefulWidget {
  CourseCard({Key key, this.id, this.name, this.token}) : super(key: key);

  final int id;
  final String token;
  final String name;

  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => [
        store.state.courseId.id,
        store.state.selectForumScreenState.screenSelect
      ],
      builder: (context, args) {
        return Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                    Redux.store
                        .dispatch(selectCourseId(Redux.store, widget.id));
                    Redux.store.dispatch(
                        selectForumScreenStateAction(Redux.store, "questions"));
                  },
                  child: Text("Find out more!")),
            ],
          ),
        ]));
      },
    );
  }
}
