import 'package:animated_drawer_menu/animated_drawer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AnimatedDrawerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimatedDrawerController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      drawerController: _controller,
      drawer: Container(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text("111111111@gmail.com"),
              accountName: Text("Umesh Basnet"),
            ),
            RaisedButton(
              child: Text("close drawer"),
              onPressed: () {
                _controller.close();
              },
            )
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Animated Drawer"),
          leading: IconButton(
            onPressed: () {
              // _drawerKey.currentState.openDrawer();
            _controller.isDrawerOpen() ? _controller.close() : _controller.open();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        backgroundColor: Colors.red,
        body: PageView(
          children: <Widget>[Text("111111111"), Text("22222222")],
        ),
      ),
    );
  }
}
