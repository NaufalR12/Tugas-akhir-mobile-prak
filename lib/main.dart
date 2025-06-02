// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paketku/view/dashboard.dart';
import 'controller/auth_controller.dart';
import 'controller/theme_controller.dart';
import 'view/login_view.dart';
import 'view/onboarding_page.dart';
import 'package:paketku/controller/riwayat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());
  Get.put(RiwayatController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PaketKU',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      themeMode: ThemeMode.system,
      home: Obx(() =>
          authController.isLoggedIn.value ? Dashboard() : OnboardingPage()),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void startTimeout() {
    Timer(Duration(seconds: 2), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  void changeScreen() {
    Get.offAll(
      Dashboard(),
      transition: Transition.fadeIn,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/icon/icon.png'),
            ),
            Text(
              'PaketKU',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Color.fromARGB(255, 246, 142, 37),
              ),
            ),
            Text(
              'Developed by Yoga Dev.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Color.fromARGB(255, 5, 78, 94),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 246, 142, 37),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
