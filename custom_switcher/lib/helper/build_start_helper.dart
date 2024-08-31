import 'dart:math';

import 'package:flutter/material.dart';

class BuildStartHelper {
  static List<Widget> buildStars(
      {required int starCount, required Size deviceSize, bool? isNight}) {
    List<Widget> stars = [];
    for (int i = 0; i < starCount; i++) {
      stars.add(_buildStar(
          top: randomX(deviceSize),
          left: randomY(deviceSize),
          val: isNight ?? false));
    }
    return stars;
  }

  static double randomX(Size deviceSize) {
    int maxX = (deviceSize.height).toInt();
    return Random().nextInt(maxX).toDouble();
  }

  static double randomY(Size deviceSize) {
    int maxY = (deviceSize.width).toInt();
    return Random().nextInt(maxY).toDouble();
  }

  static Widget _buildStar({
    double top = 0,
    double left = 0,
    bool val = false,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Opacity(
        opacity: val ? 1 : 0,
        child: const CircleAvatar(
          radius: 2,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
