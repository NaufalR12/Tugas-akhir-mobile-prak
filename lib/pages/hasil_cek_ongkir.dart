import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoShipp/controller/ongkir_controller.dart';
import 'package:GoShipp/models/api.dart';
import 'package:GoShipp/models/ongkir.dart';
import 'package:GoShipp/pages/cekOngkir.dart';
import 'package:GoShipp/pages/dashboard.dart';
import 'package:GoShipp/pages/pengaturan.dart';
import 'package:GoShipp/widget/custom_bottom_bar.dart';

class HasilCekOngkir extends StatefulWidget {
  String kotaAsal;
  String kotaTujuan;
  String totalPaket;
  String jk;
  String namaSVG;

  HasilCekOngkir({
    super.key,
    required this.jk,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.totalPaket,
    required this.namaSVG,
  });

  @override
  _HasilCekOngkirState createState() => _HasilCekOngkirState();
}

class _HasilCekOngkirState extends State<HasilCekOngkir> {
  final controllerOngkir = Get.put(OngkirController());
  late Future<Ongkir> futureOngkir;
  @override
  void initState() {
    super.initState();
    futureOngkir = controllerOngkir.getData(
        key, widget.kotaAsal, widget.kotaTujuan, widget.totalPaket, widget.jk);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    bool _isSukses = true;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await Get.offAll(
            () => CekOngkir(),
            transition: Transition.fade,
            duration: Duration(seconds: 1),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 202, 236),
          title: Text(
            "Cek Ongkir Paket",
            style: GoogleFonts.roboto(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offAll(
                () => CekOngkir(),
                transition: Transition.fade,
                duration: Duration(seconds: 1),
              );
            },
          ),
        ),
        body: ListView(
          children: [
            FutureBuilder<Ongkir>(
              future: futureOngkir,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(width * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 5, 78, 94),
                                ),
                                borderRadius:
                                    BorderRadius.circular(width * 0.04),
                              ),
                              width: width * 0.4,
                              height: width * 0.2,
                              child: SvgPicture.asset(
                                widget.namaSVG == '' ? '' : widget.namaSVG,
                              ),
                            ),
                            SizedBox(
                              height: width * 0.01,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Kota Asal",
                                  style: GoogleFonts.roboto(
                                    color: Color.fromARGB(255, 5, 78, 94),
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.rajaongkir!.originDetails!
                                      .cityName!,
                                  style: GoogleFonts.roboto(
                                    color: Color.fromARGB(255, 246, 142, 37),
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Berat",
                                  style: GoogleFonts.roboto(
                                    color: Color.fromARGB(255, 5, 78, 94),
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.rajaongkir!.query!.weight!
                                          .toString() +
                                      " gr",
                                  style: GoogleFonts.roboto(
                                    color: Color.fromARGB(255, 246, 142, 37),
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Kota Tujuan",
                                  style: GoogleFonts.roboto(
                                    color: Color.fromARGB(255, 5, 78, 94),
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.rajaongkir!.destinationDetails!
                                      .cityName!,
                                  style: GoogleFonts.roboto(
                                    color: Color.fromARGB(255, 246, 142, 37),
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: SizedBox(
                      width: width,
                      height: width * 0.5,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: width,
                    height: width * 0.5,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            Divider(
              thickness: 5,
              color: Colors.black.withAlpha(25),
            ),
            Container(
                margin: EdgeInsets.only(
                  top: width * 0.03,
                ),
                height: height * 0.5,
                width: width,
                child: FutureBuilder<Ongkir>(
                  future: futureOngkir,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot
                            .data!.rajaongkir!.results![0].costs!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                Radius.circular(width * 0.05),
                              ),
                              border: Border.all(
                                color: Color.fromARGB(255, 5, 78, 94),
                                width: width * 0.005,
                              ),
                            ),
                            margin: EdgeInsets.only(
                              top: width * 0.05,
                              left: width * 0.07,
                              right: width * 0.07,
                            ),
                            child: ListTile(
                              style: ListTileStyle.list,
                              title: Text(
                                "${snapshot.data!.rajaongkir!.results![0].costs![index].service}",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.02,
                                  color: Color.fromARGB(255, 5, 78, 94),
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data!.rajaongkir!.results![0].costs![index].description}",
                                style: GoogleFonts.roboto(
                                  color: Colors.black.withAlpha(128),
                                ),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Rp. ${snapshot.data!.rajaongkir!.results![0].costs![index].cost![0].value}",
                                    style: GoogleFonts.roboto(
                                      fontSize: height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 246, 142, 37),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${snapshot.data!.rajaongkir!.results![0].costs![index].cost![0].etd} Hari",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black.withAlpha(128),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: SizedBox(
                          width: width,
                          height: width * 0.5,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(20),
                                child: Text(
                                  '${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  width: width * 2,
                                  height: height / 18,
                                  margin: EdgeInsets.only(
                                    top: width * 0.03,
                                    left: width * 0.35,
                                    right: width * 0.35,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(255, 2, 148, 46)),
                                  child: Center(
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                          fontSize: height * 0.02,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                onTap: () => {
                                  Get.offAll(
                                    () => HasilCekOngkir(
                                      jk: widget.jk,
                                      kotaAsal: widget.kotaAsal,
                                      kotaTujuan: widget.kotaTujuan,
                                      totalPaket: widget.totalPaket,
                                      namaSVG: widget.namaSVG,
                                    ),
                                    transition: Transition.fade,
                                    duration: Duration(seconds: 1),
                                  )
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ))
          ],
        ),
        bottomNavigationBar: CustomBottomBar(activeIndex: 1),
      ),
    );
  }
}
