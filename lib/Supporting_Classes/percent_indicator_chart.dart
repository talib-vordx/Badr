import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NeonGlowProgressArc extends StatelessWidget {
  final double progress = 0.8; // Example: 80%

  // Determine the glow color based on the percentage
  Color getGlowColor(double percentage) {
    if (percentage <= 0.33) {
      return Colors.redAccent; // 1% to 33%
    } else if (percentage <= 0.66) {
      return Colors.yellowAccent; // 34% to 66%
    } else {
      return Colors.greenAccent; // 67% to 100%
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = getGlowColor(progress);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Neon glow around the progress arc
          CustomPaint(
            size: Size(160, 150), // Match CircularPercentIndicator size
            painter: GlowPainter(
              progress: progress,
              glowColor: glowColor,
            ),
          ),
          // CircularPercentIndicator for progress
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 5.0,
            percent: progress,
            animation: true,
            animationDuration: 1200,
            header: SizedBox(height: 50,
              child: Text(
                "Custom Percentage Indicator",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            center: Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            backgroundColor: Colors.grey,
            progressColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}

class GlowPainter extends CustomPainter {
  final double progress;
  final Color glowColor;

  GlowPainter({required this.progress, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Define the arc angle based on progress
    final startAngle = -90.0; // Start at the top of the circle
    final sweepAngle = 360.0 * progress;

    // Paint for the neon glow
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    // Draw the glow arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 10),
      startAngle * (3.141592653589793 / 180.0), // Convert to radians
      sweepAngle * (3.141592653589793 / 180.0), // Convert to radians
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
