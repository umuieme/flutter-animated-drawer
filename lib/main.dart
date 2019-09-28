import 'package:animated_drawer_menu/animated_drawer.dart';
import 'package:animated_drawer_menu/my_app.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MainScreen(),
    );
  }
}