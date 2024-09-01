import 'package:custom_switcher/constant.dart';
import 'package:custom_switcher/widget/widget.dart';
import 'package:flutter/material.dart';

import '../../style/style.dart';

const double _kTrackHeight = 80.0;
const double _kTrackWidth = 180.0;

class PlanetSwitchWidget extends StatefulWidget {
  final bool value;
  final double width;
  final double height;
  final ValueChanged<bool> onChanged;

  const PlanetSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = _kTrackWidth,
    this.height = _kTrackHeight,
  });

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
        vsync: this, duration: Constants.switchAnimationDuration);

    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double kTrackRadius = widget.height / 2.0;
    double kSwitchWidth = widget.height - 5;
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
            borderRadius: BorderRadius.circular(kTrackRadius),
            child: AnimatedContainer(
              duration: Constants.switchAnimationDuration,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.value
                    ? MyColors.nightSwitchBackgroundColor
                    : MyColors.daySwitchBackgroundColor,
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
                    left: handlePlanetPosition(switchButtonWidth: kSwitchWidth),
                    child: Container(
                      key: UniqueKey(),
                      width: kSwitchWidth,
                      height: kSwitchWidth,
                      margin: const EdgeInsets.all(Dimens.switchButtonSpacing),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kTrackRadius * 2),
                            boxShadow: Dimens.switchButtonAura),
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
                    left: handlePlanetPosition(switchButtonWidth: kSwitchWidth),
                    child: Visibility(
                      visible: _circleAnimation.value > 0.5 ? true : false,
                      child: Opacity(
                        opacity: _circleAnimation.value,
                        child: Container(
                          key: UniqueKey(),
                          width: kSwitchWidth,
                          height: kSwitchWidth,
                          margin:
                              const EdgeInsets.all(Dimens.switchButtonSpacing),
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

  double handlePlanetPosition(
      {bool? isMoon, required double switchButtonWidth}) {
    double position = 0;
    position =
        ((widget.width - switchButtonWidth - 8) * _circleAnimation.value);
    return position;
  }
}
