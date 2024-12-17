import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dynamicStrokeProgressCircle.dart';


class Second_card extends StatelessWidget {
  final String svgAsset; // Your SVG asset path
  final String title; // Your title
  final double progress; // Your progress value (0.0 to 1.0)

  const Second_card({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF203043),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SVG Icon
            SvgPicture.asset(
              svgAsset,
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8), // Adjusted to the default size
            // Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                overflow: TextOverflow.fade,
              ),
            ),
             Spacer(),

            // DualProgressCircularProgress widget with custom size
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: RepaintBoundary(
                child: DynamicStrokeProgressCircle(
                  progress: progress, // 75% progress
                  minStrokeWidth: 0.0, // Minimum stroke width
                  maxStrokeWidth: 4.0, // Maximum stroke width
                  radius: 27.0, // Radius of the circle
                 centerTextSize: 12,
                  neonStrokeWidth: 4.0, // Custom neon stroke width
                  neonOpacity: 0.6, // Neon opacity
                  neonBlurRadius: 3.0, // Blur for the glow
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // First-sub Progress Card
// Second_card(svgAsset: 'res/drop.svg', title: 'PRAYER OF WADU', progress: 0.42,),
//
// // Second-sub Progress Card
// Second_card(svgAsset: 'res/thirdcardmosque.svg', title: 'THE FIVE DAILY PRAYERS', progress: 0.75,),
//
// // Third-sub Progress Card
// Second_card(svgAsset: "res/MissedFredPrayer.svg", title: "MISSED FARD PRAYERS", progress: 0.25),
//
// // Fourth-sub Progress Card
// Second_card(svgAsset: "res/MosqueCardIcon.svg", title: "CONGREGATIONAL\nPRAYER IN Mosque", progress: 0.30),
//
// // fifth-sub Progress Card
// Second_card(svgAsset: "res/SunnahRawatibIcon.svg", title: "SUNNAH RAWATIB", progress: 0.70),
//
// // Sixth-sub Progress Card
// Second_card(svgAsset: "res/DuhaFrame.svg", title: "DUAH", progress: 0.36),