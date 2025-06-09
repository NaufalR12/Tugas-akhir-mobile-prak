import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoShipp/constant/constantVariabel.dart';
import '../controller/auth_controller.dart';
import '../controller/riwayat_controller.dart';
import 'login_view.dart';

import 'package:GoShipp/controller/theme_controller.dart';
import 'package:GoShipp/widget/custom_bottom_bar.dart';
import 'package:GoShipp/pages/kesan_saran.dart';
import 'package:GoShipp/pages/konversi.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final RiwayatController riwayatController = Get.find<RiwayatController>();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
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
              color: Theme.of(context).cardColor,
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
                  child: Image.asset('assets/icon.png'),
                ),
                SizedBox(height: width * 0.05),
              ],
            ),
          ),
          SizedBox(height: width * 0.1),
          Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.05),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                  child: defaultMenuTile(
                    icon: Icons.delete_outline,
                    text: 'Bersihkan History',
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
                              onPressed: () async {
                                await riwayatController.deleteAllRiwayat();
                                Get.back();
                                Get.snackbar(
                                  'Sukses',
                                  'Semua riwayat telah dihapus',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  colorText: Colors.green,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.all(width * 0.05),
                                  borderRadius: width * 0.02,
                                );
                              },
                              child: Text('Hapus',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    iconColor: Colors.red,
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
                  child: defaultMenuTile(
                    icon: Icons.nightlight_round,
                    text: 'Mode Gelap',
                    onTap: () => themeController.toggleTheme(),
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
                  child: defaultMenuTile(
                    icon: Icons.location_on_outlined,
                    text: 'Cari Ekspedisi Terdekat',
                    onTap: () {
                      Get.toNamed('/map');
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
                  child: defaultMenuTile(
                    icon: Icons.edit_note,
                    text: 'Kesan dan Saran',
                    onTap: () {
                      Get.to(() => HelpPage());
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
                ),
                Container(
                  child: defaultMenuTile(
                    icon: Icons.logout,
                    text: 'Logout',
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
                                await authController.keluar();
                                Get.offAll(() => LoginView());
                              },
                              child: Text('Ya',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(activeIndex: 2),
    );
  }

  Widget defaultMenuTile({required IconData icon, required String text, required VoidCallback onTap, Color? iconColor}) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
      ),
      title: Text(text, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
      onTap: onTap,
      horizontalTitleGap: 12,
      minLeadingWidth: 0,
    );
  }
}
