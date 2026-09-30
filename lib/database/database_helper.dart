import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // ============================================================
  // INITIALIZE DATABASE
  // ============================================================

  Future<Database> _initDatabase() async {
    final String databasePath = await getDatabasesPath();

    final String path = join(
      databasePath,
      'flowly.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ============================================================
  // CREATE USER
  // ============================================================

  Future<int> createUser({
    String? name,
    required String email,
    required String password,
  }) async {
    final db = await database;

    return await db.insert(
      'users',
      {
        'name': name ?? '',
        'email': email,
        'password': password,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // ============================================================
  // CHECK EMAIL
  // ============================================================

  Future<bool> emailExists(String email) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // ============================================================
  // LOGIN USER
  // ============================================================

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [
        email,
        password,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ============================================================
  // GET USER BY ID
  // ============================================================

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ============================================================
  // GET ALL USERS
  // ============================================================

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;

    return await db.query(
      'users',
      orderBy: 'id DESC',
    );
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}