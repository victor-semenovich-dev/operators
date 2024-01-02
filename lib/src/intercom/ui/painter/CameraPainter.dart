import 'package:flutter/material.dart';

import '../../data/camera.dart';

class CameraPainter extends CustomPainter {
  final Camera camera;

  CameraPainter(this.camera);

  @override
  void paint(Canvas canvas, Size size) {
    if (!camera.isOk) {
      Paint linePaint = Paint();
      linePaint.color = Colors.black;
      linePaint.strokeWidth = 4;

      canvas.drawLine(Offset.zero, Offset(size.width, size.height), linePaint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldCamera = (oldDelegate as CameraPainter).camera;
    return camera.isOk != oldCamera.isOk;
  }
}
