import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import '../controller/riwayat_controller.dart';
import '../widget/custom_bottom_bar.dart';
import 'login_view.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:GoShipp/pages/tracking.dart';

class RiwayatView extends StatefulWidget {
  const RiwayatView({super.key});

  @override
  _RiwayatViewState createState() => _RiwayatViewState();
}

class _RiwayatViewState extends State<RiwayatView> {
  final AuthController authController = Get.find<AuthController>();
  final RiwayatController riwayatController = Get.find<RiwayatController>();
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _orientasi = 'Potrait';
  String _arahGyro = 'Diam';
  late final StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
    // Izinkan mode landscape dan portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        if (event.y > 1.0) {
          _arahGyro = 'Kanan';
        } else if (event.y < -1.0) {
          _arahGyro = 'Kiri';
        } else if (event.x > 1.0) {
          _arahGyro = 'Atas';
        } else if (event.x < -1.0) {
          _arahGyro = 'Bawah';
        } else {
          _arahGyro = 'Diam';
        }
      });
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    // Kembalikan orientasi ke default
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cek status login
    if (!authController.sudahLogin.value) {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        title: Text(
          'Riwayat Pelacakan',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nomor resi atau ekspedisi...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Mode orientasi: $_orientasi'),
                SizedBox(width: 16),
                Text('Arah perangkat: $_arahGyro'),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final allRiwayat = riwayatController.daftarRiwayat;
              final filteredRiwayat = allRiwayat.where((riwayat) {
                return riwayat.nomorResi.toLowerCase().contains(_searchText) ||
                    riwayat.kurir.toLowerCase().contains(_searchText);
              }).toList();
              if (filteredRiwayat.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada riwayat pelacakan',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                itemCount: filteredRiwayat.length,
                itemBuilder: (context, index) {
                  final riwayat = filteredRiwayat[index];
                  return Dismissible(
                    key: Key(riwayat.id.toString()),
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 24),
                      child: Icon(Icons.delete,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          size: 28),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      riwayatController.hapusRiwayat(riwayat.id!);
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Theme.of(context).cardColor,
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.15),
                          child: Icon(Icons.local_shipping,
                              color: Theme.of(context).primaryColor),
                        ),
                        title: Text(
                          riwayat.nomorResi,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${riwayat.kurir}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              riwayat.tanggal,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Text(
                          riwayat.status,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () {
                          // Cari svg sesuai ekspedisi
                          String svgPath = '';
                          String kurirValue = '';
                          final ekspedisi = riwayat.kurir.toLowerCase();
                          if (ekspedisi.contains('jne')) {
                            svgPath = 'assets/logo/jne.svg';
                            kurirValue = 'jne';
                          } else if (ekspedisi.contains('j&t')) {
                            svgPath = 'assets/logo/jnt.svg';
                            kurirValue = 'jnt';
                          } else if (ekspedisi.contains('sicepat')) {
                            svgPath = 'assets/logo/sicepat.svg';
                            kurirValue = 'sicepat';
                          } else if (ekspedisi.contains('pos')) {
                            svgPath = 'assets/logo/pos.svg';
                            kurirValue = 'pos';
                          } else if (ekspedisi.contains('spx') ||
                              ekspedisi.contains('shopee')) {
                            svgPath = 'assets/logo/shopee.svg';
                            kurirValue = 'spx';
                          } else if (ekspedisi.contains('anteraja')) {
                            svgPath = 'assets/logo/anteraja.svg';
                            kurirValue = 'anteraja';
                          } else if (ekspedisi.contains('wahana')) {
                            svgPath = 'assets/logo/wahana.svg';
                            kurirValue = 'wahana';
                          } else if (ekspedisi.contains('ninja')) {
                            svgPath = 'assets/logo/ninja.svg';
                            kurirValue = 'ninja';
                          }
                          if (svgPath.isEmpty)
                            svgPath = 'assets/logo/default.svg';
                          Get.to(() => Tracking2(
                                receipt: riwayat.nomorResi,
                                jk: riwayat.kurir,
                                svg: svgPath,
                              ));
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(activeIndex: 1),
    );
  }
}
