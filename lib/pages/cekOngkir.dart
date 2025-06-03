import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoShipp/constant/constantVariabel.dart';
import 'package:GoShipp/controller/ongkir_controller.dart';
import 'package:GoShipp/models/api.dart';
import 'package:GoShipp/models/dummy_data_ikon.dart';
import 'package:GoShipp/models/kota.dart';
import 'package:GoShipp/models/ongkir.dart';
import 'package:GoShipp/pages/dashboard.dart';
import 'package:GoShipp/pages/hasil_cek_ongkir.dart';
import 'package:GoShipp/pages/pengaturan.dart';
import 'package:GoShipp/widget/custom_bottom_bar.dart';
import '../main.dart';

class CekOngkir extends StatefulWidget {
  const CekOngkir({super.key});

  @override
  _CekOngkirState createState() => _CekOngkirState();
}

class _CekOngkirState extends State<CekOngkir> {
  final controllerOngkir = Get.put(OngkirController());
  late Future<Ongkir> futureOngkir;
  var kota_asal, kota_tujuan, berat, kurir, cityName, cityTujuan;
  static double _minHeight = 0, _maxHeight = 300;
  Offset _offset = Offset(0, _minHeight);
  bool _isOpen = false;
  int selectedCard = -1;
  String _jkpilih = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await Get.offAll(
            () => Dashboard(),
            transition: Transition.fade,
            duration: Duration(seconds: 1),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Blue circle background at top left
            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                SizedBox(height: 24),
                Center(
                  child: Text(
                    'Cek Ongkir ke Kota Tujuanmu!',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color ??
                          Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Lebih Mudah Bersama GoShipp',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kota Asal
                      Text('Kota Asal',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  Colors.black)),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownSearch<Kota>(
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Pilih Kota Asal',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                          popupProps: PopupProps.menu(showSearchBox: true),
                          itemAsString: (item) =>
                              "${item.type} ${item.cityName}",
                          onChanged: (value) {
                            setState(() {
                              kota_asal = value?.cityId;
                              cityName = value?.cityName;
                            });
                          },
                          asyncItems: (text) async {
                            final ioc = new HttpClient();
                            ioc.badCertificateCallback =
                                (X509Certificate cert, String host, int port) =>
                                    true;
                            final http = new IOClient(ioc);
                            var response = await http.get(Uri.parse(
                                "https://api.rajaongkir.com/starter/city?key=$key"));
                            List allKota = (jsonDecode(response.body)
                                    as Map<String, dynamic>)['rajaongkir']
                                ['results'];
                            var dataKota = Kota.fromJsonList(allKota);
                            return dataKota;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      // Total Berat Paket
                      Text('Total Berat Paket',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  Colors.black)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  berat = text;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Masukan Berat',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('gr',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color ??
                                      Colors.black)),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Kota Tujuan
                      Text('Kota Tujuan',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  Colors.black)),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownSearch<Kota>(
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Pilih Kota Tujuan',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                          popupProps: PopupProps.menu(showSearchBox: true),
                          itemAsString: (item) =>
                              "${item.type} ${item.cityName}",
                          onChanged: (value) {
                            setState(() {
                              kota_tujuan = value?.cityId;
                              cityTujuan = value?.cityName;
                            });
                          },
                          asyncItems: (text) async {
                            final ioc = new HttpClient();
                            ioc.badCertificateCallback =
                                (X509Certificate cert, String host, int port) =>
                                    true;
                            final http = new IOClient(ioc);
                            var response = await http.get(Uri.parse(
                                "https://api.rajaongkir.com/starter/city?key=$key"));
                            List allKota = (jsonDecode(response.body)
                                    as Map<String, dynamic>)['rajaongkir']
                                ['results'];
                            var dataKota = Kota.fromJsonList(allKota);
                            return dataKota;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      // Jasa Kirim
                      Text('Jasa Kirim',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  Colors.black)),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: _handleClick,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Obx(() => Text(
                                        controllerOngkir.namaJasa.value == ''
                                            ? 'Pilih Jasa Kirim'
                                            : controllerOngkir.namaJasa.value,
                                        style: GoogleFonts.roboto(
                                          color:
                                              controllerOngkir.namaJasa.value ==
                                                      ''
                                                  ? Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color ??
                                                      Colors.grey
                                                  : Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color ??
                                                      Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color ??
                                      Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Cari Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).textTheme.bodyLarge?.color ??
                                    Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            if (kota_asal == null ||
                                kota_tujuan == null ||
                                berat == "" ||
                                controllerOngkir.namaJasa.value == "") {
                              Get.snackbar(
                                "Pencarian Anda tidak ditemukan",
                                "Silahkan isi semua kolom terlebih dahulu",
                                icon: Icon(Icons.block_outlined,
                                    color: Theme.of(context).primaryColor),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: 20,
                                margin: EdgeInsets.all(15),
                                colorText: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color ??
                                    Colors.black,
                                duration: Duration(seconds: 4),
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            } else {
                              Get.offAll(
                                () => HasilCekOngkir(
                                  jk: controllerOngkir.namaJasa.value
                                      .toLowerCase(),
                                  kotaAsal: kota_asal,
                                  kotaTujuan: kota_tujuan,
                                  totalPaket: berat,
                                  namaSVG: controllerOngkir.namaSVG.value,
                                ),
                                transition: Transition.fade,
                                duration: Duration(seconds: 1),
                              );
                            }
                          },
                          child: Text(
                            'Cari',
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
              ],
            ),
            GestureDetector(
              onPanUpdate: (details) {
                _offset = Offset(0, _offset.dy - details.delta.dy);
                if (_offset.dy < _CekOngkirState._minHeight) {
                  _offset = Offset(0, _CekOngkirState._minHeight);
                  _isOpen = false;
                } else if (_offset.dy > _CekOngkirState._maxHeight) {
                  _offset = Offset(0, _CekOngkirState._maxHeight);
                  _isOpen = true;
                } else {
                  _isOpen = false;
                }
                setState(() {});
              },
              child: AnimatedContainer(
                duration: Duration.zero,
                curve: Curves.easeOut,
                height: _offset.dy,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.grey.withAlpha(128),
                        spreadRadius: 5,
                        blurRadius: 10)
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: _handleClick,
                          icon: Icon(Icons.close),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: dummyJasa.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.5),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final svg = dummyJasa[index];
                          return GestureDetector(
                            onTap: () {
                              controllerOngkir.gantiSvg(svg.images, svg.title);
                              setState(() {
                                selectedCard = index;
                                _jkpilih = svg.title;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: selectedCard == index ? 3 : 1,
                                      color: selectedCard == index
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color ??
                                              Colors.black,
                                    ),
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(width * 0.05),
                                    ),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  height: width * 0.2,
                                  width: width * 0.2,
                                  child: SvgPicture.asset(
                                    svg.images,
                                    width: width * 0.1,
                                    height: width * 0.1,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      svg.title,
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        wordSpacing: 5,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(activeIndex: 1),
      ),
    );
  }

  void _handleClick() {
    _isOpen = !_isOpen;
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (_isOpen) {
        double value = _offset.dy +
            50; // we increment the height of the Container by 10 every 5ms
        _offset = Offset(0, value);
        if (_offset.dy > _maxHeight) {
          _offset =
              Offset(0, _maxHeight); // makes sure it does't go above maxHeight
          timer.cancel();
        }
      } else {
        double value = _offset.dy - 50; // we decrement the height by 10 here
        _offset = Offset(0, value);
        if (_offset.dy < _minHeight) {
          _offset = Offset(
              0, _minHeight); // makes sure it doesn't go beyond minHeight
          timer.cancel();
        }
      }
      setState(() {});
    });
  }
}
