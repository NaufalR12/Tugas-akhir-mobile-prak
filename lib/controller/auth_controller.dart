import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcrypt/bcrypt.dart';
import '../database/database_helper.dart';
import '../model/user.dart';
import 'package:paketku/controller/riwayat_controller.dart';

class AuthController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;
  RxBool isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      final users = await _dbHelper.getAllUsers();
      final user =
          users.firstWhere((u) => u.id == userId, orElse: () => null as User);
      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
      }
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? namaLengkap,
    String? alamat,
    String? noHp,
  }) async {
    try {
      // Check if username or email already exists
      final existingUser = await _dbHelper.getUserByUsername(username);
      final existingEmail = await _dbHelper.getUserByEmail(email);

      if (existingUser != null) {
        throw 'Username sudah digunakan';
      }
      if (existingEmail != null) {
        throw 'Email sudah digunakan';
      }

      // Hash password
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Create new user
      final user = User(
        username: username,
        email: email,
        password: hashedPassword,
        namaLengkap: namaLengkap,
        alamat: alamat,
        noHp: noHp,
      );

      final id = await _dbHelper.createUser(user);
      if (id > 0) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = await _dbHelper.getUserByUsername(username);
      if (user == null) {
        throw 'Username tidak ditemukan';
      }

      final isPasswordValid = BCrypt.checkpw(password, user.password);
      if (!isPasswordValid) {
        throw 'Password salah';
      }

      // Save login status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id!);

      currentUser.value = user;
      isLoggedIn.value = true;
      // Trigger reload riwayat
      Get.find<RiwayatController>().loadRiwayat();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    currentUser.value = null;
    isLoggedIn.value = false;
    // Trigger reload riwayat
    Get.find<RiwayatController>().loadRiwayat();
  }

  Future<bool> updateProfile({
    required int userId,
    String? namaLengkap,
    String? alamat,
    String? noHp,
  }) async {
    try {
      final user = currentUser.value;
      if (user == null) throw 'User tidak ditemukan';

      final updatedUser = User(
        id: userId,
        username: user.username,
        email: user.email,
        password: user.password,
        namaLengkap: namaLengkap ?? user.namaLengkap,
        alamat: alamat ?? user.alamat,
        noHp: noHp ?? user.noHp,
      );

      final result = await _dbHelper.updateUser(updatedUser);
      if (result > 0) {
        currentUser.value = updatedUser;
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
