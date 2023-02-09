import 'dart:math';

import 'package:flutter/material.dart';

class CirclePaint extends CustomPainter {
  final double value;

  CirclePaint(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2);

    canvas.drawArc(
        area, -pi / 2, 2 * pi * value, true, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
