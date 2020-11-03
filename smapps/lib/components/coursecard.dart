import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smapps/redux/actions/actions.dart';

//Redux
import 'package:smapps/redux/store.dart';

class CourseCard extends StatefulWidget {
  CourseCard({Key key, this.id, this.name = "None", this.description = "None", this.countQuestions="0"})
      : super(key: key);

  int id;
  String description;
  String name;
  String countQuestions;

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
            subtitle: Text(widget.description),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("Questions: "+widget.countQuestions),
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
