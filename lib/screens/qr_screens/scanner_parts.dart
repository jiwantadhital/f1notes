//error
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;
    print(error);
    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      case MobileScannerErrorCode.controllerDisposed:
        errorMessage = 'S';
        break;
      default:
        errorMessage = 'Another application is using the camera, Please restart the app';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class OverlayWithRectangleClipping extends StatefulWidget {
  @override
  _OverlayWithRectangleClippingState createState() =>
      _OverlayWithRectangleClippingState();
}

class _OverlayWithRectangleClippingState
    extends State<OverlayWithRectangleClipping>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: RectanglePainter(_controller.value),
          );
        },
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final double animationValue;

  RectanglePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final innerRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.5),
      width: size.width * 0.75,
      height: size.height * 0.4,
    );
    final innerRRect = RRect.fromRectAndRadius(innerRect, Radius.circular(5));

    // Draw the overlay with the rectangle clipped out
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(outerRect),
        Path()
          ..addRRect(innerRRect)
          ..close(),
      ),
      paint,
    );

    // Draw blue borders on the four corners
    final borderPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final cornerLength = 20.0;

    // Top-left corner
    canvas.drawLine(
      Offset(innerRect.left, innerRect.top),
      Offset(innerRect.left + cornerLength, innerRect.top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(innerRect.left, innerRect.top),
      Offset(innerRect.left, innerRect.top + cornerLength),
      borderPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(innerRect.right, innerRect.top),
      Offset(innerRect.right - cornerLength, innerRect.top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(innerRect.right, innerRect.top),
      Offset(innerRect.right, innerRect.top + cornerLength),
      borderPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(innerRect.left, innerRect.bottom),
      Offset(innerRect.left + cornerLength, innerRect.bottom),
      borderPaint,
    );
    canvas.drawLine(
      Offset(innerRect.left, innerRect.bottom),
      Offset(innerRect.left, innerRect.bottom - cornerLength),
      borderPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(innerRect.right, innerRect.bottom),
      Offset(innerRect.right - cornerLength, innerRect.bottom),
      borderPaint,
    );
    canvas.drawLine(
      Offset(innerRect.right, innerRect.bottom),
      Offset(innerRect.right, innerRect.bottom - cornerLength),
      borderPaint,
    );

    // Draw the moving line
    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final lineY = innerRect.top + animationValue * innerRect.height;
    canvas.drawLine(
      Offset(innerRect.left, lineY),
      Offset(innerRect.right, lineY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
