import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// import 'login.dart';

import 'package:smapps/pages/forum.dart';
import 'package:smapps/pages/profile.dart';
import 'package:smapps/pages/maps.dart';

//Redux
import 'package:smapps/redux/store.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String token;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _selectWidget(int index) {
    switch (index) {
      case 0: //Default homepage
        {
          return Scaffold(
            appBar: new AppBar(
                title: new Text("Home"),
                centerTitle: true,
                backgroundColor: Colors.black),
            body: new Container(
              child: new Center(
                child: new Container(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Image.network(
                          'https://www.flaticon.com/svg/static/icons/svg/2928/2928883.svg',
                          fit: BoxFit.scaleDown,
                          width: 150.0,
                          height: 150.0,
                        ),
                        new RaisedButton(
                            key: null,
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                            color: const Color(0xFFe0e0e0),
                            child: new Text(
                              "MAPS",
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Merriweather"),
                            )),
                        SizedBox(height: 30),
                        new Image.network(
                          'https://www.flaticon.com/svg/static/icons/svg/3375/3375163.svg',
                          fit: BoxFit.cover,
                          width: 150.0,
                          height: 150.0,
                        ),
                        new RaisedButton(
                            key: null,
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                            color: const Color(0xFFe0e0e0),
                            child: new Text(
                              "DISCUSSION FORUM",
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Merriweather"),
                            ))
                      ]),
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  width: 1.7976931348623157e+308,
                  height: 1.7976931348623157e+308,
                ),
              ),
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              width: 1.7976931348623157e+308,
              height: 1.7976931348623157e+308,
            ),
          );
        }
        break;
      case 1:
        {
          return ForumScreen();
        }
        break;
      case 2:
        {
          return GMap();
        }
        break;
      case 3:
        {
          return ProfileScreen();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // homepage
    Widget homePage = Scaffold(
      body: _selectWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Forum")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("Profile")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[200],
        onTap: _onItemTapped,
      ),
    );

    return StoreConnector<AppState, bool>(
        converter: (store) => store.state.selectForumScreenState.isLoading,
        builder: (context, isLoading) {
          print("loading: $isLoading");
          return homePage;
        });
  }
}
