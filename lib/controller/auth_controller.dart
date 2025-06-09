import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcrypt/bcrypt.dart';
import '../database/database_helper.dart';
import '../models/user.dart';
import 'package:GoShipp/controller/riwayat_controller.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Rx<User?> penggunaAktif = Rx<User?>(null);
  final RxBool sudahLogin = false.obs;
  RxBool sandiTersembunyi = true.obs;
  final _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    cekStatusLogin();
  }

  Future<void> cekStatusLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final idPengguna = prefs.getInt('id_pengguna');
    _logger.d('ID Pengguna dari SharedPreferences: $idPengguna');
    if (idPengguna != null) {
      final pengguna = await _dbHelper.cariPengguna(idPengguna.toString());
      _logger.d('Pengguna ditemukan: ${pengguna?.namaPengguna}');
      if (pengguna != null) {
        penggunaAktif.value = pengguna;
        sudahLogin.value = true;
        Get.find<RiwayatController>().muatRiwayat();
      }
    }
  }

  Future<bool> daftar({
    required String namaPengguna,
    required String email,
    required String kataSandi,
    String? namaLengkap,
    String? alamat,
    String? nomorHp,
  }) async {
    try {
      _logger.d('Mencoba mendaftar: $namaPengguna');
      // Cek apakah nama pengguna atau email sudah ada
      final penggunaAda = await _dbHelper.cariPengguna(namaPengguna);
      final emailAda = await _dbHelper.cariEmail(email);

      if (penggunaAda != null) {
        _logger.w('Nama pengguna sudah digunakan: $namaPengguna');
        throw 'Nama pengguna sudah digunakan';
      }
      if (emailAda != null) {
        _logger.w('Email sudah digunakan: $email');
        throw 'Email sudah digunakan';
      }

      // Enkripsi kata sandi
      final kataSandiTerenkripsi = BCrypt.hashpw(kataSandi, BCrypt.gensalt());
      _logger.d('Kata sandi dienkripsi');

      // Buat pengguna baru
      final pengguna = User(
        namaPengguna: namaPengguna,
        email: email,
        kataSandi: kataSandiTerenkripsi,
        namaLengkap: namaLengkap,
        alamat: alamat,
        nomorHp: nomorHp,
      );

      final id = await _dbHelper.tambahPengguna(pengguna);
      _logger.i('Pengguna berhasil didaftarkan dengan ID: $id');
      return id > 0;
    } catch (e) {
      _logger.e('Error saat mendaftar: $e');
      rethrow;
    }
  }

  Future<bool> masuk(String usernameOrEmail, String kataSandi) async {
    try {
      _logger.d('Mencoba login dengan: $usernameOrEmail');
      User? pengguna;

      // Coba cari dengan username
      pengguna = await _dbHelper.cariPengguna(usernameOrEmail);
      pengguna ??= await _dbHelper.cariEmail(usernameOrEmail);

      if (pengguna == null) {
        _logger.w('Pengguna tidak ditemukan: $usernameOrEmail');
        throw 'Username atau email tidak ditemukan';
      }

      _logger.d('Pengguna ditemukan: ${pengguna.namaPengguna}');
      final kataSandiValid = BCrypt.checkpw(kataSandi, pengguna.kataSandi);
      if (!kataSandiValid) {
        _logger.w('Kata sandi salah untuk pengguna: ${pengguna.namaPengguna}');
        throw 'Kata sandi salah';
      }

      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id_pengguna', pengguna.id!);
      _logger.i('Login berhasil untuk pengguna: ${pengguna.namaPengguna}');

      penggunaAktif.value = pengguna;
      sudahLogin.value = true;
      Get.find<RiwayatController>().muatRiwayat();
      return true;
    } catch (e) {
      _logger.e('Error saat login: $e');
      rethrow;
    }
  }

  Future<void> keluar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_pengguna');
    penggunaAktif.value = null;
    sudahLogin.value = false;
    Get.find<RiwayatController>().muatRiwayat();
    _logger.i('Logout berhasil');
  }

  Future<bool> perbaruiProfil({
    required int idPengguna,
    String? namaLengkap,
    String? alamat,
    String? nomorHp,
  }) async {
    try {
      final pengguna = penggunaAktif.value;
      if (pengguna == null) throw 'Pengguna tidak ditemukan';

      final penggunaDiperbarui = User(
        id: idPengguna,
        namaPengguna: pengguna.namaPengguna,
        email: pengguna.email,
        kataSandi: pengguna.kataSandi,
        namaLengkap: namaLengkap ?? pengguna.namaLengkap,
        alamat: alamat ?? pengguna.alamat,
        nomorHp: nomorHp ?? pengguna.nomorHp,
      );

      final hasil = await _dbHelper.perbaruiPengguna(penggunaDiperbarui);
      if (hasil > 0) {
        penggunaAktif.value = penggunaDiperbarui;
        _logger.i('Profil berhasil diperbarui');
        return true;
      }
      return false;
    } catch (e) {
      _logger.e('Error saat memperbarui profil: $e');
      rethrow;
    }
  }
}
