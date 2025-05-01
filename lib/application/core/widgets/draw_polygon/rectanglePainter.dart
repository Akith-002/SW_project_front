import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/draw_polygon/drawPolygonDialog.dart';

class RectanglePainter extends CustomPainter {
  final Side selectedSide;

  RectanglePainter(this.selectedSide);

  @override
  void paint(Canvas canvas, Size size) {
    final paintSolid = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintDotted = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dashWidth = 5.0;
    final dashSpace = 4.0;

    void drawDottedLine(Offset p1, Offset p2) {
      final totalLength = (p2 - p1).distance;
      final direction = (p2 - p1) / totalLength;
      var currentLength = 0.0;

      while (currentLength < totalLength) {
        final start = p1 + direction * currentLength;
        final end =
            p1 + direction * (currentLength + dashWidth).clamp(0, totalLength);
        canvas.drawLine(start, end, paintDotted);
        currentLength += dashWidth + dashSpace;
      }
    }

    final topLeft = Offset(0, 0);
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    // Draw all sides
    if (selectedSide == Side.top) {
      canvas.drawLine(topLeft, topRight, paintSolid);
      drawDottedLine(topRight, bottomRight);
      drawDottedLine(bottomRight, bottomLeft);
      drawDottedLine(bottomLeft, topLeft);
    } else if (selectedSide == Side.right) {
      drawDottedLine(topLeft, topRight);
      canvas.drawLine(topRight, bottomRight, paintSolid);
      drawDottedLine(bottomRight, bottomLeft);
      drawDottedLine(bottomLeft, topLeft);
    } else if (selectedSide == Side.bottom) {
      drawDottedLine(topLeft, topRight);
      drawDottedLine(topRight, bottomRight);
      canvas.drawLine(bottomRight, bottomLeft, paintSolid);
      drawDottedLine(bottomLeft, topLeft);
    } else if (selectedSide == Side.left) {
      canvas.drawLine(topLeft, bottomLeft, paintSolid);
      drawDottedLine(topLeft, topRight);
      drawDottedLine(topRight, bottomRight);
      drawDottedLine(bottomRight, bottomLeft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
