import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/riwayat_controller.dart';
import '../model/riwayat.dart';

class RiwayatView extends StatelessWidget {
  final RiwayatController riwayatController = Get.put(RiwayatController());

  @override
  Widget build(BuildContext context) {
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
