import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  final AnimatedDrawerController drawerController;
  const AnimatedDrawer(
      {Key key, @required this.child, this.drawer, this.drawerController})
      : super(key: key);

  @override
  AnimatedDrawerState createState() => AnimatedDrawerState();
}

class AnimatedDrawerState extends State<AnimatedDrawer>
    with SingleTickerProviderStateMixin {
  static const int DURATION_MS = 400;
  AnimationController _controller;
  Animation<double> _drawerAnimation;
  Animation<double> _drawerLeftAnimation;
  Animation<double> _bodyAnimation;
  double drawerMaxWidth;
  @override
  void initState() {
    super.initState();
    // drawerMaxWidth = MediaQuery.of(context).size.width*0.7;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: DURATION_MS));
    _drawerAnimation = _controller.drive(Tween(begin: 1, end: 0.3));
    _drawerLeftAnimation = _controller.drive(Tween(begin: -0.7, end: 0));
    _bodyAnimation = _controller.drive(Tween(begin: 0, end: 0.1));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        value = MediaQuery.of(context).size.width * 0.7;
      } else if (status == AnimationStatus.dismissed) {
        value = 0;
      }
      setState(() {});
    });

    if (widget.drawerController != null)
      widget.drawerController
          ._addListeners(_openDrawer, _closeDrawer, _isDrawerOpen);
  }

  _openDrawer() {
    if (_controller.value == 1) return;
    _controller.forward();
  }

  _closeDrawer() {
    if (_controller.value == 0) return;
    _controller.reverse();
  }

  bool _isDrawerOpen() {
    return _controller.value > 0;
  }

  double value = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _closeDrawer();
      },
      onHorizontalDragEnd: (dragdetails) {
        if (_controller.value == 0 || _controller.value == 1) return;
        if (dragdetails.primaryVelocity != 0) {
          _controller.fling(velocity: dragdetails.velocity.pixelsPerSecond.dx);
          return;
        }

        double distanceToTravel = _controller.value < 0.5
            ? -_controller.value
            : 1 - _controller.value;
        double velocity = distanceToTravel / 1000;
        _controller.fling(velocity: velocity);
      },
      onHorizontalDragUpdate: (dragupdate) {
        double drawerMaxWidth = MediaQuery.of(context).size.width * 0.7;
        if (value < drawerMaxWidth || dragupdate.primaryDelta < 0)
          value += dragupdate.primaryDelta;
        _controller.value = lerpDouble(0.0, 1.0, value / drawerMaxWidth);
      },
      child: Material(
      color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            _buildMainBody(),
            if (_controller.value != 0)
              Container(
                color: Colors.transparent,
              ),
            _buildDrawer(),
          ],
        ),
      ),
    );
  }

  AnimatedBuilder _buildDrawer() {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        color: Colors.grey,
        child: widget.drawer),
      builder: (context, child) {
        return _controller.value == 0
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(width: 20),
                child: Container(
                  color: Colors.transparent,
                ),
              )
            : Positioned(
                top: 0,
                right:
                    MediaQuery.of(context).size.width * _drawerAnimation.value,
                left:
                    MediaQuery.of(context).size.width * (_drawerLeftAnimation.value),
                bottom: 0,
                child: child,
              );
      },
    );
  }

  AnimatedBuilder _buildMainBody() {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _bodyAnimation.value,
          bottom: MediaQuery.of(context).size.height * _bodyAnimation.value,
          left:
              MediaQuery.of(context).size.width * (1 - _drawerAnimation.value),
          right:
              -MediaQuery.of(context).size.width * (1 - _drawerAnimation.value),
          child: Stack(
            children: <Widget>[
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class AnimatedDrawerController {
  VoidCallback _openListener;

  VoidCallback _closeListener;
  bool Function() _isDrawerOpen;

  void _addListeners(VoidCallback openListener, VoidCallback closeListener,
      bool Function() isDrawerOpen) {
    this._openListener = openListener;
    this._closeListener = closeListener;
    this._isDrawerOpen = isDrawerOpen;
  }

  open() {
    _openListener();
  }

  close() {
    _closeListener();
  }

  bool isDrawerOpen() {
    return _isDrawerOpen();
  }
}
