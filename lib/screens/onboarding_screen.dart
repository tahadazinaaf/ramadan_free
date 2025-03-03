import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'landing_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // Ensures RTL layout
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset("assets/splach_screen.jpg",
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                width: double.infinity,
                height: double.infinity),
            Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "هذا الموقع هو من تصميم \n طلبة نادي الالكترونيك \nبجامعة المسيلة وهو تطبيق\nيقوم بإظهار أماكن الإفطار\n لعابير السبيل في شهر\nرمضان الكريم\nلاتنسوهم من صالح دعائكم",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  SizedBox(height: 64),
                  SizedBox(
                    width: 265,
                    height: 64,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6938D3), //  #6938D3
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () => _completeOnboarding(context),
                      label: Text(
                        "ابدأ الآن",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
