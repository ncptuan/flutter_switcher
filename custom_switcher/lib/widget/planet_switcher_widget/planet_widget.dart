import 'package:custom_switcher/widget/planet_switcher_widget/aura_widget.dart';
import 'package:flutter/material.dart';

class PlanetWidget extends StatefulWidget {
  final bool? isSun;
  final List<double>? listAura;
  final bool isTurnOffAura;
  const PlanetWidget({
    super.key,
    this.isSun,
    this.listAura = const [
      400.0,
      500.0,
      600.0,
    ],
    this.isTurnOffAura = false,
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
          return widget.isTurnOffAura
              ? SizedBox(
                  width: 256,
                  height: 256,
                  child: (widget.isSun ?? false)
                      ? Image.asset('assets/sun.png')
                      : Image.asset('assets/moon.png'),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    AuraWidget(
                      radius: (widget.listAura?[0] ?? 400) * _controller.value,
                      currentAnimationValue: _controller.value,
                      auraColor: (widget.isSun ?? false) ? null : Colors.white,
                    ),
                    AuraWidget(
                      radius: (widget.listAura?[1] ?? 500) * _controller.value,
                      currentAnimationValue: _controller.value,
                      auraColor: (widget.isSun ?? false) ? null : Colors.white,
                    ),
                    AuraWidget(
                      radius: (widget.listAura?[2] ?? 600) * _controller.value,
                      currentAnimationValue: _controller.value,
                      auraColor: (widget.isSun ?? false) ? null : Colors.white,
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
