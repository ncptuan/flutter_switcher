// library day_night_switch;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'day_night_switch_painter.dart';

const double _kTrackHeight = 80.0;
const double _kTrackWidth = 200.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kThumbRadius = 36.0;
const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;
const double _kSwitchWidth = _kTrackWidth - 2 * _kTrackRadius + _kSwitchMinSize;
const double _kSwitchHeight = _kSwitchMinSize + 8.0;

class CustomDayNightSwitch extends StatefulWidget {
  const CustomDayNightSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.sunImage,
    this.moonImage,
    this.sunColor = const Color(0xFFFDB813),
    this.moonColor = const Color(0xFFf5f3ce),
    this.dayColor = const Color(0xFF87CEEB),
    this.nightColor = const Color(0xFF003366),
    this.mouseCursor,
    this.size = const Size(_kSwitchWidth, _kSwitchHeight),
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final DragStartBehavior dragStartBehavior;
  final ImageProvider? sunImage;
  final ImageProvider? moonImage;
  final Color sunColor;
  final Color moonColor;
  final Color dayColor;
  final Color nightColor;
  final MouseCursor? mouseCursor;
  final Size size;

  @override
  State<CustomDayNightSwitch> createState() => _CustomDayNightSwitchState();
}

class _CustomDayNightSwitchState extends State<CustomDayNightSwitch>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _painter = DayNightSwitchPainter();

  @override
  void didUpdateWidget(covariant CustomDayNightSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (position.value == 0.0 || position.value == 1.0) {
        position
          ..curve = Curves.easeIn
          ..reverseCurve = Curves.easeOut;
      }
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged!(value!);
  }

  double get _trackInnerLength => widget.size.width - _kSwitchMinSize;

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / _trackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          positionController.value -= delta;
          break;
        case TextDirection.ltr:
          positionController.value += delta;
          break;
      }
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged!(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final SwitchThemeData switchTheme = SwitchTheme.of(context);

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor =
        WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
      return WidgetStateProperty.resolveAs<MouseCursor?>(
              widget.mouseCursor, states) ??
          switchTheme.mouseCursor?.resolve(states) ??
          WidgetStateProperty.resolveAs<MouseCursor>(
              WidgetStateMouseCursor.clickable, states);
    });

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: buildToggleable(
          mouseCursor: effectiveMouseCursor,
          size: widget.size,
          painter: _painter
            ..position = position
            ..reaction = reaction
            ..reactionFocusFade = reactionFocusFade
            ..reactionHoverFade = reactionHoverFade
            ..inactiveReactionColor = Colors.transparent
            ..reactionColor = Colors.transparent
            ..hoverColor = Colors.pink
            ..focusColor = Colors.green
            ..splashRadius = kRadialReactionRadius
            ..isFocused = states.contains(WidgetState.focused)
            ..isHovered = states.contains(WidgetState.hovered)
            ..activeColor = Colors.yellow
            ..inactiveColor = Colors.yellow
            ..sunImage = widget.sunImage
            ..moonImage = widget.moonImage
            ..sunColor = widget.sunColor
            ..moonColor = widget.moonColor
            ..dayColor = widget.dayColor
            ..nightColor = widget.nightColor
            ..configuration = createLocalImageConfiguration(context)
            ..textDirection = Directionality.of(context)
            ..isInteractive = isInteractive
            ..trackInnerLength = _trackInnerLength,
        ),
      ),
    );
  }
}
