import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/riwayat.dart';
import 'package:logger/logger.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final _logger = Logger();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'goshipp.db');
    _logger.d('Inisialisasi database di: $path');

    // Hapus database lama jika ada
    await deleteDatabase(path);
    _logger.d('Database lama dihapus');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    _logger.d('Membuat tabel database');
    await db.execute('''
      CREATE TABLE pengguna(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_pengguna TEXT UNIQUE,
        email TEXT UNIQUE,
        kata_sandi TEXT,
        nama_lengkap TEXT,
        alamat TEXT,
        nomor_hp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE riwayat(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_pengguna INTEGER,
        nomor_resi TEXT,
        kurir TEXT,
        tanggal TEXT,
        status TEXT,
        FOREIGN KEY (id_pengguna) REFERENCES pengguna (id)
      )
    ''');
    _logger.i('Tabel berhasil dibuat');
  }

  Future<int> tambahPengguna(User pengguna) async {
    final db = await database;
    try {
      final id = await db.insert('pengguna', {
        'nama_pengguna': pengguna.namaPengguna,
        'email': pengguna.email,
        'kata_sandi': pengguna.kataSandi,
        'nama_lengkap': pengguna.namaLengkap,
        'alamat': pengguna.alamat,
        'nomor_hp': pengguna.nomorHp,
      });
      _logger.i('Pengguna berhasil ditambahkan dengan ID: $id');
      return id;
    } catch (e) {
      _logger.e('Error saat menambahkan pengguna: $e');
      rethrow;
    }
  }

  Future<User?> cariPengguna(String namaPengguna) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'pengguna',
        where: 'nama_pengguna = ?',
        whereArgs: [namaPengguna],
      );
      _logger.d('Mencari pengguna dengan nama: $namaPengguna');
      if (maps.isNotEmpty) {
        _logger.i('Pengguna ditemukan: ${maps.first['nama_pengguna']}');
        return User.fromMap(maps.first);
      }
      _logger.w('Pengguna tidak ditemukan: $namaPengguna');
      return null;
    } catch (e) {
      _logger.e('Error saat mencari pengguna: $e');
      rethrow;
    }
  }

  Future<User?> cariEmail(String email) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'pengguna',
        where: 'email = ?',
        whereArgs: [email],
      );
      _logger.d('Mencari pengguna dengan email: $email');
      if (maps.isNotEmpty) {
        _logger.i('Pengguna ditemukan dengan email: $email');
        return User.fromMap(maps.first);
      }
      _logger.w('Pengguna tidak ditemukan dengan email: $email');
      return null;
    } catch (e) {
      _logger.e('Error saat mencari email: $e');
      rethrow;
    }
  }

  Future<int> perbaruiPengguna(User pengguna) async {
    final db = await database;
    try {
      final result = await db.update(
        'pengguna',
        {
          'nama_lengkap': pengguna.namaLengkap,
          'alamat': pengguna.alamat,
          'nomor_hp': pengguna.nomorHp,
        },
        where: 'id = ?',
        whereArgs: [pengguna.id],
      );
      _logger.i('Pengguna berhasil diperbarui: ${pengguna.namaPengguna}');
      return result;
    } catch (e) {
      _logger.e('Error saat memperbarui pengguna: $e');
      rethrow;
    }
  }

  Future<int> hapusPengguna(int id) async {
    final db = await database;
    try {
      // Hapus riwayat pengguna terlebih dahulu
      await db.delete(
        'riwayat',
        where: 'id_pengguna = ?',
        whereArgs: [id],
      );
      _logger.d('Riwayat pengguna dihapus untuk ID: $id');

      // Kemudian hapus pengguna
      final result = await db.delete(
        'pengguna',
        where: 'id = ?',
        whereArgs: [id],
      );
      _logger.i('Pengguna berhasil dihapus dengan ID: $id');
      return result;
    } catch (e) {
      _logger.e('Error saat menghapus pengguna: $e');
      rethrow;
    }
  }

  Future<int> tambahRiwayat(Riwayat riwayat) async {
    final db = await database;
    try {
      final id = await db.insert('riwayat', {
        'id_pengguna': riwayat.idPengguna,
        'nomor_resi': riwayat.nomorResi,
        'kurir': riwayat.kurir,
        'tanggal': riwayat.tanggal,
        'status': riwayat.status,
      });
      _logger.i('Riwayat berhasil ditambahkan dengan ID: $id');
      return id;
    } catch (e) {
      _logger.e('Error saat menambahkan riwayat: $e');
      rethrow;
    }
  }

  Future<List<Riwayat>> ambilRiwayat(int idPengguna) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'riwayat',
        where: 'id_pengguna = ?',
        whereArgs: [idPengguna],
        orderBy: 'tanggal DESC',
      );
      _logger.d('Mengambil riwayat untuk pengguna: $idPengguna');
      return List.generate(maps.length, (i) => Riwayat.fromMap(maps[i]));
    } catch (e) {
      _logger.e('Error saat mengambil riwayat: $e');
      rethrow;
    }
  }

  Future<int> hapusRiwayat(int id) async {
    final db = await database;
    try {
      final result = await db.delete(
        'riwayat',
        where: 'id = ?',
        whereArgs: [id],
      );
      _logger.i('Riwayat berhasil dihapus dengan ID: $id');
      return result;
    } catch (e) {
      _logger.e('Error saat menghapus riwayat: $e');
      rethrow;
    }
  }

  Future<int> hapusSemuaRiwayat(int idPengguna) async {
    final db = await database;
    try {
      final result = await db.delete(
        'riwayat',
        where: 'id_pengguna = ?',
        whereArgs: [idPengguna],
      );
      _logger.i('Semua riwayat dihapus untuk pengguna: $idPengguna');
      return result;
    } catch (e) {
      _logger.e('Error saat menghapus semua riwayat: $e');
      rethrow;
    }
  }
}
