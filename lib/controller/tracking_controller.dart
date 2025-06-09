import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:GoShipp/helper/sql_helper.dart';
import 'package:GoShipp/models/api.dart';
import 'package:GoShipp/models/receipt.dart';
import 'package:GoShipp/controller/riwayat_controller.dart';
import 'package:GoShipp/controller/auth_controller.dart';

class TrackingController extends GetxController {
  String alamat = "";
  final receipt = TextEditingController();
  final kurir = ''.obs;
  final svg = ''.obs;
  Future<Receipt>? futureReceipt;
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

  void cariResi() {
    if (receipt.text.isNotEmpty && kurir.value.isNotEmpty) {
      futureReceipt = fetchData(receipt.text, kurir.value);
      update();
    }
  }

  Future<Receipt> fetchData(String receipt, String jk) async {
    try {
      if (jk == 'Shopee') {
        kurir.value = "spx";
      } else if (jk == 'SAP') {
        kurir.value = "sap";
      } else if (jk == 'ID express') {
        kurir.value = "ide";
      } else if (jk == 'J&T') {
        kurir.value = "jnt";
      } else {
        kurir.value = jk;
      }
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      final response = await http
          .get(Uri.parse(
              "https://api.binderbyte.com/v1/track?api_key=$apiKey&courier=${kurir.value}&awb=" +
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
        if (_authController.sudahLogin.value) {
          final status = responseData['data']['summary']['status'] ?? 'Unknown';
          await _riwayatController.tambahRiwayat(receipt, kurir.value, status);
        }

        // Simpan ke SQLHelper untuk kompatibilitas
        await SQLHelper.createItem(
          receipt,
          alamat,
          namaSVG.toString(),
          kurir.value,
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
