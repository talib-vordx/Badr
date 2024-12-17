import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DynamicThicknessNeonGauge extends StatelessWidget {
  final double progress; // Progress (0 to 100)
  final double size; // Size of the circle
  final Color glowColorStart; // Start color of the glow
  final Color glowColorEnd; // End color of the glow

  DynamicThicknessNeonGauge({
    required this.progress,
    required this.size,
    required this.glowColorStart,
    required this.glowColorEnd,
  });

  // Function to determine the glow color dynamically based on progress
  Color getGlowColor(double percentage) {
    if (percentage <= 33) {
      return glowColorStart; // First glow color range (1% to 33%)
    } else if (percentage <= 66) {
      return glowColorEnd; // Second glow color range (34% to 66%)
    } else {
      return glowColorStart; // Third glow color range (67% to 100%)
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = getGlowColor(progress);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Neon Glow Effect
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: glowColor.withOpacity(0.3),
                  blurRadius: 80,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
          // Circular Gauge
          SfRadialGauge(
            axes: [
              RadialAxis(
                startAngle: 270,
                endAngle: 270 + 360,
                minimum: 0,
                maximum: 100,
                showTicks: true,
                showLabels: false,
                axisLineStyle: AxisLineStyle(
                  thickness: 20,
                  color: Colors.grey[900],
                ),
                pointers: [
                  RangePointer(
                    value: progress,
                    width: 20,
                    color: Colors.yellow,
                    cornerStyle: CornerStyle.bothCurve,
                    gradient: SweepGradient(
                      colors: [
                        glowColor.withOpacity(0.3),
                        glowColor,
                        glowColor.withOpacity(0.3),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ],
                annotations: [
                  GaugeAnnotation(
                    positionFactor: 0.1,
                    angle: 90,
                    widget: Text(
                      "${progress.toInt()}%",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Overlay for Dynamic Thickness
          CustomPaint(
            size: Size(size + 210, size + 210), // Adjust for the outer ring
            painter: DynamicArcPainter(progress, glowColor, size),
          ),
        ],
      ),
    );
  }
}

class DynamicArcPainter extends CustomPainter {
  final double progress; // Progress in percentage (0 to 100)
  final Color glowColor; // Neon glow color
  final double size; // Size of the circle

  DynamicArcPainter(this.progress, this.glowColor, this.size);

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = canvasSize.width / 2;

    // Paint for the progress arc (with glow)
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Define the start and end angles (progress from -90 degrees)
    const double startAngle = -90; // Start at 12 o'clock
    double sweepAngle = progress * 3.6; // Sweep angle based on progress (0-360)

    // Draw the dynamic progress arc
    final path = Path();
    for (double angle = 0; angle <= sweepAngle; angle++) {
      final theta = (startAngle + angle) * (pi / 180); // Convert angle to radians

      // Dynamic thickness logic: the width increases from 0 to 50% progress (thinner to thicker),
      // then decreases from 50% to 100% (thicker to thinner).
      final normalizedProgress = angle / sweepAngle;
      final dynamicStrokeWidth = _getDynamicWidth(normalizedProgress);

      // Set the stroke width dynamically
      progressPaint.strokeWidth = dynamicStrokeWidth;

      // Calculate the coordinates on the circular arc path
      final x = center.dx + radius * cos(theta);
      final y = center.dy + radius * sin(theta);

      if (angle == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Apply neon glow effect using a gradient
    progressPaint.shader = RadialGradient(
      colors: [
        glowColor.withOpacity(0.3),
        glowColor,
        glowColor.withOpacity(0.3),
      ],
      stops: [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw the progress arc
    canvas.drawPath(path, progressPaint);
  }

  // Dynamic width function based on progress
  double _getDynamicWidth(double progress) {
    if (progress < 0.5) {
      // From 0 to 50% progress (thinner to thicker)
      return 5 + 15 * progress; // Starts at 5, increases to 15
    } else {
      // From 50% to 100% progress (thicker to thinner)
      return 15 - 15 * (progress - 0.5); // Decreases from 15 to 5
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
