import 'dart:math';

import 'package:custom_switcher/helper/build_start_helper.dart';
import 'package:flutter/material.dart';

import 'widget/widget.dart';

void main() {
  runApp(const MyApp());
}

const dayColor = Color.fromARGB(255, 34, 69, 105);
const nightColor = Color(0xFF1e2230);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day Night Switch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool val = false;
  late AnimationController _controller;
  late Size size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF414a4c),
      body: AnimatedContainer(
        color: val ? nightColor : dayColor,
        duration: const Duration(seconds: 1),
        child: Stack(
          children: <Widget>[
            ...screenDecoration(),
            Center(
              child: PlanetSwitchWidget(
                value: val,
                onChanged: (bool value) {
                  setState(() {
                    val = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Transform.translate(
        offset: const Offset(160, -360),
        child: PlanetWidget(
          isSun: !val,
        ),
      ),
    );
  }

  List<Widget> screenDecoration() {
    return [
      ...BuildStartHelper.buildStars(
          starCount: 20, deviceSize: size, isNight: val),
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        height: 200,
        child: Opacity(
          opacity: val ? 0 : 1.0,
          child: Image.asset(
            'assets/cloud.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        height: 200,
        child: Image.asset(
          val ? 'assets/mountain2_night.png' : 'assets/mountain2.png',
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        bottom: -10,
        left: 0,
        right: 0,
        height: 140,
        child: Image.asset(
          val ? 'assets/mountain_night.png' : 'assets/mountain1.png',
          fit: BoxFit.cover,
        ),
      ),
      AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              Positioned(
                bottom: -20,
                right: 0,
                left: 0,
                child: Transform.translate(
                  offset: Offset(50 * _controller.value, 0),
                  child: Opacity(
                    opacity: val ? 0.0 : 0.8,
                    child: Image.asset(
                      'assets/cloud2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                right: 0,
                left: 0,
                child: Transform.translate(
                  offset: Offset(100 * _controller.value, 0),
                  child: Opacity(
                    opacity: val ? 0.0 : 0.4,
                    child: Image.asset(
                      'assets/cloud3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
}
