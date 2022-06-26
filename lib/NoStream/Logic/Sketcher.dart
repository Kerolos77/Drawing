import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawn_line.dart';

class Sketcher extends CustomPainter {
  Path path;

  Paint pain;

  Sketcher(this.path, this.pain);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, pain);
  }

  @override
  bool shouldRepaint(Sketcher delegate) {
    return true;
  }
}
