import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:get/get.dart';
import 'package:GoShipp/models/ongkir.dart';

class OngkirController extends GetxController {
  RxString namaSVG = "".obs;
  RxString namaJasa = "".obs;

  void gantiSvg(String namaSVG, String namaJasa) {
    this.namaSVG.value = namaSVG;
    this.namaJasa.value = namaJasa;
    update();
  }

  Future<Ongkir> getData(key, kotaAsal, kotaTujuan, berat, kurir) async {
    try {
      Future.delayed(Duration(seconds: 3));
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      final response = await http.post(
        Uri.parse(
          "https://api.rajaongkir.com/starter/cost",
        ),
        body: {
          "key": key,
          "origin": kotaAsal,
          "destination": kotaTujuan,
          "weight": berat,
          "courier": kurir
        },
      ).timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          throw 'Gagal mengambil data, mohon ulangi kembali';
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Cek error dari API RajaOngkir
        if (data['rajaongkir'] == null ||
            data['rajaongkir']['status'] == null ||
            data['rajaongkir']['status']['code'] != 200) {
          throw data['rajaongkir'] != null &&
                  data['rajaongkir']['status'] != null
              ? data['rajaongkir']['status']['description'] ??
                  'Data ongkir tidak ditemukan'
              : 'Data ongkir tidak ditemukan';
        }
        if (data['rajaongkir']['results'] == null ||
            data['rajaongkir']['results'].isEmpty ||
            data['rajaongkir']['results'][0]['costs'] == null ||
            data['rajaongkir']['results'][0]['costs'].isEmpty) {
          throw 'Tidak ada data ongkir ditemukan untuk inputan tersebut.';
        }
        return Ongkir.fromJson(data);
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
