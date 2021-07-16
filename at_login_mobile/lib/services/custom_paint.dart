import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.8;

    var path = Path();

    path.lineTo(size.width * 0.10, 0);
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.10);
    canvas.drawPath(path, paint);

    path.moveTo(size.width, 0);
    path.lineTo(size.width * 0.90, 0);
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.10);
    canvas.drawPath(path, paint);

    var path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, size.height * 0.90);
    path1.moveTo(0, size.height);
    path1.lineTo(size.width * 0.10, size.height);

    canvas.drawPath(path1, paint);

    path1.moveTo(size.width, size.height);
    path1.lineTo(size.width, size.height * 0.90);
    path1.moveTo(size.width, size.height);
    path1.lineTo(size.width * 0.90, size.height);

    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
