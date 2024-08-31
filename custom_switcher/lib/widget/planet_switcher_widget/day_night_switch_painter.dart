import 'package:flutter/material.dart';

class DayNightSwitchPainter extends ToggleablePainter {
  static const double _kTrackHeight = 80.0;
  static const double _kTrackWidth = 200.0;
  static const double _kTrackRadius = _kTrackHeight / 2.0;
  static const double _kThumbRadius = 36.0;
  static const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;
  static const double _kSwitchWidth =
      _kTrackWidth - 2 * _kTrackRadius + _kSwitchMinSize;
  static const double _kSwitchHeight = _kSwitchMinSize + 8.0;

  ImageProvider? _sunImage;
  ImageProvider? get sunImage => _sunImage;
  set sunImage(ImageProvider? value) {
    if (value == _sunImage) return;
    _sunImage = value;
    notifyListeners();
  }

  ImageProvider? _moonImage;
  ImageProvider? get moonImage => _moonImage;
  set moonImage(ImageProvider? value) {
    if (value == _moonImage) return;
    _moonImage = value;
    notifyListeners();
  }

  Color? _sunColor;
  Color get sunColor => _sunColor!;
  set sunColor(Color value) {
    if (value == _sunColor) return;
    _sunColor = value;
    notifyListeners();
  }

  Color? _moonColor;
  Color get moonColor => _moonColor!;
  set moonColor(Color value) {
    if (value == _moonColor) return;
    _moonColor = value;
    notifyListeners();
  }

  Color? _dayColor;
  Color get dayColor => _dayColor!;
  set dayColor(Color value) {
    if (value == _dayColor) return;
    _dayColor = value;
    notifyListeners();
  }

  Color? _nightColor;
  Color get nightColor => _nightColor!;
  set nightColor(Color value) {
    if (value == _nightColor) return;
    _nightColor = value;
    notifyListeners();
  }

  ImageConfiguration get configuration => _configuration!;
  ImageConfiguration? _configuration;
  set configuration(ImageConfiguration value) {
    if (value == _configuration) return;
    _configuration = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    notifyListeners();
  }

  bool get isInteractive => _isInteractive!;
  bool? _isInteractive;
  set isInteractive(bool value) {
    if (value == _isInteractive) {
      return;
    }
    _isInteractive = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;
  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  bool _isPainting = false;

  void _handleDecorationChanged() {
    // If the image decoration is available synchronously, we'll get called here
    // during paint. There's no reason to mark ourselves as needing paint if we
    // are already in the middle of painting. (In fact, doing so would trigger
    // an assert).
    if (!_isPainting) notifyListeners();
  }

  Color? _cachedThumbColor;
  ImageProvider? _cachedThumbImage;
  BoxPainter? _cachedThumbPainter;

  BoxDecoration _createDefaultThumbDecoration(
      Color color, ImageProvider? image) {
    return BoxDecoration(
      color: color,
      image: image == null ? null : DecorationImage(image: image),
      shape: BoxShape.circle,
      boxShadow: kElevationToShadow[1],
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bool isEnabled = isInteractive;
    final double currentValue = position.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Color trackColor = Color.lerp(dayColor, nightColor, currentValue)!;
    final Color thumbColor = Color.lerp(sunColor, moonColor, currentValue)!;

    final ImageProvider? thumbImage =
        isEnabled ? (currentValue < 0.5 ? sunImage : moonImage) : sunImage;
    final trackPaint = Paint()..color = trackColor;
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth =
          _kTrackHeight * 0.05 + _kTrackHeight * 0.05 * (1 - currentValue)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final starPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _kTrackHeight * 0.05 * currentValue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Offset trackPaintOffset =
        _computeTrackPaintOffset(size, _kTrackWidth, _kTrackHeight);
    const double thumbRadius = _kThumbRadius;
    final Offset thumbPaintOffset =
        _computeThumbPaintOffset(trackPaintOffset, visualPosition, thumbRadius);
    final Offset radialReactionOrigin =
        Offset(thumbPaintOffset.dx + _kThumbRadius, size.height / 2);

    _paintTrack(canvas, trackPaint, trackPaintOffset);
    _paintBackground(
        canvas, linePaint, starPaint, trackPaintOffset, currentValue);
    paintRadialReaction(canvas: canvas, origin: radialReactionOrigin);
    _paintThumb(
      canvas,
      thumbPaintOffset,
      currentValue,
      thumbColor,
      thumbImage,
      thumbRadius,
    );
    _paintForegroundLines(canvas, linePaint, trackPaintOffset, currentValue);
  }

  /// Computes canvas offset for track's upper left corner
  Offset _computeTrackPaintOffset(
      Size canvasSize, double trackWidth, double trackHeight) {
    final double horizontalOffset = (canvasSize.width - _kTrackWidth) / 2.0;
    final double verticalOffset = (canvasSize.height - _kTrackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  /// Computes canvas offset for thumb's upper left corner as if it were a
  /// square
  Offset _computeThumbPaintOffset(
      Offset trackPaintOffset, double visualPosition, double thumbRadius) {
    // How much thumb radius extends beyond the track
    final double additionalThumbRadius = thumbRadius - _kTrackRadius;

    final double horizontalProgress = visualPosition * trackInnerLength;
    final double thumbHorizontalOffset =
        trackPaintOffset.dx - additionalThumbRadius + horizontalProgress;
    final double thumbVerticalOffset =
        trackPaintOffset.dy - additionalThumbRadius;

    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrack(Canvas canvas, Paint paint, Offset trackPaintOffset) {
    final Rect trackRect = Rect.fromLTWH(
      trackPaintOffset.dx,
      trackPaintOffset.dy,
      _kTrackWidth,
      _kTrackHeight,
    );
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      const Radius.circular(_kTrackRadius),
    );
    canvas.drawRRect(trackRRect, paint);
  }

  void _paintBackground(Canvas canvas, Paint paint, Paint starPaint,
      Offset offset, double currentValue) {
    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.2,
        offset.dy + _kTrackHeight * 0.2,
      ),
      Offset(
        offset.dx +
            _kTrackWidth * 0.2 +
            (_kTrackWidth * 0.4) * (1 - currentValue),
        offset.dy + _kTrackHeight * 0.2,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.25,
        offset.dy + _kTrackHeight * 0.8,
      ),
      Offset(
        offset.dx +
            _kTrackWidth * 0.25 +
            (_kTrackWidth * 0.3) * (1 - currentValue),
        offset.dy + _kTrackHeight * 0.8,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.1,
        offset.dy + _kTrackHeight * 0.6,
      ),
      Offset(
        offset.dx + _kTrackWidth * 0.1,
        offset.dy + _kTrackHeight * 0.6,
      ),
      starPaint,
    );
  }

  void _paintThumb(
    Canvas canvas,
    Offset thumbPaintOffset,
    double currentValue,
    Color thumbColor,
    ImageProvider? thumbImage,
    double thumbRadius,
  ) {
    try {
      _isPainting = true;
      if (_cachedThumbPainter == null ||
          thumbColor != _cachedThumbColor ||
          thumbImage != _cachedThumbImage) {
        _cachedThumbColor = thumbColor;
        _cachedThumbImage = thumbImage;
        _cachedThumbPainter?.dispose();
        _cachedThumbPainter =
            _createDefaultThumbDecoration(thumbColor, thumbImage)
                .createBoxPainter(_handleDecorationChanged);
      }
      final BoxPainter thumbPainter = _cachedThumbPainter!;

      // The thumb contracts slightly during the animation
      final double inset = 1.0 - (currentValue - 0.5).abs() * 2.0;
      final double radius = thumbRadius - inset;

      thumbPainter.paint(
        canvas,
        thumbPaintOffset - const Offset(0, 0),
        configuration.copyWith(size: Size.fromRadius(radius)),
      );

      // canvas.drawCircle(thumbPaintOffset, thumbRadius, Paint()..color = thumbColor);
    } finally {
      _isPainting = false;
    }
  }

  void _paintForegroundLines(
      Canvas canvas, Paint paint, Offset offset, double currentValue) {
    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.35,
        offset.dy + _kTrackHeight * 0.5,
      ),
      Offset(
        offset.dx +
            _kTrackWidth * 0.35 +
            (_kTrackWidth * 0.4) * (1 - currentValue),
        offset.dy + _kTrackHeight * 0.5,
      ),
      paint,
    );
  }

  @override
  void dispose() {
    _cachedThumbPainter?.dispose();
    _cachedThumbPainter = null;
    _cachedThumbColor = null;
    _cachedThumbImage = null;
    super.dispose();
  }
}
