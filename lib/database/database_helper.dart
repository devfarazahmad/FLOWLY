import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._internal();

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return instance;
  }

  static Database? _database;

  // ============================================================
  // DATABASE
  // ============================================================

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
    final String databasePath =
        await getDatabasesPath();

    final String path = join(
      databasePath,
      'flowly.db',
    );

    return await openDatabase(
      path,

      // IMPORTANT:
      // We increased the version because we are
      // adding daily_entries.
      version: 2,

      onCreate: (db, version) async {
        // --------------------------------------------------------
        // USERS
        // --------------------------------------------------------

        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        // --------------------------------------------------------
        // DAILY ENTRIES
        // --------------------------------------------------------

        await db.execute('''
          CREATE TABLE daily_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,

            user_id INTEGER NOT NULL,

            entry_date TEXT NOT NULL,

            mood TEXT,

            gratitude TEXT,

            today_tasks TEXT,

            future_goals TEXT,

            wrong_today TEXT,

            learned_today TEXT,

            lesson TEXT,

            updated_at TEXT NOT NULL,

            UNIQUE(user_id, entry_date)
          )
        ''');
      },

      // ========================================================
      // DATABASE UPGRADE
      // ========================================================

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS daily_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,

              user_id INTEGER NOT NULL,

              entry_date TEXT NOT NULL,

              mood TEXT,

              gratitude TEXT,

              today_tasks TEXT,

              future_goals TEXT,

              wrong_today TEXT,

              learned_today TEXT,

              lesson TEXT,

              updated_at TEXT NOT NULL,

              UNIQUE(user_id, entry_date)
            )
          ''');
        }
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
        'created_at':
            DateTime.now().toIso8601String(),
      },
      conflictAlgorithm:
          ConflictAlgorithm.abort,
    );
  }

  // ============================================================
  // CHECK EMAIL
  // ============================================================

  Future<bool> emailExists(
    String email,
  ) async {
    final db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
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

    final List<Map<String, dynamic>> result =
        await db.query(
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

  Future<Map<String, dynamic>?> getUserById(
    int id,
  ) async {
    final db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
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

  Future<int> deleteUser(
    int id,
  ) async {
    final db = await database;

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============================================================
  // SAVE TODAY ENTRY
  // ============================================================

  Future<int> saveTodayEntry({
    required int userId,
    required String entryDate,
    required String mood,
    required List<String> gratitude,
    required List<String> todayTasks,
    required List<String> futureGoals,
    required List<String> wrongToday,
    required List<String> learnedToday,
    required String lesson,
  }) async {
    final db = await database;

    final Map<String, dynamic> data = {
      'user_id': userId,

      'entry_date': entryDate,

      'mood': mood,

      'gratitude': jsonEncode(gratitude),

      'today_tasks': jsonEncode(todayTasks),

      'future_goals': jsonEncode(futureGoals),

      'wrong_today': jsonEncode(wrongToday),

      'learned_today': jsonEncode(learnedToday),

      'lesson': lesson,

      'updated_at':
          DateTime.now().toIso8601String(),
    };

    return await db.insert(
      'daily_entries',
      data,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  // ============================================================
  // GET TODAY ENTRY
  // ============================================================

  Future<Map<String, dynamic>?> getTodayEntry({
    required int userId,
    required String entryDate,
  }) async {
    final db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
      'daily_entries',
      where:
          'user_id = ? AND entry_date = ?',
      whereArgs: [
        userId,
        entryDate,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ============================================================
  // GET ALL DAILY ENTRIES FOR USER
  // ============================================================

  Future<List<Map<String, dynamic>>>
      getDailyEntries({
    required int userId,
  }) async {
    final db = await database;

    return await db.query(
      'daily_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'entry_date DESC',
    );
  }

  // ============================================================
  // DELETE TODAY ENTRY
  // ============================================================

  Future<int> deleteTodayEntry({
    required int userId,
    required String entryDate,
  }) async {
    final db = await database;

    return await db.delete(
      'daily_entries',
      where:
          'user_id = ? AND entry_date = ?',
      whereArgs: [
        userId,
        entryDate,
      ],
    );
  }
}