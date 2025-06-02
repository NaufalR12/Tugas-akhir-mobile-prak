import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/riwayat_controller.dart';
import '../controller/auth_controller.dart';
import '../models/riwayat.dart';

class RiwayatView extends StatelessWidget {
  final RiwayatController riwayatController = Get.find<RiwayatController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Cek status login
    if (!authController.isLoggedIn.value) {
      // Redirect ke halaman login jika belum login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
        Get.snackbar(
          'Akses Ditolak',
          'Silahkan login terlebih dahulu untuk melihat riwayat pelacakan',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xFFE0F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Riwayat Pelacakan',
          style: TextStyle(
            color: Color(0xFF00C3D4),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF00C3D4)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: Color(0xFF00C3D4)),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: Text('Hapus Semua Riwayat'),
                  content: Text(
                      'Apakah Anda yakin ingin menghapus semua riwayat pelacakan?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await riwayatController.deleteAllRiwayat();
                        Get.back();
                      },
                      child: Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (riwayatController.riwayatList.isEmpty) {
          return Center(
            child: Text(
              'Belum ada riwayat pelacakan',
              style: TextStyle(
                  color: Color(0xFF00C3D4), fontWeight: FontWeight.bold),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemCount: riwayatController.riwayatList.length,
          itemBuilder: (context, index) {
            final riwayat = riwayatController.riwayatList[index];
            return Dismissible(
              key: Key(riwayat.id.toString()),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 24),
                child: Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                riwayatController.deleteRiwayat(riwayat.id!);
              },
              child: Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF00C3D4).withOpacity(0.15),
                    child: Icon(Icons.local_shipping, color: Color(0xFF00C3D4)),
                  ),
                  title: Text(
                    'No. Resi: ${riwayat.noResi}',
                    style: TextStyle(
                      color: Color(0xFF00C3D4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text('Kurir: ${riwayat.kurir}',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('Status: ${riwayat.status}',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('Tanggal: ${_formatDate(riwayat.tanggal)}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
