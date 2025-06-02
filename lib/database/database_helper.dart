import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/riwayat.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('paketku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Buat tabel riwayat jika belum ada
          await db.execute('''
            CREATE TABLE IF NOT EXISTS riwayat (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              no_resi TEXT NOT NULL,
              kurir TEXT NOT NULL,
              status TEXT NOT NULL,
              tanggal TEXT NOT NULL,
              FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
          ''');
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        nama_lengkap TEXT,
        alamat TEXT,
        no_hp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE riwayat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        no_resi TEXT NOT NULL,
        kurir TEXT NOT NULL,
        status TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // CRUD Operations
  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // Riwayat CRUD Operations
  Future<int> createRiwayat(Riwayat riwayat) async {
    final db = await database;
    return await db.insert('riwayat', riwayat.toMap());
  }

  Future<List<Riwayat>> getRiwayatByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'riwayat',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'tanggal DESC',
    );
    return List.generate(maps.length, (i) => Riwayat.fromMap(maps[i]));
  }

  Future<int> deleteRiwayat(int id) async {
    final db = await database;
    return await db.delete(
      'riwayat',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllRiwayatByUserId(int userId) async {
    final db = await database;
    return await db.delete(
      'riwayat',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
