import 'package:flutter/material.dart';
// import 'forum.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String user;

  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Forum',
      style: optionStyle,
    ),
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
