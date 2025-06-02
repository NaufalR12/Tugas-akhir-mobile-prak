// ignore_for_file: must_be_immutable

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
// import 'package:paketku/widget/lainnya/rating_widget.dart';

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
      backgroundColor: Color.fromARGB(255, 223, 223, 223),
      resizeToAvoidBottomInset: true,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 55, 202, 236),
          child: Icon(Icons.home),
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
            height: width * 0.57,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                bottomLeft: Radius.circular(width * 0.1),
                bottomRight: Radius.circular(width * 0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.2,
                  height: width * 0.25,
                  child: Image.asset('assets/icon/icon.png'),
                ),
                Text(
                  'PaketKU',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.06,
                    color: Color.fromARGB(255, 246, 142, 37),
                  ),
                ),
                Text(
                  "Developer: Yoga Dev.",
                  style: GoogleFonts.roboto(
                    fontSize: height * 0.025,
                    color: Color.fromARGB(255, 4, 120, 122),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: width * 0.1,
          ),
          Container(
            padding: EdgeInsets.only(
              top: width * 0.05,
              left: width * 0.07,
              right: width * 0.07,
              bottom: width * 0.05,
            ),
            height: width * 0.7,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(width * 0.1),
                topRight: Radius.circular(width * 0.1),
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: width * 0.02),
                    leading: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                      size: width * 0.06,
                    ),
                    title: Text(
                      'Bersihkan History',
                      style: GoogleFonts.roboto(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 4, 120, 122),
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
                                // Tambahkan fungsi untuk menghapus history
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
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Obx(() => ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: width * 0.02),
                        leading: Icon(
                          themeController.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: themeController.isDarkMode
                              ? Colors.amber
                              : Colors.grey,
                          size: width * 0.06,
                        ),
                        title: Text(
                          themeController.isDarkMode
                              ? 'Mode Terang'
                              : 'Mode Gelap',
                          style: GoogleFonts.roboto(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 4, 120, 122),
                          ),
                        ),
                        onTap: () => themeController.toggleTheme(),
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: width * 0.02),
                    leading: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: width * 0.06,
                    ),
                    title: Text(
                      'Profil',
                      style: GoogleFonts.roboto(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 4, 120, 122),
                      ),
                    ),
                    onTap: () => Get.to(() => ProfilView()),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: width * 0.02),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: width * 0.06,
                    ),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.roboto(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 4, 120, 122),
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
                      ),
                      Text(
                        'Cek Ongkir',
                        style: TextStyle(),
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
                        color: Color.fromARGB(255, 246, 142, 37),
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 246, 142, 37),
                      ),
                      Text(
                        'Pengaturan',
                        style: GoogleFonts.roboto(
                          color: Color.fromARGB(255, 246, 142, 37),
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
