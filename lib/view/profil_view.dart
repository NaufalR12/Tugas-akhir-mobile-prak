import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../database/database_helper.dart';
import 'login_view.dart';

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
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
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
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final user = authController.currentUser.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Username'),
                    subtitle: Text(user?.username ?? ''),
                  ),
                  ListTile(
                    title: Text('Email'),
                    subtitle: Text(user?.email ?? ''),
                  ),
                  TextField(
                    controller: namaLengkapController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    enabled: isEditing,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    enabled: isEditing,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: noHpController,
                    decoration: InputDecoration(
                      labelText: 'Nomor HP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    enabled: isEditing,
                  ),
                ],
              );
            }),
            SizedBox(height: 32),
            Center(
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
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Hapus Akun'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
