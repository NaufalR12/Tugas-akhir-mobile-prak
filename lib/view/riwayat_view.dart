import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/riwayat_controller.dart';
import '../controller/auth_controller.dart';
import '../model/riwayat.dart';

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
      appBar: AppBar(
        title: Text('Riwayat Pelacakan'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
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
            child: Text('Belum ada riwayat pelacakan'),
          );
        }
        return ListView.builder(
          itemCount: riwayatController.riwayatList.length,
          itemBuilder: (context, index) {
            final riwayat = riwayatController.riwayatList[index];
            return Dismissible(
              key: Key(riwayat.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                riwayatController.deleteRiwayat(riwayat.id!);
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('No. Resi: ${riwayat.noResi}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kurir: ${riwayat.kurir}'),
                      Text('Status: ${riwayat.status}'),
                      Text('Tanggal: ${_formatDate(riwayat.tanggal)}'),
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
