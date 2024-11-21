import 'package:flutter/material.dart';

class CameraPainter extends CustomPainter {
  final bool showCross;

  CameraPainter({required this.showCross});

  @override
  void paint(Canvas canvas, Size size) {
    if (showCross) {
      Paint linePaint = Paint();
      linePaint.color = Colors.black;
      linePaint.strokeWidth = 4;

      canvas.drawLine(Offset.zero, Offset(size.width, size.height), linePaint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return showCross != (oldDelegate as CameraPainter).showCross;
  }
}
