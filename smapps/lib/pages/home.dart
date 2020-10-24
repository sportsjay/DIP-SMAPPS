import 'package:flutter/material.dart';
import 'forum.dart';
import 'profile.dart';

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

  _selectWidget(int index, String token) {
    switch (index) {
      case 0:
        {
          return ForumScreen(token: token);
        }
        break;
      case 1:
        {
          return Text("Map");
        }
        break;
      case 2:
        {
          return ProfileScreen(token: token);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    token = arguments['isLoggedToken'];

    return Scaffold(
      body: _selectWidget(_selectedIndex, token),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Forum")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("Profile")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
