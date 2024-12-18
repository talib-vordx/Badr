import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatefulWidget {
  @override
  _CircularProgressIndicatorWidgetState createState() => _CircularProgressIndicatorWidgetState();
}

class _CircularProgressIndicatorWidgetState extends State<CircularProgressIndicatorWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return SizedBox(
            height: 200,
            width: 200,
            child: CustomPaint(
              painter: CircularProgressPainter(
                progress: _animation.value,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;

  CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - paint.strokeWidth / 2;

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      arcRect,
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );

    // Adjust stroke width based on progress
    if (progress <= 0.5) {
      paint.strokeWidth = 10 + (progress * 20); // Thinner to thicker
    } else {
      paint.strokeWidth = 30 - ((progress - 0.5) * 20); // Thicker to thinner
    }

    // Neon glow effect
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawArc(
      arcRect,
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
