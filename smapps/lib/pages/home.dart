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
      case 0:
        {
          return ForumScreen();
        }
        break;
      case 1:
        {
          return GMap();
        }
        break;
      case 2:
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
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
