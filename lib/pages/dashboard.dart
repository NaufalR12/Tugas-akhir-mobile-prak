import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:GoShipp/controller/tracking_controller.dart';
import 'package:GoShipp/controller/riwayat_controller.dart';
import 'package:GoShipp/helper/sql_helper.dart';
import 'package:GoShipp/models/dummy_data_ikon.dart';
import 'package:GoShipp/pages/cekOngkir.dart';
import 'package:GoShipp/pages/pengaturan.dart';
import 'package:GoShipp/pages/riwayat_view.dart';
import 'package:GoShipp/pages/tracking.dart';
import 'package:GoShipp/widget/custom_bottom_bar.dart';
import '../main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final trackController = Get.put(TrackingController());
  final riwayatController = Get.find<RiwayatController>();
  Position? _currentPosition;
  static double _minHeight = 0, _maxHeight = 500;
  Offset _offset = Offset(0, _minHeight);
  bool _isOpen = false;
  int selectedCard = -1;
  String _jkPilih = '';
  String? _currentAddress;

  void gagal() {
    Get.snackbar(
      "Pencarian Anda tidak ditemukan",
      "Silahkan isi semua kolom terlebih dahulu",
      icon: Icon(Icons.block_outlined, color: Colors.red),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      colorText: Colors.red,
      duration: Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  void _deleteRiwayat(int id) async {
    await riwayatController.hapusRiwayat(id);
  }

  void _showEkspedisiPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Pilih Ekspedisi',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 16),
              ...dummySvg.asMap().entries.map((entry) {
                int idx = entry.key;
                var svg = entry.value;
                return ListTile(
                  leading: SvgPicture.asset(svg.images, width: 32, height: 32),
                  title: Text(svg.title),
                  onTap: () {
                    trackController.gantiSvg(svg.images, svg.title);
                    setState(() {
                      selectedCard = idx;
                      _jkPilih = svg.title;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      Logger().e(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}";
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB6E5F8), Color(0xFFFDFCFB)],
            stops: [0.0, 0.7],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.06, vertical: width * 0.08),
          children: [
            Text(
              "Lacak Paket Kamu!",
              style: GoogleFonts.roboto(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: width * 0.06),
            Container(
              padding: EdgeInsets.all(width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resi",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: trackController.receipt,
                    decoration: InputDecoration(
                      hintText: "Masukan Resi",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Ekspedisi",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _showEkspedisiPicker,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Obx(() => trackController.namaSVG.value == ''
                              ? Text("Pilih Ekspedisi",
                                  style: TextStyle(color: Colors.grey))
                              : Row(
                                  children: [
                                    SvgPicture.asset(
                                        trackController.namaSVG.value,
                                        width: 24,
                                        height: 24),
                                    SizedBox(width: 8),
                                    Text(trackController.namajs.value,
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                )),
                          Spacer(),
                          Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
                        if (trackController.receipt.text.isEmpty) {
                          gagal();
                        } else if (trackController.namajs.value.isEmpty) {
                          Get.snackbar(
                            "Pilih Ekspedisi",
                            "Silakan pilih ekspedisi terlebih dahulu",
                            backgroundColor: Colors.red.withOpacity(0.1),
                            colorText: Colors.red,
                            duration: Duration(seconds: 3),
                          );
                        } else {
                          String svgPath = '';
                          final ekspedisi =
                              trackController.namajs.value.toLowerCase();
                          String kurirValue = '';
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
                          if (svgPath.isEmpty) {
                            svgPath = 'assets/logo/default.svg';
                            kurirValue = ekspedisi;
                          }
                          Get.toNamed('/tracking2', arguments: {
                            'nomorResi': trackController.receipt.text,
                            'kurir': kurirValue,
                            'svg': svgPath,
                          });
                        }
                      },
                      child: Text(
                        "Cari",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width * 0.06),
            Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width * 0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Riwayat Pelacakan",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => RiwayatView()),
                        child: Text(
                          "Lihat Semua >",
                          style: GoogleFonts.roboto(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Obx(() {
                    final daftarRiwayat = riwayatController.daftarRiwayat;
                    if (daftarRiwayat.isEmpty) {
                      return Center(
                        child: Text(
                          "Belum ada riwayat pelacakan",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          daftarRiwayat.length > 3 ? 3 : daftarRiwayat.length,
                      itemBuilder: (_, index) {
                        final riwayat = daftarRiwayat[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(riwayat.nomorResi,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '${riwayat.kurir} - ${riwayat.status}',
                            style: GoogleFonts.roboto(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[300]),
                            onPressed: () => _deleteRiwayat(riwayat.id!),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(activeIndex: 0),
    );
  }
}
