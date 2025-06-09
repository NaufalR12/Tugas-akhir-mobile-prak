// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoShipp/pages/dashboard.dart';
import 'controller/auth_controller.dart';
import 'controller/theme_controller.dart';
import 'pages/login_view.dart';
import 'pages/onboarding_page.dart';
import 'package:GoShipp/controller/riwayat_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:GoShipp/controller/tracking_controller.dart';
import 'pages/riwayat_view.dart';
import 'pages/pengaturan.dart';
import 'package:GoShipp/pages/kesan_saran.dart';
import 'package:GoShipp/pages/tracking.dart';
import 'package:GoShipp/pages/konversi.dart';

// Variabel warna untuk mode terang (light) dan gelap (dark) agar konsisten di seluruh halaman.
const Color lightPrimaryColor = Color(0xFF00C3D4);
const Color lightScaffoldColor = Color(0xFFE0F6FF);
const Color lightCardColor = Colors.white;
const Color lightAppBarColor = Color(0xFF00C3D4);
const Color lightFABColor = Color(0xFF00C3D4);
const Color lightTextColor = Colors.black;

const Color darkPrimaryColor = Color(0xFF00C3D4);
const Color darkScaffoldColor = Color(0xFF121212);
const Color darkCardColor = Color(0xFF23272A);
const Color darkAppBarColor = Color(0xFF1F1F1F);
const Color darkFABColor = Color(0xFF23272A);
const Color darkTextColor = Colors.white;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'paketku.db');

  // Hapus database lama jika ada
  await deleteDatabase(path);

  // Inisialisasi controller
  Get.put(AuthController());
  Get.put(ThemeController());
  Get.put(TrackingController());
  Get.put(RiwayatController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'PaketKU',
          theme: ThemeData.light().copyWith(
            primaryColor: lightPrimaryColor,
            scaffoldBackgroundColor: lightScaffoldColor,
            appBarTheme: AppBarTheme(
              backgroundColor: lightAppBarColor,
              foregroundColor: Colors.white,
            ),
            cardColor: lightCardColor,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: lightFABColor,
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: lightTextColor, displayColor: lightTextColor),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: darkPrimaryColor,
            scaffoldBackgroundColor: darkScaffoldColor,
            appBarTheme: AppBarTheme(
              backgroundColor: darkAppBarColor,
              foregroundColor: Colors.white,
            ),
            cardColor: darkCardColor,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: darkFABColor,
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: darkTextColor, displayColor: darkTextColor),
          ),
          themeMode:
              themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Obx(() =>
              authController.sudahLogin.value ? Dashboard() : OnboardingPage()),
          getPages: [
            GetPage(name: '/riwayat', page: () => RiwayatView()),
            GetPage(name: '/pengaturan', page: () => Pengaturan()),
            GetPage(name: '/kesan_saran', page: () => HelpPage()),
            GetPage(
                name: '/tracking2',
                page: () {
                  final args = Get.arguments ?? {};
                  return Tracking2(
                    receipt: args['receipt'] ?? args['nomorResi'] ?? '',
                    jk: args['jk'] ?? args['kurir'] ?? '',
                    svg: args['svg'] ?? '',
                  );
                }),
            GetPage(name: '/konversi', page: () => KonversiPage()),
          ],
        ));
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
