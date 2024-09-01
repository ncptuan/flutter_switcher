import 'package:flutter/material.dart';

class AuraWidget extends StatelessWidget {
  final double? radius;
  final double? currentAnimationValue;
  final Color? auraColor;

  const AuraWidget({
    super.key,
    this.radius,
    this.currentAnimationValue,
    this.auraColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (auraColor ?? Colors.orangeAccent)
            .withOpacity(1 - (currentAnimationValue ?? 0)),
      ),
    );
  }
}
