import 'package:custom_switcher/constant.dart';
import 'package:custom_switcher/main.dart';
import 'package:flutter/material.dart';

import '../helper/build_start_helper.dart';
import '../widget/widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Constants.auraAnimationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    isDarkMode = MyApp.of(context).getThemeMode() == ThemeMode.dark;
    return Scaffold(
      body: AnimatedContainer(
        color: theme.scaffoldBackgroundColor,
        duration: Constants.switchAnimationDuration,
        child: Stack(
          children: <Widget>[
            ...screenDecoration(deviceSize: size),
            Center(
              child: PlanetSwitchWidget(
                value: isDarkMode,
                onChanged: (bool value) {
                  MyApp.of(context)
                      .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Transform.translate(
        offset: Constants.planetOffset,
        child: PlanetWidget(
          isSun: !isDarkMode,
        ),
      ),
    );
  }

  List<Widget> screenDecoration({
    required Size deviceSize,
  }) {
    return [
      ...BuildStartHelper.buildStars(
        starCount: Constants.numberOfStars,
        deviceSize: deviceSize,
        isNight: isDarkMode,
      ),
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Opacity(
          opacity: isDarkMode ? 0 : 1.0,
          child: Image.asset(
            'assets/cloud.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Image.asset(
          isDarkMode ? 'assets/mountain2_night.png' : 'assets/mountain2.png',
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        bottom: -10,
        left: 0,
        right: 0,
        child: Image.asset(
          isDarkMode ? 'assets/mountain_night.png' : 'assets/mountain1.png',
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
                    opacity: isDarkMode ? 0.0 : 0.8,
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
                    opacity: isDarkMode ? 0.0 : 0.4,
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
