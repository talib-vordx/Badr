import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';



class DynamicProgressScreen extends StatefulWidget {
  @override
  _DynamicProgressScreenState createState() => _DynamicProgressScreenState();
}

class _DynamicProgressScreenState extends State<DynamicProgressScreen> {
  double _progress = 0.0; // Initial progress value

  // Function to increment progress
  void _incrementProgress() {
    setState(() {
      _progress = (_progress + 0.1).clamp(0.0, 1.0); // Increment progress and clamp to [0.0, 1.0]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Neon Progress Circle with dynamic progress
        NeonProgressCircle(progress: _progress),

        SizedBox(height: 20),

        // Button to increment progress
        ElevatedButton(
          onPressed: _incrementProgress,
          child: Text('Increase Progress'),
        ),
      ],
    );
  }
}

class NeonProgressCircle extends StatelessWidget {
  final double progress; // Accepting dynamic progress as a parameter

  // Constructor to receive dynamic progress
  NeonProgressCircle({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom neon glow around the arc (using custom painter)
          CustomPaint(
            size: Size(210, 210),
            painter: NeonArcPainter(progress),
          ),
          // Circular Progress Indicator with white arc
          CircularPercentIndicator(
            radius: 110.0,
            lineWidth: 5.0, // Customize stroke width
            percent: progress,
            progressColor: Colors.white, // Progress arc is white
            backgroundColor: Colors.grey.withOpacity(0.2),
            animation: true,
            animateFromLastPercent: true,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Center text is white
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter to draw the neon glow around the progress arc
class NeonArcPainter extends CustomPainter {
  final double progress;
  NeonArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..color = Colors.transparent;

    // Draw the glowing arc behind the circular progress indicator
    for (double i = 0; i < 3; i++) {
      paint.color = _getNeonColor(progress, i).withOpacity(0.2 + i * 0.2);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 + i * 5.0);
      canvas.drawArc(
        Offset(0, 0) & size,
        -1.5708, // Start angle (top)
        2 * 3.14159 * progress, // Sweep angle based on progress
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  // Function to get the neon glow color based on progress
  Color _getNeonColor(double progress, double layerIndex) {
    // Change colors based on the layer index
    if (progress <= 0.3) {
      // Red to Blue transition
      return Color.lerp(Color(0xFFFFAA00), Color(0xFF3448FF), progress / 0.3)!;
    } else if (progress <= 0.6) {
      // Blue to White transition
      return Color.lerp(Color(0xFF3448FF), Color(0xFFFFFFFF), (progress - 0.3) / 0.3)!;
    } else {
      // White to Green transition
      return Color.lerp(Color(0xFFFFFFFF), Color(0xFF00FF00), (progress - 0.6) / 0.4)!;
    }
  }
}
