import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
            appBar: AppBar(
                title: Image.asset(
                  "assets/logo.png",
                  height: 40,
                  semanticLabel: "EEEnquiry",
                ),
                centerTitle: true,
                backgroundColor: Colors.black),
            body: Container(
              child: Center(
                child: Container(
                  child: ListView(children: [
                    SizedBox(height: 50),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Text('Upcoming Events',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                textAlign: TextAlign.left),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Card(
                                elevation: 5,
                                child: new Image.asset('assets/event1.jpg'),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Card(
                                elevation: 5,
                                child: new Image.asset('assets/event2.jpg'),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Card(
                                elevation: 5,
                                child: new Image.asset('assets/event3.jpg'),
                              )),
                          Image.asset(
                            "assets/2928883.png",
                            fit: BoxFit.scaleDown,
                            width: 150.0,
                            height: 150.0,
                          ),
                          RaisedButton(
                              key: null,
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              color: const Color(0xFFe0e0e0),
                              child: Text(
                                "MAPS",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: const Color(0xFF000000),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Merriweather"),
                              )),
                          SizedBox(height: 30),
                          Image.asset(
                            'assets/3375163.png',
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
                              child: Text(
                                "DISCUSSION FORUM",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: const Color(0xFF000000),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Merriweather"),
                              )),
                          SizedBox(height: 50)
                        ])
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
              label: "Home",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Forum",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
              backgroundColor: Colors.black),
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
