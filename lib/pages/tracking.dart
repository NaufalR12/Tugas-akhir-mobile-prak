import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoShipp/controller/tracking_controller.dart';
import 'package:GoShipp/models/receipt.dart';
import 'package:GoShipp/pages/dashboard.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:GoShipp/widget/custom_bottom_bar.dart';
import 'package:GoShipp/controller/riwayat_controller.dart';
import 'package:GoShipp/controller/auth_controller.dart';

class Tracking2 extends StatefulWidget {
  final String receipt;
  final String jk;
  final String svg;
  const Tracking2(
      {super.key, required this.receipt, required this.jk, required this.svg});

  @override
  State<Tracking2> createState() => _Tracking2State();
}

class _Tracking2State extends State<Tracking2> {
  final controller = Get.put(TrackingController());
  late Future<Receipt> futureReceipt;
  final riwayatController = Get.find<RiwayatController>();
  bool _redirected = false;

  @override
  void initState() {
    super.initState();
    futureReceipt = controller.fetchData(widget.receipt, widget.jk);
    if (!Get.find<AuthController>().sudahLogin.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _redirected = true;
        });
        Get.offAllNamed('/login');
        Get.snackbar(
          'Akses Ditolak',
          'Silahkan login terlebih dahulu untuk melihat riwayat pelacakan',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_redirected) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    bool _isSukses = true;
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 202, 236),
          title: Text(
            "Lacak Paket",
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
                () => Dashboard(),
                transition: Transition.fade,
                duration: Duration(seconds: 1),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<Receipt>(
                future: futureReceipt,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: width * 0.03),
                        Container(
                          margin: EdgeInsets.only(bottom: width * 0.01),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 5, 78, 94)),
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                          width: width * 0.25,
                          height: width * 0.25,
                          child: widget.svg.isNotEmpty
                              ? SvgPicture.asset(widget.svg)
                              : Icon(Icons.image_not_supported,
                                  size: 48, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${snapshot.data!.data!.summary!.service}",
                          style: GoogleFonts.roboto(
                            color: Color.fromARGB(102, 14, 7, 1),
                            fontSize: height * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: width * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.copy,
                                size: width * 0.03,
                                color: Colors.black.withAlpha(128)),
                            SizedBox(width: width * 0.008),
                            Text(
                              "${snapshot.data!.data!.summary!.awb}",
                              style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 246, 142, 37),
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Terjadi Kesalahan',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => Get.offAll(
                              () => Tracking2(
                                receipt: widget.receipt,
                                jk: widget.jk,
                                svg: widget.svg,
                              ),
                              transition: Transition.fade,
                              duration: Duration(seconds: 1),
                            ),
                            icon: Icon(Icons.refresh),
                            label: Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 2, 148, 46),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              Divider(thickness: 5, color: Colors.black.withAlpha(25)),
              FutureBuilder<Receipt>(
                future: futureReceipt,
                builder: (context, snapshot) => Container(
                  margin: EdgeInsets.all(width * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var title in [
                            "Kota Asal",
                            "Status",
                            "Kota Tujuan"
                          ])
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.roboto(
                                  color: Color.fromARGB(255, 5, 78, 94),
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.hasData
                                  ? (snapshot.data!.data!.detail?.origin ==
                                              "" ||
                                          snapshot.data!.data!.detail?.origin ==
                                              null
                                      ? "Tidak diketahui"
                                      : snapshot.data!.data!.detail?.origin ??
                                          "Tidak diketahui")
                                  : "Tidak diketahui",
                              style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 246, 142, 37),
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.hasData
                                  ? (snapshot.data!.data!.summary!.status
                                              ?.isEmpty ??
                                          true
                                      ? "Sedang di Proses"
                                      : snapshot.data!.data!.summary!.status ??
                                          "")
                                  : "",
                              style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 246, 142, 37),
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.hasData
                                  ? (snapshot.data!.data!.detail?.destination ==
                                              "" ||
                                          snapshot.data!.data!.detail
                                                  ?.destination ==
                                              null
                                      ? "Tidak diketahui"
                                      : snapshot.data!.data!.detail
                                              ?.destination ??
                                          "Tidak diketahui")
                                  : "Tidak diketahui",
                              style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 246, 142, 37),
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (snapshot.hasError)
                        Center(
                            child: Text("${snapshot.error}",
                                textAlign: TextAlign.center)),
                      if (!snapshot.hasData && !snapshot.hasError)
                        Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 5, color: Colors.black.withAlpha(25)),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.07,
                  right: width * 0.03,
                  top: width * 0.03,
                  bottom: width * 0.03,
                ),
                child: Text(
                  "Status Paket",
                  style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 5, 78, 94),
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height * 0.5,
                child: FutureBuilder<Receipt>(
                  future: futureReceipt,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.data!.history!.length,
                        itemBuilder: (context, index) => TimelineTile(
                          indicatorStyle: IndicatorStyle(
                            indicator: Icon(
                              index == 0
                                  ? CupertinoIcons.checkmark_alt_circle
                                  : CupertinoIcons.circle,
                              color: index == 0
                                  ? Color.fromARGB(255, 246, 142, 37)
                                  : Color.fromARGB(255, 5, 78, 94),
                            ),
                            drawGap: true,
                          ),
                          afterLineStyle:
                              LineStyle(color: Color.fromARGB(255, 5, 78, 94)),
                          beforeLineStyle:
                              LineStyle(color: Color.fromARGB(255, 5, 78, 94)),
                          alignment: TimelineAlign.manual,
                          lineXY: 0.2,
                          endChild: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * 0.05),
                              border: Border.all(
                                color: index == 0
                                    ? Color.fromARGB(255, 246, 142, 37)
                                    : Color.fromARGB(255, 5, 78, 94),
                              ),
                            ),
                            margin: EdgeInsets.all(width * 0.03),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: ListTile(
                              title: Text(
                                '${snapshot.data!.data!.history![index].desc}',
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.roboto(
                                  fontSize: height * 0.017,
                                  fontWeight: FontWeight.bold,
                                  color: index == 0
                                      ? Color.fromARGB(255, 246, 142, 37)
                                      : Color.fromARGB(255, 5, 78, 94),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data!.data!.history![index].date}',
                                    style: GoogleFonts.roboto(
                                        fontSize: height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                          'WITA: ${konversiZona(snapshot.data!.data!.history![index].date ?? '', 8)}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700])),
                                      SizedBox(width: 12),
                                      Text(
                                          'WIT: ${konversiZona(snapshot.data!.data!.history![index].date ?? '', 9)}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700])),
                                      SizedBox(width: 12),
                                      Text(
                                          'London: ${konversiZona(snapshot.data!.data!.history![index].date ?? '', 0)}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
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
                              onTap: () => Get.offAll(
                                () => Tracking2(
                                    receipt: widget.receipt,
                                    jk: widget.jk,
                                    svg: widget.svg),
                                transition: Transition.fade,
                                duration: Duration(seconds: 1),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar(activeIndex: 3),
      ),
    );
  }
}

String konversiZona(String waktu, int offset) {
  try {
    // Cek format waktu, handle jika ada '/' atau '-'
    String formatted = waktu.replaceAll('/', '-');
    // Ambil bagian tanggal dan jam
    final regex = RegExp(r'(\d{4}-\d{2}-\d{2})[ T](\d{2}:\d{2})');
    final match = regex.firstMatch(formatted);
    if (match == null) return '-';
    final dateStr = match.group(1)!;
    final timeStr = match.group(2)!;
    final dt = DateTime.parse('$dateStr $timeStr').toUtc();
    final jam = dt.add(Duration(hours: offset));
    return '${jam.hour.toString().padLeft(2, '0')}:${jam.minute.toString().padLeft(2, '0')}';
  } catch (_) {
    return '-';
  }
}
