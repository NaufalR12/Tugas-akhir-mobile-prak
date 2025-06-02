import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paketku/helper/sql_helper.dart';
import 'package:paketku/models/api.dart';
import 'package:paketku/models/receipt.dart';
import 'package:paketku/controller/riwayat_controller.dart';
import 'package:paketku/controller/auth_controller.dart';

class TrackingController extends GetxController {
  String alamat = "";
  TextEditingController receipt = TextEditingController();
  String jKirim = "";
  List<dynamic> data = []; //edited line
  Map<String, dynamic> map = {};
  RxString namaSVG = "".obs;
  RxString namajs = "".obs;
  final RiwayatController _riwayatController = Get.put(RiwayatController());
  final AuthController _authController = Get.find<AuthController>();

  void gantiSvg(
    String namaSVG,
    String namajs,
  ) {
    this.namaSVG.value = namaSVG;
    this.namajs.value = namajs;
    update();
  }

  Future<Receipt> fetchData(receipt, jk) async {
    try {
      if (jk == 'Shopee') {
        jKirim = "spx";
      } else if (jk == 'SAP') {
        jKirim = "sap";
      } else if (jk == 'ID express') {
        jKirim = "ide";
      } else if (jk == 'J&T') {
        jKirim = "jnt";
      } else {
        jKirim = jk;
      }
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      final response = await http
          .get(Uri.parse(
              "https://api.binderbyte.com/v1/track?api_key=$apiKey&courier=$jKirim&awb=" +
                  receipt))
          .timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          throw 'Gagal mengambil data, mohon ulangi kembali';
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        alamat = responseData['data']['detail']['destination'];

        // Simpan ke riwayat jika user sudah login
        if (_authController.isLoggedIn.value) {
          final status = responseData['data']['summary']['status'] ?? 'Unknown';
          await _riwayatController.addRiwayat(receipt, jKirim, status);
        }

        // Simpan ke SQLHelper untuk kompatibilitas
        await SQLHelper.createItem(
          receipt,
          alamat,
          namaSVG.toString(),
          jKirim,
        );

        return Receipt.fromJson(responseData);
      } else {
        throw 'Gagal mengambil data, cek kembali inputan anda';
      }
    } on SocketException {
      throw 'Mohon Cek internet anda';
    } on TimeoutException {
      throw 'Waktu habis. Silahkan Reload halaman';
    }
  }
}
