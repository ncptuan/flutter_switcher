import 'package:custom_switcher/widget/widget.dart';
import 'package:flutter/material.dart';

import 'aura_widget.dart';

const double _kTrackHeight = 80.0;
const double _kTrackWidth = 180.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kThumbRadius = 36.0;
const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;
// const double _kSwitchWidth = _kTrackWidth - 2 * _kTrackRadius + _kSwitchMinSize;
// const double _kSwitchHeight = _kSwitchMinSize + 8.0;
const double _kSwitchWidth = _kTrackHeight - 5;
const double _kSwitchHeight = _kTrackHeight - 5;

class PlanetSwitchWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PlanetSwitchWidget(
      {super.key, required this.value, required this.onChanged});

  @override
  _PlanetSwitchWidgetState createState() => _PlanetSwitchWidgetState();
}

class _PlanetSwitchWidgetState extends State<PlanetSwitchWidget>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _circleAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (widget.value) {
              widget.onChanged(false);
              _animationController.reverse();
            } else {
              widget.onChanged(true);
              _animationController.forward();
            }
          },
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(_kTrackRadius),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              width: _kTrackWidth,
              height: _kTrackHeight,
              decoration: BoxDecoration(
                color: widget.value
                    ? const Color(0xff2F2F2F)
                    : const Color(0xff2384BA),
                image: DecorationImage(
                  image: ExactAssetImage(
                    widget.value
                        ? 'assets/stars.png'
                        : 'assets/clouds_switch_button.png',
                  ),
                  fit: widget.value ? BoxFit.contain : BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: handlePlanetPosition(),
                    child: Container(
                      key: UniqueKey(),
                      width: _kSwitchWidth,
                      height: _kSwitchHeight,
                      margin: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(_kTrackRadius * 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              spreadRadius: 30,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.05),
                              spreadRadius: 45,
                            ),
                          ],
                        ),
                        child: const PlanetWidget(
                          isSun: true,
                          isTurnOffAura: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: handlePlanetPosition(),
                    child: Visibility(
                      visible: _circleAnimation.value > 0.5 ? true : false,
                      child: Opacity(
                        opacity: _circleAnimation.value,
                        child: Container(
                          width: _kSwitchWidth,
                          height: _kSwitchHeight,
                          margin: const EdgeInsets.all(4),
                          child: const PlanetWidget(
                            isSun: false,
                            isTurnOffAura: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double handlePlanetPosition({bool? isMoon}) {
    double position = 0;
    position = ((_kTrackWidth - _kSwitchWidth - 8) * _circleAnimation.value);
    return position;
  }
}
