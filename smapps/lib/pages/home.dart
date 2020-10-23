import 'package:flutter/material.dart';
import 'forum.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String user;
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    ForumScreen(), //forum page
    Text(
      'Map',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    user = arguments['isLoggedToken'];

    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  title: Text("Forum")
                  // label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text("Map")
                  // label: 'Business',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text("Profile")
                  // label: 'School',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue[900],
              onTap: _onItemTapped,
            ),);
  }
}
