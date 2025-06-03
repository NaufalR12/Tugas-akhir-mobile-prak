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
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      colorText: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
      duration: Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  void _deleteRiwayat(int id) async {
    await riwayatController.deleteRiwayat(id);
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
    String? _iconjk;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/dashboard_bg4.jpg'),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            ),
            child: Container(
              padding: EdgeInsets.only(
                  top: width * 0.05, right: width * 0.05, left: width * 0.05),
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      "LACAK PAKET",
                      style: GoogleFonts.roboto(
                        fontSize: height * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        wordSpacing: 5,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Center(
                    child: Text(
                      "Lokasi Anda",
                      style: GoogleFonts.roboto(
                        fontSize: height * 0.02,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  if (_currentPosition != null && _currentAddress != null)
                    Center(
                      child: Text(
                        _currentAddress!,
                        style: GoogleFonts.roboto(
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  SizedBox(height: height * 0.04),
                  Center(
                    child: Text(
                      "Masukkan No. Resi Anda",
                      style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor,
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(width * 0.05),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      width: width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: width * 0.05),
                          Icon(Icons.search,
                              color: Theme.of(context).primaryColor),
                          SizedBox(
                            width: width * 0.6,
                            height: height * 0.05,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              style: GoogleFonts.roboto(
                                color: Theme.of(context).primaryColor,
                              ),
                              controller: trackController.receipt,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: "Masukkan nomor resi disini",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withAlpha(128),
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  Center(
                    child: Text(
                      "Pilih Jasa Kirim",
                      style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor,
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(width * 0.05),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      width: width * 0.6,
                      height: height * 0.05,
                      child: GestureDetector(
                        onTap: _handleClick,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: width * 0.05),
                            Icon(Icons.search,
                                color: Theme.of(context).primaryColor),
                            SizedBox(
                              width: width * 0.35,
                              child: Center(
                                child: Obx(
                                  () => trackController.namaSVG.value == ''
                                      ? SizedBox()
                                      : SvgPicture.asset(
                                          trackController.namaSVG.value,
                                          width: width * 0.06,
                                          height: width * 0.06,
                                        ),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  Center(
                    child: SizedBox(
                      width: width * 0.3,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Theme.of(context).cardColor),
                            ),
                          ),
                          elevation: WidgetStateProperty.all(2),
                        ),
                        onPressed: () {
                          if (trackController.receipt.text.isEmpty) {
                            gagal();
                          } else {
                            Get.to(
                              () => Tracking2(
                                receipt: trackController.receipt.text,
                                jk: trackController.namajs.value,
                                svg: trackController.namaSVG.value,
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Cari",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    padding: EdgeInsets.all(width * 0.05),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      borderRadius: new BorderRadius.all(
                        Radius.circular(width * 0.05),
                      ),
                      color: Theme.of(context).cardColor.withOpacity(0.9),
                    ),
                    width: width,
                    height: width * 0.8,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8)),
                                ),
                              ),
                              child: Text(
                                "Riwayat Pelacakan",
                                style: GoogleFonts.roboto(
                                  color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color ??
                                      Colors.black,
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => RiwayatView());
                              },
                              child: Text(
                                "Lihat Semua >",
                                style: GoogleFonts.roboto(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                  fontSize: height * 0.015,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: width * 0.05,
                        ),
                        SizedBox(
                          height: width * 0.5,
                          width: width,
                          child: Obx(() {
                            final riwayatList = riwayatController.riwayatList;
                            if (riwayatList.isEmpty) {
                              return SizedBox(
                                height: height * 0.2,
                                child: Center(
                                  child: Text(
                                    "Data kosong",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: riwayatList.length,
                              itemBuilder: (_, index) {
                                final riwayat = riwayatList[index];
                                return GestureDetector(
                                  onTap: () => Get.to(
                                    () => Tracking2(
                                      receipt: riwayat.noResi,
                                      jk: riwayat.kurir,
                                      svg:
                                          '', // Jika ingin menampilkan ikon, sesuaikan field-nya
                                    ),
                                  ),
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(bottom: width * 0.03),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          height: width * 0.15,
                                          decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(width * 0.04),
                                              bottomLeft:
                                                  Radius.circular(width * 0.04),
                                            ),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .cardColor),
                                            color: Theme.of(context).cardColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: width * 0.03),
                                              Text(
                                                "${index + 1}",
                                                style: GoogleFonts.roboto(
                                                  color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color ??
                                                      Colors.black,
                                                  fontSize: height * 0.018,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // Jika ingin menampilkan ikon SVG, tambahkan di sini
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.copy,
                                                        size: width * 0.03,
                                                        color: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color
                                                                ?.withAlpha(
                                                                    128) ??
                                                            Colors.black
                                                                .withAlpha(128),
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.008),
                                                      SizedBox(
                                                        width: width * 0.2,
                                                        child: Text(
                                                          riwayat.noResi,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize:
                                                                height * 0.018,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.2,
                                                    child: Text(
                                                      riwayat.kurir,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color ??
                                                            Colors.black,
                                                        fontSize:
                                                            height * 0.018,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: width * 0.03),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: width * 0.1,
                                            height: width * 0.15,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                topRight: Radius.circular(
                                                    width * 0.04),
                                                bottomRight: Radius.circular(
                                                    width * 0.04),
                                              ),
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.2),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                _deleteRiwayat(riwayat.id!);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color:
                                                    Theme.of(context).cardColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              _offset = Offset(0, _offset.dy - details.delta.dy);
              if (_offset.dy < _DashboardState._minHeight) {
                _offset = Offset(0, _DashboardState._minHeight);
                _isOpen = false;
              } else if (_offset.dy > _DashboardState._maxHeight) {
                _offset = Offset(0, _DashboardState._maxHeight);
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
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  // shrinkWrap: true,
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
                      itemCount: dummySvg.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.5),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final svg = dummySvg[index];
                        return GestureDetector(
                          onTap: () {
                            trackController.gantiSvg(svg.images, svg.title);
                            setState(() {
                              selectedCard = index;
                              _jkPilih = svg.title;
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
                                    width: selectedCard == index ? 2 : 1,
                                    color: selectedCard == index
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2)
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
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8),
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
      bottomNavigationBar: CustomBottomBar(activeIndex: 0),
    );
  }

  void _handleClick() {
    FocusScope.of(context).unfocus();
    _isOpen = !_isOpen;
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (_isOpen) {
        double value = _offset.dy + 100;
        _offset = Offset(0, value);
        if (_offset.dy > _maxHeight) {
          _offset = Offset(0, _maxHeight);
          timer.cancel();
        }
      } else {
        double value = _offset.dy - 100;
        _offset = Offset(0, value);
        if (_offset.dy < _minHeight) {
          _offset = Offset(0, _minHeight);
          timer.cancel();
        }
      }
      setState(() {});
    });
  }
}
