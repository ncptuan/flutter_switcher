import 'package:flutter/material.dart';

class AuraWidget extends StatelessWidget {
  final double? radius;
  final double? currentAnimationValue;
  final Color? planetColor;

  const AuraWidget({
    super.key,
    this.radius,
    this.currentAnimationValue,
    this.planetColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (planetColor ?? Colors.orangeAccent)
            .withOpacity(1 - (currentAnimationValue ?? 0)),
      ),
    );
  }
}
