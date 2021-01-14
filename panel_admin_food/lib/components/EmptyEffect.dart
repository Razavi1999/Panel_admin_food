import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class EmptyEffect extends StatefulWidget {
  Widget _child;
  double _outermostCircleStartRadius;
  double _outermostCircleEndRadius;
  double _startOpacity;
  Duration _animationTime;
  int _numberOfCircles;
  double _borderWidth;
  Color _borderColor;
  double _gap;
  Duration _delay;

  EmptyEffect({
    @required Widget child,
    @required Color borderColor,
    @required double outermostCircleStartRadius,
    @required double outermostCircleEndRadius,
    double startOpacity = 0.1,
    int numberOfCircles = 2,
    Duration delay = const Duration(seconds: 2),
    Duration animationTime = const Duration(seconds: 1),
    double borderWidth = 8,
    double gap = 15,
  }) {
    assert(numberOfCircles > 0);
    assert(gap > 0);
    assert(outermostCircleStartRadius > 0);
    assert(outermostCircleEndRadius > 0);
    assert(startOpacity > 0);
    assert(child != null);
    assert(delay >= animationTime);


    _child = child;
    _outermostCircleStartRadius = outermostCircleStartRadius;
    _outermostCircleEndRadius = outermostCircleEndRadius;
    _startOpacity = startOpacity;
    _animationTime = animationTime;
    _numberOfCircles = numberOfCircles;
    _borderWidth = borderWidth;
    _borderColor = borderColor;
    _gap = gap;
    _delay = delay;
  }

  @override
  _EmptyEffectState createState() => _EmptyEffectState();
}

class _EmptyEffectState extends State<EmptyEffect>
    with TickerProviderStateMixin {
  AnimationController _radiusOpacityController;
  Animation _radiusAnimation;
  Animation _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _radiusOpacityController = AnimationController(
      vsync: this,
      duration: widget._animationTime,
    )..addListener(() {
      setState(() {});
    });

    Timer.periodic(widget._delay, (_) {
      _radiusOpacityController.reset();
      _radiusOpacityController.forward();
    });

    _radiusAnimation = Tween(
        begin: widget._outermostCircleStartRadius,
        end: widget._outermostCircleEndRadius)
        .animate(
      CurvedAnimation(parent: _radiusOpacityController, curve: Curves.linear),
    );

    _opacityAnimation = Tween(begin: widget._startOpacity, end: 0.0).animate(
        CurvedAnimation(
            parent: _radiusOpacityController, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();
    _radiusOpacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          opacity: _opacityAnimation.value,
          child: CustomPaint(
            painter: _CustomPainter(
              numberOfCircles: widget._numberOfCircles,
              borderColor: widget._borderColor,
              borderWidth: widget._borderWidth,
              gap: widget._gap,
              outermostCircleRadius: _radiusAnimation.value,
            ),
          ),
        ),
        widget._child,
      ],
    );
  }
}

class _CustomPainter extends CustomPainter {
  int _numberOfCircles;
  double _borderWidth;
  Color _borderColor;
  double _gap;
  double _outermostCircleRadius;

  _CustomPainter({
    int numberOfCircles,
    double borderWidth,
    Color borderColor,
    double gap,
    double outermostCircleRadius,
  }) {
    _numberOfCircles = numberOfCircles;
    _borderWidth = borderWidth;
    _borderColor = borderColor;
    _outermostCircleRadius = outermostCircleRadius;
    _gap = gap;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = _borderColor
      ..strokeWidth = _borderWidth
      ..style = PaintingStyle.stroke;

    var center = Offset(size.width / 2, size.height / 2);

    //We draw from outermost to innermost possible circle
    int circleNum = 0;
    while (circleNum != _numberOfCircles &&
        (_outermostCircleRadius - _gap * circleNum) > 0) {
      canvas.drawCircle(
          center, _outermostCircleRadius - _gap * circleNum, borderPaint);
      circleNum += 1;
    }
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) {
    if (oldDelegate._outermostCircleRadius == _outermostCircleRadius) {
      return false;
    }
    return true;
  }
}