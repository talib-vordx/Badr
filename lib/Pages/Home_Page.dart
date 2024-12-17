import 'package:badr_application/Supporting_Classes/percent_indicator_chart.dart';
import 'package:badr_application/Supporting_Classes/syncfusion_flutter_gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Supporting_Classes/customSecondRowCard.dart';
import '../Supporting_Classes/dynamicStrokeProgressCircle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPressed = false; // To track the long press state

  // Function to start increasing progress on long press
  void _startIncreasingProgress(BuildContext context) {
    if (!isPressed) return;

    context.read<ProgressProvider>().increaseProgress();

    // Continuously increase progress while button is pressed
    Future.delayed(Duration(milliseconds: 100), () {
      if (isPressed && context.read<ProgressProvider>().progress < 1.0) {
        _startIncreasingProgress(context);
      }
    });
  }

  // Function to start decreasing progress on long press
  void _startDecreasingProgress(BuildContext context) {
    if (!isPressed) return;

    context.read<ProgressProvider>().decreaseProgress();

    // Continuously decrease progress while button is pressed
    Future.delayed(Duration(milliseconds: 100), () {
      if (isPressed && context.read<ProgressProvider>().progress > 0.0) {
        _startDecreasingProgress(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081A2F),
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        centerTitle: true,
        title: Text(
          'PRAYER GOALS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Other widgets...
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("res/backgroundImg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SvgPicture.asset(
                  'res/image.svg',
                  height: 110.w,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 50.h,
                    minWidth: 100.w,
                    color: const Color(0xFF233144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset('res/Prayer-Goals-Icon.svg'),
                  ),
                  MaterialButton(
                    height: 50.h,
                    minWidth: 100.w,
                    color: const Color(0xFF233144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset('res/Quran-Icon.svg'),
                  ),
                  MaterialButton(
                    height: 50.h,
                    minWidth: 100.w,
                    color: const Color(0xFF233144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset('res/Fasting-Icon.svg'),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              //Six Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 50.h,
                    minWidth: 100.w,
                    color: const Color(0xFF233144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset('res/Dhikr-Icon.svg'),
                  ),
                  MaterialButton(
                    height: 50.h,
                    minWidth: 100.w,
                    color: const Color(0xFF233144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset('res/prayer.svg'),
                  ),
                  MaterialButton(
                    height: 50.h,
                    minWidth: 100.w,
                    color: const Color(0xFF233144),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset('res/Umra-Haj-Icon.svg'),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Progress Circle Card
              Selector<ProgressProvider, double>(
                selector: (context, provider) => provider.progress,
                builder: (context, progress, child) {
                  return Card(
                    elevation: 4,
                    color: Color(0xFF233144),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "10/28 days left",
                            style: TextStyle(color: Colors.white60, fontSize: 12.0),
                          ),
                          SizedBox(height: 20.0),
                          RepaintBoundary(
                            child: DynamicStrokeProgressCircle(
                              progress: progress,
                              minStrokeWidth: 1.0,
                              maxStrokeWidth: 7.0,
                              radius: 80.0,
                              centerTextSize: 28.0,
                              neonStrokeWidth: 9.0,
                              neonOpacity: 0.7,
                              neonBlurRadius: 6.0,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            "MASHA ALLAH, OUTSTANDING PROGRESS",
                            style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "After accounting for other influences, the achieved prayer goal has a +53% impact on your Ibadat goals and spiritual journey",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 14.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Decrease Progress Button with Long Press
                              GestureDetector(
                                onLongPressStart: (_) {
                                  setState(() {
                                    isPressed = true;
                                    _startDecreasingProgress(context);
                                  });
                                },
                                onLongPressEnd: (_) {
                                  setState(() {
                                    isPressed = false; // Stop when long press ends
                                  });
                                },
                                child: ElevatedButton(
                                  onPressed: context.read<ProgressProvider>().decreaseProgress,
                                  child: Text('-'),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              // Increase Progress Button with Long Press
                              GestureDetector(
                                onLongPressStart: (_) {
                                  setState(() {
                                    isPressed = true;
                                    _startIncreasingProgress(context);
                                  });
                                },
                                onLongPressEnd: (_) {
                                  setState(() {
                                    isPressed = false; // Stop when long press ends
                                  });
                                },
                                child: ElevatedButton(
                                  onPressed: context.read<ProgressProvider>().increaseProgress,
                                  child: Text('+'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              //

              // First-sub Progress Card
              Second_card(svgAsset: 'res/drop.svg', title: 'PRAYER OF WADU', progress: 0.0,),

              // Second-sub Progress Card
              Second_card(svgAsset: 'res/thirdcardmosque.svg', title: 'THE FIVE DAILY PRAYERS', progress: 0.0,),

              // Third-sub Progress Card
              Second_card(svgAsset: "res/MissedFredPrayer.svg", title: "MISSED FARD PRAYERS", progress: 0.0),

              // Fourth-sub Progress Card
              Second_card(svgAsset: "res/MosqueCardIcon.svg", title: "CONGREGATIONAL\nPRAYER IN Mosque", progress: 0.0),

              // fifth-sub Progress Card
              Second_card(svgAsset: "res/SunnahRawatibIcon.svg", title: "SUNNAH RAWATIB", progress: 0.0),

              // Sixth-sub Progress Card
              Second_card(svgAsset: "res/DuhaFrame.svg", title: "DUAH", progress: 0.0),


              NeonGlowProgressArc(),
              SizedBox(height: 20,),
              DynamicThicknessNeonGauge(progress: 70, size: 200, glowColorEnd: Colors.pink, glowColorStart: Colors.green,),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressProvider with ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void increaseProgress() {
    _progress += 0.01;
    if (_progress > 1.0) _progress = 1.0;
    notifyListeners();
  }

  void decreaseProgress() {
    _progress -= 0.01;
    if (_progress < 0.0) _progress = 0.0;
    notifyListeners();
  }
}
