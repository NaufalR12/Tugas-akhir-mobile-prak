import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paketku/constant/constantVariabel.dart';
import 'package:paketku/view/cekOngkir.dart';
import 'package:paketku/view/dashboard.dart';
import 'package:paketku/widget/lainnya/delete_widget.dart';
import '../controller/auth_controller.dart';
import 'login_view.dart';
import 'profil_view.dart';
import 'package:paketku/controller/theme_controller.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Color(0xFFE0F6FF),
      resizeToAvoidBottomInset: true,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          backgroundColor: Colors.grey,
          child: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Get.offAll(
              () => Dashboard(),
              transition: Transition.fadeIn,
              duration: Duration(seconds: 1),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.07),
            height: width * 0.8,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(width * 0.1),
                bottomRight: Radius.circular(width * 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.6,
                  height: width * 0.6,
                  child: Image.asset('assets/icon/icon.png'),
                ),
                SizedBox(height: width * 0.05),
              ],
            ),
          ),
          SizedBox(height: width * 0.1),
          Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(width * 0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: width * 0.02),
                    leading: Container(
                      padding: EdgeInsets.all(width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                        size: width * 0.06,
                      ),
                    ),
                    title: Text(
                      'Bersihkan History',
                      style: GoogleFonts.roboto(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00C3D4),
                      ),
                    ),
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Bersihkan History'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus semua riwayat?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Hapus',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Obx(() => ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: width * 0.02),
                        leading: Container(
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(
                            color: (themeController.isDarkMode
                                    ? Colors.amber
                                    : Colors.grey)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          child: Icon(
                            themeController.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: themeController.isDarkMode
                                ? Colors.amber
                                : Colors.grey,
                            size: width * 0.06,
                          ),
                        ),
                        title: Text(
                          themeController.isDarkMode
                              ? 'Mode Terang'
                              : 'Mode Gelap',
                          style: GoogleFonts.roboto(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C3D4),
                          ),
                        ),
                        onTap: () => themeController.toggleTheme(),
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: width * 0.02),
                    leading: Container(
                      padding: EdgeInsets.all(width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: width * 0.06,
                      ),
                    ),
                    title: Text(
                      'Profil',
                      style: GoogleFonts.roboto(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00C3D4),
                      ),
                    ),
                    onTap: () => Get.to(() => ProfilView()),
                  ),
                ),
                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: width * 0.02),
                    leading: Container(
                      padding: EdgeInsets.all(width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: width * 0.06,
                      ),
                    ),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.roboto(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00C3D4),
                      ),
                    ),
                    onTap: () async {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Logout'),
                          content: Text('Apakah Anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await authController.logout();
                                Get.offAll(() => LoginView());
                              },
                              child: Text('Ya',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  Get.offAll(
                    () => CekOngkir(),
                    transition: Transition.fadeIn,
                    duration: Duration(seconds: 1),
                  );
                },
                child: SizedBox(
                  width: width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.price_change_outlined,
                        color: Colors.grey,
                      ),
                      Text(
                        'Cek Ongkir',
                        style: GoogleFonts.roboto(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {},
                child: Container(
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF00C3D4),
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: Color(0xFF00C3D4),
                      ),
                      Text(
                        'Pengaturan',
                        style: GoogleFonts.roboto(
                          color: Color(0xFF00C3D4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
