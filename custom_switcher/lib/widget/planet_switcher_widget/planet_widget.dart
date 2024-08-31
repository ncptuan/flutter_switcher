import 'package:custom_switcher/widget/planet_switcher_widget/aura_widget.dart';
import 'package:flutter/material.dart';

class PlanetWidget extends StatefulWidget {
  final bool? isSun;
  const PlanetWidget({
    super.key,
    this.isSun,
  });

  @override
  State<PlanetWidget> createState() => _PlanetWidgetState();
}

class _PlanetWidgetState extends State<PlanetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: AnimatedBuilder(
        animation:
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AuraWidget(
                radius: 400 * _controller.value,
                currentAnimationValue: _controller.value,
              ),
              AuraWidget(
                radius: 500 * _controller.value,
                currentAnimationValue: _controller.value,
              ),
              AuraWidget(
                radius: 600 * _controller.value,
                currentAnimationValue: _controller.value,
              ),
              SizedBox(
                width: 256,
                height: 256,
                child: (widget.isSun ?? false)
                    ? Image.asset('assets/sun.png')
                    : Image.asset('assets/moon.png'),
              ),
            ],
          );
        },
      ),
    );
  }
}
