import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/svg.dart';

class DynamicStrokeProgressCircle extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final double minStrokeWidth; // Minimum stroke width
  final double maxStrokeWidth; // Maximum stroke width
  final double radius; // Radius of the circle
  final double centerTextSize; // Dynamic text size

  // Dynamic properties for neon effect
  final double neonStrokeWidth; // Dynamic neon stroke width
  final double neonOpacity; // Opacity of neon glow
  final double neonBlurRadius; // Blur mask radius for glow
  final String CircleMarked;

   DynamicStrokeProgressCircle({
    required this.progress,
    this.minStrokeWidth = 1.0,
    this.maxStrokeWidth = 6.0,
    this.radius = 60.0,
    this.centerTextSize = 24.0, // Default text size
    this.neonStrokeWidth = 6.0, // Default neon stroke width
    this.neonOpacity = 0.8, // Default opacity of the neon glow
    this.neonBlurRadius = 10.0,
    required this.CircleMarked, // Default blur for the glow
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // CustomPaint for the progress circle
        CustomPaint(
          size: Size(radius * 2, radius * 2),
          painter: ProgressCirclePainter(
            progress: progress,
            minStrokeWidth: minStrokeWidth,
            maxStrokeWidth: maxStrokeWidth,
            radius: radius,
            centerTextSize: centerTextSize,
            neonStrokeWidth: neonStrokeWidth,
            neonOpacity: neonOpacity,
            neonBlurRadius: neonBlurRadius,
          ),
        ),
        // Check icon, only visible when progress is complete
        if (progress >= 1.0)
          Transform.translate(
            offset: Offset(
              0, // Centered horizontally
              -radius, // Position icon at the top of the circle
            ),
            child:
            Container(
                color: Color(0xFF233144),
                height: 30,
                width: 30,
                child: Image.asset(CircleMarked)
            ),
            // SvgPicture.asset(
            //   CircleMarked,
            //   width: 24.0, // Adjust size to fit your circle design
            //   height: 24.0,
            //   fit: BoxFit.contain, // Ensures the SVG fits within its bounds
            //   colorFilter: null, // Ensure no color overlay unless needed
            //   alignment: Alignment.center,
            // ),
          ),
      ],
    );
  }
}


class ProgressCirclePainter extends CustomPainter {
  final double progress;
  final double minStrokeWidth;
  final double maxStrokeWidth;
  final double radius;
  final double centerTextSize;

  // Dynamic properties for neon effect
  final double neonStrokeWidth;
  final double neonOpacity;
  final double neonBlurRadius;

  ProgressCirclePainter({
    required this.progress,
    required this.minStrokeWidth,
    required this.maxStrokeWidth,
    required this.radius,
    required this.centerTextSize,
    required this.neonStrokeWidth,
    required this.neonOpacity,
    required this.neonBlurRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Existing circle drawing logic...
    // Paint for the background arc
    final Paint backgroundPaint = Paint()
      ..color = Color(0xFF374556) // Background arc color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Paint for the progress arc (normal, non-glowing arc)
    final Paint progressPaint = Paint()
      ..color = Colors.white // White for progress arc
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Paint for the neon glow effect on the progress arc
    final Paint neonGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, neonBlurRadius) // Dynamic blur effect
      ..color = Colors.transparent; // Transparent color since the glow comes from blur

    double startAngle = -pi / 2; // Start from the top (12 o'clock position)
    double sweepAngle = 2 * pi * progress; // Sweep angle based on progress

    // Draw the background arc with dynamic stroke width
    for (double angle = 0; angle < 2 * pi; angle += 0.01) {
      double normalizedProgress = (angle / (2 * pi));

      // Adjust stroke width for background
      double backgroundStrokeWidth;
      if (normalizedProgress <= 0.5) {
        backgroundStrokeWidth = minStrokeWidth +
            (maxStrokeWidth - minStrokeWidth) * normalizedProgress * 2;
      } else {
        backgroundStrokeWidth = maxStrokeWidth -
            (maxStrokeWidth - minStrokeWidth) * (normalizedProgress - 0.5) * 2;
      }

      backgroundPaint.strokeWidth = backgroundStrokeWidth;

      // Calculate positions for background segments
      double adjustedAngle = angle - pi / 2; // Align background arc to top position
      double x1 = radius + (radius - backgroundStrokeWidth / 2) * cos(adjustedAngle);
      double y1 = radius + (radius - backgroundStrokeWidth / 2) * sin(adjustedAngle);
      double x2 = radius + (radius - backgroundStrokeWidth / 2) * cos(adjustedAngle + 0.01);
      double y2 = radius + (radius - backgroundStrokeWidth / 2) * sin(adjustedAngle + 0.01);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), backgroundPaint);
    }

    // Draw the neon glow progress arc
    for (double angle = startAngle; angle < startAngle + sweepAngle; angle += 0.01) {
      double normalizedProgress = (angle + pi / 2) / (2 * pi);

      // Adjust stroke width for progress arc
      double progressStrokeWidth;
      if (normalizedProgress <= 0.5) {
        progressStrokeWidth = neonStrokeWidth * normalizedProgress * 2;
      } else {
        progressStrokeWidth = neonStrokeWidth * (1 - (normalizedProgress - 0.5) * 2);
      }

      neonGlowPaint.strokeWidth = progressStrokeWidth;

      // Select the neon glow color based on progress with adjusted opacity
      Color neonColor;
      if (progress <= 0.34) {
        neonColor = Color(0x80FFFFFF).withOpacity(neonOpacity); // Semi-transparent white neon glow for 0-33%
      } else if (progress <= 0.66) {
        neonColor = Color(0x803448FF).withOpacity(neonOpacity); // Semi-transparent blue neon glow for 34-66%
      } else {
        neonColor = Color(0xFFC48D33).withOpacity(neonOpacity); // Semi-transparent orange neon glow for 67-100%
      }

      neonGlowPaint.color = neonColor;

      // Calculate positions for progress segments
      double x1 = radius + (radius - progressStrokeWidth / 2) * cos(angle);
      double y1 = radius + (radius - progressStrokeWidth / 2) * sin(angle);
      double x2 = radius + (radius - progressStrokeWidth / 2) * cos(angle + 0.01);
      double y2 = radius + (radius - progressStrokeWidth / 2) * sin(angle + 0.01);

      // Draw the neon glow arc
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), neonGlowPaint);
    }

    // Draw the progress arc (non-glowing white arc)
    for (double angle = startAngle; angle < startAngle + sweepAngle; angle += 0.01) {
      double normalizedProgress = (angle + pi / 2) / (2 * pi);

      // Adjust stroke width for progress arc
      double progressStrokeWidth;
      if (normalizedProgress <= 0.5) {
        progressStrokeWidth = minStrokeWidth +
            (maxStrokeWidth - minStrokeWidth) * normalizedProgress * 2;
      } else {
        progressStrokeWidth = maxStrokeWidth -
            (maxStrokeWidth - minStrokeWidth) * (normalizedProgress - 0.5) * 2;
      }

      progressPaint.strokeWidth = progressStrokeWidth;

      // Calculate positions for progress segments
      double x1 = radius + (radius - progressStrokeWidth / 2) * cos(angle);
      double y1 = radius + (radius - progressStrokeWidth / 2) * sin(angle);
      double x2 = radius + (radius - progressStrokeWidth / 2) * cos(angle + 0.01);
      double y2 = radius + (radius - progressStrokeWidth / 2) * sin(angle + 0.01);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), progressPaint);
    }

    // Draw progress percentage in the center (optional)
    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: centerTextSize, // Dynamic text size
        fontWeight: FontWeight.bold,
      ),
      text: '${(progress * 100).toStringAsFixed(0)}%',
    );
    TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,

      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
