import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/riwayat.dart';
import 'auth_controller.dart';

class RiwayatController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthController _authController = Get.find<AuthController>();
  final RxList<Riwayat> daftarRiwayat = <Riwayat>[].obs;

  @override
  void onInit() {
    super.onInit();
    muatRiwayat();
  }

  Future<void> muatRiwayat() async {
    final pengguna = _authController.penggunaAktif.value;
    if (pengguna != null) {
      final riwayat = await _dbHelper.ambilRiwayat(pengguna.id!);
      daftarRiwayat.value = riwayat;
    }
  }

  Future<void> tambahRiwayat(
      String nomorResi, String kurir, String status) async {
    final pengguna = _authController.penggunaAktif.value;
    if (pengguna != null) {
      final riwayat = Riwayat(
        idPengguna: pengguna.id!,
        nomorResi: nomorResi,
        kurir: kurir,
        status: status,
        tanggal: DateTime.now().toIso8601String(),
      );
      await _dbHelper.tambahRiwayat(riwayat);
      await muatRiwayat();
    }
  }

  Future<void> hapusRiwayat(int id) async {
    await _dbHelper.hapusRiwayat(id);
    await muatRiwayat();
  }

  Future<void> deleteAllRiwayat() async {
    final pengguna = _authController.penggunaAktif.value;
    if (pengguna != null) {
      await _dbHelper.hapusSemuaRiwayat(pengguna.id!);
      await muatRiwayat();
    }
  }
}
