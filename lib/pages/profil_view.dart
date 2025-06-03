import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import '../database/database_helper.dart';
import 'login_view.dart';
import 'package:GoShipp/constant/constantVariabel.dart';
import 'package:GoShipp/widget/custom_bottom_bar.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = authController.currentUser.value;
    if (user != null) {
      namaLengkapController.text = user.namaLengkap ?? '';
      alamatController.text = user.alamat ?? '';
      noHpController.text = user.noHp ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profil',
          style: GoogleFonts.roboto(
            color: Color(0xFF00C3D4),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF00C3D4)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Color(0xFF00C3D4),
            ),
            onPressed: () async {
              if (isEditing) {
                try {
                  final success = await authController.updateProfile(
                    userId: authController.currentUser.value!.id!,
                    namaLengkap: namaLengkapController.text,
                    alamat: alamatController.text,
                    noHp: noHpController.text,
                  );
                  if (success) {
                    Get.snackbar(
                      'Sukses',
                      'Profil berhasil diperbarui',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green[100],
                      colorText: Colors.green[800],
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.all(width * 0.05),
                      borderRadius: width * 0.02,
                      icon: Icon(Icons.check_circle, color: Colors.green[800]),
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[800],
                    duration: Duration(seconds: 3),
                    margin: EdgeInsets.all(width * 0.05),
                    borderRadius: width * 0.02,
                    icon: Icon(Icons.error_outline, color: Colors.red[800]),
                  );
                }
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(width * 0.05),
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
              child: Obx(() {
                final user = authController.currentUser.value;
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(
                            color: Color(0xFF00C3D4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Color(0xFF00C3D4),
                            size: width * 0.06,
                          ),
                        ),
                        title: Text(
                          'Username',
                          style: GoogleFonts.roboto(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C3D4),
                          ),
                        ),
                        subtitle: Text(
                          user?.username ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: width * 0.035,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(
                            color: Color(0xFF00C3D4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          child: Icon(
                            Icons.email_outlined,
                            color: Color(0xFF00C3D4),
                            size: width * 0.06,
                          ),
                        ),
                        title: Text(
                          'Email',
                          style: GoogleFonts.roboto(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C3D4),
                          ),
                        ),
                        subtitle: Text(
                          user?.email ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: width * 0.035,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Lengkap',
                            style: GoogleFonts.roboto(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00C3D4),
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextField(
                            controller: namaLengkapController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide:
                                    BorderSide(color: Color(0xFF00C3D4)),
                              ),
                            ),
                            enabled: isEditing,
                          ),
                          SizedBox(height: width * 0.05),
                          Text(
                            'Alamat',
                            style: GoogleFonts.roboto(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00C3D4),
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextField(
                            controller: alamatController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide:
                                    BorderSide(color: Color(0xFF00C3D4)),
                              ),
                            ),
                            maxLines: 3,
                            enabled: isEditing,
                          ),
                          SizedBox(height: width * 0.05),
                          Text(
                            'Nomor HP',
                            style: GoogleFonts.roboto(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00C3D4),
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextField(
                            controller: noHpController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                borderSide:
                                    BorderSide(color: Color(0xFF00C3D4)),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            enabled: isEditing,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: width * 0.05),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Hapus Akun'),
                      content: Text(
                          'Apakah Anda yakin ingin menghapus akun ini? Tindakan ini tidak dapat dibatalkan.'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              final userId =
                                  authController.currentUser.value?.id;
                              if (userId != null) {
                                await DatabaseHelper.instance
                                    .deleteUser(userId);
                                await authController.logout();
                                Get.offAll(() => LoginView());
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Gagal menghapus akun',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[800],
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.all(width * 0.05),
                                borderRadius: width * 0.02,
                                icon: Icon(Icons.error_outline,
                                    color: Colors.red[800]),
                              );
                            }
                          },
                          child: Text('Hapus',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  minimumSize: Size(double.infinity, width * 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Hapus Akun',
                  style: GoogleFonts.roboto(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(activeIndex: 3),
    );
  }
}
