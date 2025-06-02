import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/riwayat.dart';
import 'auth_controller.dart';

class RiwayatController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AuthController _authController = Get.find<AuthController>();
  final RxList<Riwayat> riwayatList = <Riwayat>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRiwayat();
  }

  Future<void> loadRiwayat() async {
    final user = _authController.currentUser.value;
    if (user != null) {
      final riwayat = await _dbHelper.getRiwayatByUserId(user.id!);
      riwayatList.value = riwayat;
    }
  }

  Future<void> addRiwayat(String noResi, String kurir, String status) async {
    final user = _authController.currentUser.value;
    if (user != null) {
      final riwayat = Riwayat(
        userId: user.id!,
        noResi: noResi,
        kurir: kurir,
        status: status,
        tanggal: DateTime.now().toIso8601String(),
      );
      await _dbHelper.createRiwayat(riwayat);
      await loadRiwayat();
    }
  }

  Future<void> deleteRiwayat(int id) async {
    await _dbHelper.deleteRiwayat(id);
    await loadRiwayat();
  }

  Future<void> deleteAllRiwayat() async {
    final user = _authController.currentUser.value;
    if (user != null) {
      await _dbHelper.deleteAllRiwayatByUserId(user.id!);
      await loadRiwayat();
    }
  }
}
