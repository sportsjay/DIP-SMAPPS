import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:smapps/pages/home.dart';

//Redux
import 'package:smapps/redux/store.dart';

void main() {
  Redux.init();
  
  runApp(
    MaterialApp(
      home: StoreProvider<AppState>(store: Redux.store, child: HomeScreen()),
      debugShowCheckedModeBanner: false,
    ),
  );
}
