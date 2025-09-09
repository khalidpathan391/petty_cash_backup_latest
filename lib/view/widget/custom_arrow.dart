import 'package:flutter/material.dart';

class CustomArrow extends StatelessWidget {
  final double bodyHeight;
  final double bodyWidth;
  final double arrowHeadSize;
  final double rotationAngle; // Angle in radians
  final Color arrowColor;

  const CustomArrow({
    Key? key,
    this.bodyHeight = 100, // Height of the arrow body
    this.bodyWidth = 10, // Width of the arrow body
    this.arrowHeadSize = 20, // Size of the arrowhead (triangle)
    this.rotationAngle = 0.0, // Default angle (0 radians means no rotation)
    this.arrowColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: rotationAngle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arrow Body
            Container(
              height: bodyHeight,
              width: bodyWidth,
              color: arrowColor, // Set arrow body color
            ),
            // Arrowhead (triangle)
            Transform.rotate(
              angle: 1.5708 * 2,
              child: CustomPaint(
                size: Size(arrowHeadSize, arrowHeadSize),
                painter: TrianglePainter(arrowColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color arrowColor;

  TrianglePainter(this.arrowColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = arrowColor; // Set arrowhead color

    final path = Path()
      ..moveTo(size.width / 2, 0) // Top of the triangle
      ..lineTo(0, size.height) // Bottom-left corner
      ..lineTo(size.width, size.height) // Bottom-right corner
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
