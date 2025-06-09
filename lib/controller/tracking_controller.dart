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
      final jkLower = jk.toLowerCase();
      print('Debug - Input kurir: $jkLower'); // Debug log

      if (jkLower.contains('shopee') || jkLower.contains('spx')) {
        kurir.value = "spx";
      } else if (jkLower.contains('sap')) {
        kurir.value = "sap";
      } else if (jkLower.contains('id express') || jkLower.contains('ide')) {
        kurir.value = "ide";
      } else if (jkLower.contains('j&t') || jkLower.contains('jnt')) {
        kurir.value = "jnt";
      } else if (jkLower.contains('jne')) {
        kurir.value = "jne";
      } else if (jkLower.contains('sicepat')) {
        kurir.value = "sicepat";
      } else if (jkLower.contains('pos')) {
        kurir.value = "pos";
      } else if (jkLower.contains('anteraja')) {
        kurir.value = "anteraja";
      } else if (jkLower.contains('wahana')) {
        kurir.value = "wahana";
      } else if (jkLower.contains('ninja')) {
        kurir.value = "ninja";
      } else {
        kurir.value = jkLower;
      }
      print('Debug - Mapped kurir value: ${kurir.value}'); // Debug log

      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);

      final url =
          "https://api.binderbyte.com/v1/track?api_key=$apiKey&courier=${kurir.value}&awb=$receipt";
      print('Debug - API URL: $url'); // Debug log

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          throw 'Gagal mengambil data, mohon ulangi kembali';
        },
      );

      print('Debug - Response status: ${response.statusCode}'); // Debug log
      print('Debug - Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Validasi response data
        if (responseData['status'] == false) {
          throw 'Error: ${responseData['message'] ?? "Unknown error"}';
        }

        if (responseData['data'] == null) {
          throw 'Data tidak ditemukan';
        }

        // Handle null/kosong pada detail kota
        final detail = responseData['data']['detail'];
        alamat = (detail['destination'] == null ||
                detail['destination'].toString().isEmpty)
            ? 'Tidak diketahui'
            : detail['destination'];

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
        final errorData = jsonDecode(response.body);
        throw 'Error ${response.statusCode}: ${errorData['message'] ?? "Unknown error"}';
      }
    } on SocketException {
      throw 'Mohon Cek internet anda';
    } on TimeoutException {
      throw 'Waktu habis. Silahkan Reload halaman';
    } on FormatException catch (e) {
      throw 'Format data tidak valid: $e';
    } catch (e) {
      print('Debug - Error caught: $e'); // Debug log
      throw 'Terjadi kesalahan: $e';
    }
  }
}
